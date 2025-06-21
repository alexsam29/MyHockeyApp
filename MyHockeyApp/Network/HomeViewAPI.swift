//
//  HomeViewAPI.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-29.
//

import Foundation

class HomeViewAPI {
    static let shared = HomeViewAPI()
    private init() {}
    let WEB_API_URL: String = "https://api-web.nhle.com"
    let STATS_API_URL = "https://api.nhle.com"

    func fetchSeasons() async throws -> [Year] {
        guard let url = URL(string: "\(WEB_API_URL)/v1/season") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        let json =
            try JSONSerialization.jsonObject(with: data, options: []) as? [Any]

        guard let yearArray = json as? [Int] else {
            throw NSError(domain: "Invalid format: expected [Int]", code: 0)
        }

        // Map years into [Year]
        let years = yearArray.enumerated().map { index, year in
            Year(
                id: index,
                value: year,
                displayYear: "\(year/10000) - \(year/10000 + 1)"
            )
        }

        return years
    }

    func fetchTeams() async throws -> [Team] {
        guard
            let url = URL(
                string:
                    "\(STATS_API_URL)/stats/rest/en/franchise?sort=fullName&include=lastSeason.id&include=firstSeason.id"
            )
        else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        struct TeamsResponse: Codable {
            let data: [Team]
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let teamsResponse = try decoder.decode(TeamsResponse.self, from: data)
        return teamsResponse.data
    }

    func fetchSkaterStats(
        for statType: StatType,
        seasonType: Season,
        year: Int,
        team: Team = Team()
    )
        async throws -> [Player]
    {
        let teamQuery = team.id != 0 ? "%20and%20team.franchiseId=\(team.id)" : ""
        let statField: String

        switch statType {
        case .points: statField = "points"
        case .goals: statField = "goals"
        case .assists: statField = "assists"
        default: statField = "points"
        }

        guard
            let url = URL(
                string:
                    "\(STATS_API_URL)/stats/rest/en/leaders/skaters/\(statField)?cayenneExp=season=\(year)%20and%20gameType=\(seasonType.id)\(teamQuery)"
            )
        else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        struct Response: Codable {
            let data: [RawPlayerStat]
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let responseData = try decoder.decode(Response.self, from: data)

        return responseData.data.map { raw in
            let statValue: Int
            switch statType {
            case .points: statValue = raw.points ?? 0
            case .goals: statValue = raw.goals ?? 0
            case .assists: statValue = raw.assists ?? 0
            default: statValue = 0
            }

            return Player(
                player: raw.player,
                value: statValue,
                statType: statType,
                team: raw.team
            )
        }
    }

}

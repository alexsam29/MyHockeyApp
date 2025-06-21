//
//  HomeViewModel.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-29.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var years: [Year] = []
    @Published var teams: [Team] = []
    @Published var pointLeaders: [Player] = []
    @Published var goalLeaders: [Player] = []
    @Published var assistLeaders: [Player] = []

    func loadSeasons() async {
        do {
            let data = try await HomeViewAPI.shared.fetchSeasons()
            self.years = data
        } catch {
            print("Error fetching seasons: \(error)")
        }
    }

    func loadTeams() async {
        do {
            let data = try await HomeViewAPI.shared.fetchTeams()
            self.teams = data
        } catch {
            print("Error fetching teams: \(error)")
        }
    }

    func loadPointLeaders(year: Year, seasonType: Season, team: Team) async {
        do {
            let data = try await HomeViewAPI.shared.fetchSkaterStats(
                for: .points,
                seasonType: seasonType,
                year: year.value,
                team: team
            )
            self.pointLeaders = data
        } catch {
            print("Error fetching point leaders: \(error)")
        }
    }
    
    func loadGoalsLeaders(year: Year, seasonType: Season, team: Team) async {
        do {
            let data = try await HomeViewAPI.shared.fetchSkaterStats(
                for: .goals,
                seasonType: seasonType,
                year: year.value,
                team: team
            )
            self.goalLeaders = data
        } catch {
            print("Error fetching point leaders: \(error)")
        }
    }
    
    func loadAssistLeaders(year: Year, seasonType: Season, team: Team) async {
        do {
            let data = try await HomeViewAPI.shared.fetchSkaterStats(
                for: .assists,
                seasonType: seasonType,
                year: year.value,
                team: team
            )
            self.assistLeaders = data
        } catch {
            print("Error fetching point leaders: \(error)")
        }
    }
    
    func loadAllStats(year: Year, seasonType: Season, team: Team) async {
        await loadPointLeaders(year: year, seasonType: seasonType, team: team)
        await loadGoalsLeaders(year: year, seasonType: seasonType, team: team)
        await loadAssistLeaders(year: year, seasonType: seasonType, team: team)
    }

    func loadSampleTeams() {
        struct Response: Codable {
            let data: [Team]
        }

        if let response: Response = loadLocalJSON(filename: "teams") {
            self.teams = response.data
        }
    }

    func loadSamplePointLeaders() {
        struct Response: Codable {
            let data: [RawPlayerStat]
        }
        if let response: Response = loadLocalJSON(filename: "pointLeaders") {
            self.pointLeaders = response.data.map {
                Player(
                    player: $0.player,
                    value: $0.points ?? 0,
                    statType: .points,
                    team: $0.team
                )
            }
        }
    }

    func loadSampleYears() {
        if let rawValues: [Int] = loadLocalJSON(filename: "years") {
            self.years = rawValues.map {
                let uuid = UUID()
                return Year(
                    id: uuid.uuidString.hashValue,
                    value: $0,
                    displayYear: "\($0/10000) - \($0/10000+1) "
                )
            }
        }
    }
}

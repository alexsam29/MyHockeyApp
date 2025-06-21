//
//  Player.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-30.
//

import Foundation

struct Player: Identifiable, Codable {
    var id: Int { player.id }
    let player: PlayerInfo
    let value: Int
    let statType: StatType
    let team: TeamInfo
}

enum StatType: String, Codable {
    case points, goals, assists, unknown
}

struct PlayerInfo: Codable {
    let id: Int
    let currentTeamId: Int?
    let firstName: String?
    let fullName: String?
    let lastName: String?
    let positionCode: String?
    let sweaterNumber: Int?
}

struct TeamInfo: Codable {
    let id: Int
    let franchiseId: Int?
    let fullName: String?
    let leagueId: Int?
    let logos: [TeamLogo]?
    let rawTricode: String?
    let triCode: String?
}

struct TeamLogo: Codable {
    let id: Int
    let background: String?
    let endSeason: Int?
    let secureUrl: String?
    let startSeason: Int?
    let teamId: Int?
    let url: String?
}

struct RawPlayerStat: Codable {
    let player: PlayerInfo
    let team: TeamInfo
    let points: Int?
    let goals: Int?
    let assists: Int?
}

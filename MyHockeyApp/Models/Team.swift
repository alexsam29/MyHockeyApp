//
//  Team.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-30.
//

import Foundation

struct Team: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let firstSeason: SeasonReference
    let lastSeason: SeasonReference?
    let fullName: String
    let teamCommonName: String
    let teamPlaceName: String

    struct SeasonReference: Codable, Hashable {
        let id: Int

        init(id: Int = 0) {
            self.id = id
        }
    }

    init(
        id: Int = 0,
        firstSeason: SeasonReference = SeasonReference(),
        lastSeason: SeasonReference? = nil,
        fullName: String = "",
        teamCommonName: String = "",
        teamPlaceName: String = ""
    ) {
        self.id = id
        self.firstSeason = firstSeason
        self.lastSeason = lastSeason
        self.fullName = fullName
        self.teamCommonName = teamCommonName
        self.teamPlaceName = teamPlaceName
    }
}

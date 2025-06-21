//
//  Season.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-30.
//

import Foundation

enum Season: String, CaseIterable, Identifiable {
    case regularSeason = "2"
    case playoffs = "3"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .regularSeason:
            return "Regular Season"
        case .playoffs:
            return "Playoffs"
        }
    }
}

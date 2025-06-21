//
//  Season.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-29.
//
import Foundation

struct Year: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let value: Int
    var displayYear: String
    
    init(id: Int = 0, value: Int = 0, displayYear: String = "") {
        self.id = id
        self.value = value
        self.displayYear = displayYear
    }
}

//
//  LoadSampleData.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-30.
//
import Foundation

func loadLocalJSON<T: Decodable>(filename: String) -> T? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        print("Failed to find \(filename) in bundle.")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Failed to decode \(filename): \(error)")
        return nil
    }
}

//
//  MyHockeyAppApp.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-29.
//

import SwiftUI

@main
struct MyHockeyAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: HomeViewModel())
        }
    }
}

//
//  ContentView.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-29.
//

import SwiftUI

struct ContentView: View {
    @State var selectedYear: Year = Year(value: 0)
    @State var selectedSeason: Season = .regularSeason
    @State var selectedTeam: Team?
    @ObservedObject var viewModel = HomeViewModel()
    @State var isLoading: Bool = false
    @State var headerLabel: String = Season.regularSeason.displayName
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Picker(selection: $selectedYear) {
                            Text("Year").tag(Year(value: 0))
                            ForEach(viewModel.years.reversed()) { year in
                                Text(year.displayYear).tag(year)
                            }
                        } label: {
                            Text("Year")
                            Text("Select a Year").font(.caption)
                        }.pickerStyle(.automatic)
                        Picker(selection: $selectedTeam) {
                            Text("All Teams").tag(nil as Team?)
                            ForEach(viewModel.teams) { team in
                                Text(team.fullName).tag(team as Team?)
                            }
                        } label: {
                            Text("Team")
                            Text("Select a Team").font(.caption)
                        }
                        Picker(selection: $selectedSeason) {
                            ForEach(Season.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        } label: {
                            Text("Season")
                            Text("Select Season Type").font(.caption)
                        }.pickerStyle(.segmented).padding(.bottom)
                        Button(action: {
                            Task {
                                withLoading {
                                    await viewModel.loadAllStats(
                                        year: selectedYear,
                                        seasonType: selectedSeason,
                                        team: selectedTeam ?? Team()
                                    )
                                }
                                headerLabel = selectedSeason.displayName
                            }
                        }) {
                            Spacer()
                            Text("Search")
                            Spacer()
                        }.buttonStyle(.borderedProminent)
                    }
                    Section(
                        header: Text(
                            "\(selectedYear.displayYear)  | \(headerLabel)"
                        ).font(.title2).textCase(nil)
                    ) {
                        if isLoading {
                            ProgressView()
                        } else {
                            StatListView(
                                viewModel: viewModel,
                                statType: StatType.points
                            )
                            StatListView(
                                viewModel: viewModel,
                                statType: StatType.goals
                            )
                            StatListView(
                                viewModel: viewModel,
                                statType: StatType.assists
                            )
                        }
                    }
                }

                Spacer()
            }
            .task {
                withLoading {
                    await viewModel.loadSeasons()
                    selectedYear = viewModel.years.last ?? Year(value: 0)
                    await viewModel.loadTeams()
                    await viewModel.loadAllStats(
                        year: selectedYear,
                        seasonType: selectedSeason,
                        team: Team()
                    )
                }
            }
            .navigationTitle("NHL Stat Search")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }

    func withLoading(_ operation: @escaping () async -> Void) {
        Task {
            await MainActor.run { isLoading = true }
            await operation()
            await MainActor.run { isLoading = false }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = HomeViewModel()
        vm.loadSampleTeams()
        vm.loadSamplePointLeaders()
        vm.loadSampleYears()
        return ContentView(viewModel: vm)
    }
}

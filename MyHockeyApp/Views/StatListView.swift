//
//  StatListView.swift
//  MyHockeyApp
//
//  Created by Alex Samaniego on 2025-05-30.
//

import SwiftUI

struct StatListView: View {
    @State var isExpanded: Bool = true
    @ObservedObject var viewModel: HomeViewModel
    let statType: StatType
    var body: some View {
        let players: [Player] = {
            switch statType {
            case .points: return viewModel.pointLeaders
            case .goals: return viewModel.goalLeaders
            case .assists: return viewModel.assistLeaders
            case .unknown:
                return []
            }
        }()
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                HStack {
                    Text("Team").font(.caption).fontWeight(.thin).frame(
                        maxWidth: 70,
                        alignment: .leading
                    )
                    Spacer()
                    Text("Name").font(.caption).multilineTextAlignment(
                        .leading
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    Text("\(statType.rawValue.capitalized)").font(.caption)
                        .frame(
                            maxWidth: 50,
                            alignment: .trailing
                        )
                }
                if players.isEmpty {
                    Text("No data available.").foregroundColor(.secondary)
                }
                List(players) { player in
                    HStack {
                        Text(player.team.fullName ?? "")
                            .font(.caption2).fontWeight(.thin)
                            .frame(
                                maxWidth: 70,
                                alignment: .leading
                            )
                        Text(player.player.fullName ?? "")
                            .multilineTextAlignment(.leading)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        Text("\(player.value)")
                            .frame(
                                maxWidth: 50,
                                alignment: .trailing
                            )
                    }
                }
            },
            label: {
                Text("\(statType.rawValue.capitalized)")
                    .font(.title2).bold()
            }
        )

    }
}

#Preview {
    let vm = HomeViewModel()
    vm.loadSamplePointLeaders()
    return StatListView(viewModel: vm, statType: StatType.points)
}

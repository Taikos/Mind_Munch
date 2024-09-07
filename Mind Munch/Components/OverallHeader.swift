//
//  OverallHeader.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import RiveRuntime

struct OverallHeader: View {
    @Bindable var userStats: UserStats
    @Binding var selectedTab: Int
    @State private var showSettingsSheet = false

    var body: some View {
        VStack {
            HStack {
                RiveViewModel(fileName: "Master_3").view()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .padding(.leading, 10.0)
                    .onTapGesture {
                        SoundManager.shared.stopSound()
                        SoundManager.shared.playSound(soundName: "big-punch-with-whoosh-103638")
                    }

                Spacer()

                Button(action: {
                    HapticFeedbackManager.shared.hapticFeedback(.light)

                    selectedTab = 2
                }) {
                    HStack {
                        Image("heart-front-color")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        Text("\(userStats.remainingLives)")
                    }
                    .padding()
                }

                Button(action: {
                    HapticFeedbackManager.shared.hapticFeedback(.light)

                    openSettingsView()
                }) {
                    Image("tool-front-color")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding()
                }
            }
            .padding(.horizontal)

            Spacer()

        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView()
        }
    }

    private func openSettingsView() {
        showSettingsSheet = true
    }
}

#Preview {
    OverallHeader(userStats: UserStats(), selectedTab: .constant(0))
}

//
//  PreGameView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import AVKit
import RiveRuntime

// MARK: - Pre-Game
struct PreGameView: View {
    @Binding var showPreGameView: Bool  // Binding to change game state from the Saga Map
    @Bindable var userStats: UserStats
    var body: some View {
        ZStack {
            // Background
            OverallBackground()

            VStack {
                // Video Player (No controls)
                RiveViewModel(fileName: "Master_3").view()
                    .frame(height: 90)
                    .cornerRadius(20)
                    .padding()
                    .onTapGesture {
                        SoundManager.shared.stopSound()

                        SoundManager.shared.playSound(soundName: "ready-fight-37973")
                    }
                CustomVideoPlayerView()

                Spacer()

                // Bottom half-sheet for competences and Go button
                VStack(spacing: 20) {
                    // Competence Information
                    Text("Training Competences")
                        .font(.title)
                        .foregroundColor(.mainBlueDark)
                        .padding(.top)

                    Text("Level \(userStats.highestLevelReached) - Score \(userStats.score)")
                        .font(.body)
                        .fontWeight(.thin)
                        .foregroundColor(.mainBlueDark)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        CompetenceView(iconName: "hammer.fill", title: "Decision Making", description: "Improve alternative analysis and decision quality.")
                        CompetenceView(iconName: "puzzlepiece.fill", title: "Problem Solving", description: "Helps you find solutions to complex problems.")
                        CompetenceView(iconName: "eye.fill", title: "Visual Processing Speed", description: "Enhances decision making and visual distractions management.")
                    }
                    .padding()

                    // Go Button
                    BottomButton(disableCondition: false) {
                        showPreGameView = false  //
                        HapticFeedbackManager.shared.hapticFeedback(.strong)

                    }
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding()
            }
        }
    }
}

#Preview {
    PreGameView(showPreGameView: .constant(true), userStats: UserStats())
}


struct BottomButton: View {
    let disableCondition: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
            HapticFeedbackManager.shared.hapticFeedback(.strong)
        }) {
            Text("Next")
                .frame(width: 150)
                .padding()
                .background(disableCondition == true ? Color.mainGreyPastel : Color.mainBlueFluo)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(disableCondition)
    }
}

struct CompetenceView: View {
    let iconName: String
    let title: String
    let description: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.mainBlueBold)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
        }
    }
}


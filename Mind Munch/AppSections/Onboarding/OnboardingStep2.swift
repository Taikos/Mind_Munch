//
//  OnboardingStep2.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import SwiftData

struct OnboardingStep2: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var currentStep: Int
    @State private var pseudo = ""
    @Bindable var userStats: UserStats

    var body: some View {
        VStack {
            HeaderView(title: "Choose your Pseudo", subtitle: "This will be your in-game name.")
            
            Spacer()
            
            TextField("Enter your Pseudo", text: $pseudo)
                .padding()
                .background(Color.mainBlueDark.opacity(0.3))
                .cornerRadius(10)
                .padding()
            
            Spacer()
            
            Button(action: {
                HapticFeedbackManager.shared.hapticFeedback(.strong)

                userStats.name = pseudo
                saveUserStats()
                currentStep += 1
            }) {
                Text("Next")
                    .frame(width: 150)
                    .padding()
                    .background(pseudo.isEmpty ? Color.mainBlueDark : Color.mainBlueFluo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(pseudo.isEmpty)
        }
        .padding()
    }

    private func saveUserStats() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save UserStats: \(error)")
        }
    }
}

#Preview {
    OnboardingStep2(currentStep: .constant(2), userStats: UserStats())
}

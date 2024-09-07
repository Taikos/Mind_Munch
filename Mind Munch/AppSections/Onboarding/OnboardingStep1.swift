//
//  OnboardingStep1.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

struct OnboardingStep1: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var currentStep: Int
    @State private var selectedGender: String? = nil
    @State private var selectedPP: String? = nil
    @Bindable var userStats: UserStats

    // Random profile pictures for each gender
    private let femalePPs = ["pp1", "pp2", "pp3"]
    private let malePPs = ["pp4", "pp5", "pp6"]

    var body: some View {
        VStack {
            HeaderView(title: "Choose your Gender", subtitle: "This will be used for better analysis in your account.")

            Spacer()

            VStack(spacing: 16) {
                // Gender buttons with random profile pictures for each gender
                genderButton(title: "Male", selectedGender: $selectedGender, selectedPP: $selectedPP, ppOptions: malePPs)
                genderButton(title: "Female", selectedGender: $selectedGender, selectedPP: $selectedPP, ppOptions: femalePPs)
            }
            .padding()

            Spacer()

            Button(action: {
                userStats.pic = selectedPP ?? ""
                HapticFeedbackManager.shared.hapticFeedback(.strong)

                saveUserStats()

                currentStep += 1
            }) {
                Text("Next")
                    .frame(width: 150)
                    .padding()
                    .background(selectedGender == nil ? Color.mainBlueDark : Color.mainBlueFluo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedGender == nil)
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

    // Gender button with random profile picture selection
    private func genderButton(title: String, selectedGender: Binding<String?>, selectedPP: Binding<String?>, ppOptions: [String]) -> some View {
        Button(action: {
            selectedGender.wrappedValue = title
            if !ppOptions.isEmpty {
                selectedPP.wrappedValue = ppOptions.randomElement()  
                // Randomly select a profile picture
            } else {
                selectedPP.wrappedValue = nil  
                // No profile picture for "Other"
                // Has been removed 
            }
        }) {
            HStack {
                if let pp = selectedPP.wrappedValue, selectedGender.wrappedValue == title {
                    Image(pp)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.trailing)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.trailing)
                }

                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedGender.wrappedValue == title ? Color.white : Color.mainBlueDark.opacity(0.1))
                    .foregroundColor(selectedGender.wrappedValue == title ? .black : .white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    OnboardingStep1(currentStep: .constant(1), userStats: UserStats())
}

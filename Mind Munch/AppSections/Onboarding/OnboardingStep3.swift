//
//  OnboardingStep3.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

struct OnboardingStep3: View {
    @Binding var currentStep: Int
    @State private var selectedFrequency: Int? = nil
    
    var body: some View {
        VStack {
            HeaderView(title: "How many brain exercises are you doing per month?", subtitle: "Did you know that games, coding, and similar activities are brain exercises?")
            
            Spacer()
            
            VStack(spacing: 16) {
                RadioButton(title: "0-10", description: "Just starting out", isSelected: selectedFrequency == 1) {
                    selectedFrequency = 1
                }
                
                RadioButton(title: "10-40", description: "Staying engaged", isSelected: selectedFrequency == 2) {
                    selectedFrequency = 2
                }
                
                RadioButton(title: "40+", description: "Brain workout warrior", isSelected: selectedFrequency == 3) {
                    selectedFrequency = 3
                }
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                HapticFeedbackManager.shared.hapticFeedback(.strong)

                currentStep += 1
            }) {
                Text("Next")
                    .frame(width: 150)
                    .padding()
                    .background(selectedFrequency == nil ? Color.mainBlueDark : Color.mainBlueFluo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedFrequency == nil)
        }
        .padding()
    }
}

#Preview {
    OnboardingStep3(currentStep: .constant(3))
}

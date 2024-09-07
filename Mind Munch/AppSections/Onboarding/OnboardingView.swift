//
//  OnboardingView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    
    @Bindable var userStats: UserStats
    @State private var wave1Offset: CGFloat = 0
    @State private var wave2Offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            OverallBackground().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                HStack {
                    Button(action: {
                        HapticFeedbackManager.shared.hapticFeedback(.strong)

                        if currentStep > 0 {
                            currentStep -= 1
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.black)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                            .disabled(currentStep == 0  ? true:false)
                    }
                    
                    ProgressView(value: Double(currentStep), total: 6)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.white))
                        .padding(.horizontal)
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                // Onboarding Steps
                switch currentStep {
                case 0:
                    OnboardingStep0(currentStep: $currentStep)
                case 1:
                    OnboardingStep1(currentStep: $currentStep, userStats: userStats)
                case 2:
                    OnboardingStep2(currentStep: $currentStep, userStats: userStats)
                case 3:
                    OnboardingStep3(currentStep: $currentStep)
                case 4:
                    OnboardingStep4(currentStep: $currentStep)
                case 5:
                    OnboardingStep5(currentStep: $currentStep)
                case 6:
                    OnboardingStep6(currentStep: $currentStep, userStats: userStats)
                default:
                    OnboardingStep1(currentStep: $currentStep, userStats: userStats)
                }
                
                Spacer()
            }
            ZStack {
                WaveView(waveOffset: wave1Offset)
                    .fill(Color.mainBlueFluo.opacity(0.3))
                    .frame(height: 200)
                
                WaveView(waveOffset: wave2Offset)
                    .fill(Color.mainBlueFluo.opacity(0.2))
                    .frame(height: 200)
                    .offset(y: 20)
            }
            .offset(y: UIScreen.main.bounds.height / 2)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                self.wave1Offset = 2 * .pi
            }
            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                self.wave2Offset = 2 * .pi
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    OnboardingView(userStats: UserStats())
}

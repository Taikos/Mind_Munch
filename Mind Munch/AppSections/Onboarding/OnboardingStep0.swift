//
//  OnboardingStep0.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import RiveRuntime

struct OnboardingStep0: View {
    @State private var heights: [CGFloat] = Array(repeating: 1.5, count: 7)
    @State private var currentTextIndex = 0
    @State private var displayedText = ""
    @State private var animationProgress: Double = 0
    @State private var isTextFullyDisplayed = false
    @State private var showContinueButton = false
    @State private var navigateToOnboarding = false

    let welcomeText = "Welcome to Mind Munch, the app to keep your brain sharp and healthy through engaging exercises!"
    @Binding var currentStep: Int

    @State private var wave1Offset: CGFloat = 0
    @State private var wave2Offset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                OverallBackground().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()

                    RiveViewModel(fileName: "Master_3").view()
                        .scaledToFill()
                        .frame(height: 300)
                        .padding()

                    Spacer()

                    Text(displayedText)
                        .font(.LufgaThinFont(size: 20))
                        .multilineTextAlignment(.center)
                        .padding()

                    if showContinueButton {
                        Button("Continue") {
                            HapticFeedbackManager.shared.hapticFeedback(.strong)
                            currentStep += 1
                        }
                        .frame(width: 150)
                        .padding()
                        .background(Color.mainBlueFluo)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.top)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.5), value: showContinueButton)
                    }

                    Spacer()
                }
                .padding()
                .onAppear {
                    startTypingEffect() // Begin the typing animation
                    startWaveAnimation()
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
            .navigationBarBackButtonHidden(true)
        }
    }

    // Wave animation start
    private func startWaveAnimation() {
        withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
            self.wave1Offset = 2 * .pi
        }
        withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
            self.wave2Offset = 2 * .pi
        }
    }

    // Typing effect for the welcome message
    private func startTypingEffect() {
        displayedText = ""
        let totalText = Array(welcomeText)

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentTextIndex < totalText.count {
                displayedText.append(totalText[currentTextIndex])
                currentTextIndex += 1
            } else {
                timer.invalidate()
                isTextFullyDisplayed = true
                withAnimation {
                    showContinueButton = true                }
            }
        }
    }
}
    
#Preview {
    OnboardingStep0(currentStep: .constant(0))
}

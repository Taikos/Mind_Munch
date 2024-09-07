//
//  OnboardingStep6.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import AppTrackingTransparency
import SwiftData

struct OnboardingStep6: View {
    @Binding var currentStep: Int

    @State private var isAnimating = false
    @State private var currentSubtitleIndex = 0
    @State private var showCongratulations = false

    private let subtitles = [
        "Customizing your brain workout plan...",
        "Building your personalized experience...",
        "Final adjustments in progress...",
        "Almost there..."
    ]
    
    @Bindable var userStats: UserStats

    var body: some View {
        VStack(spacing: 30) {
            if showCongratulations {
                CongratulationView(userStats: userStats)
            } else {
                setupView
            }
        }
        .padding()
        .onAppear {
            self.isAnimating = true
            startSubtitleTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                requestTrackingAuthorization()
            }
        }
    }
    
    private var setupView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("We're preparing everything for you, \(userStats.name)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(subtitles[currentSubtitleIndex])
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .animation(.easeInOut, value: currentSubtitleIndex)
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1.0)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            Spacer()
        }
    }
    
    private func startSubtitleTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            currentSubtitleIndex = (currentSubtitleIndex + 1) % subtitles.count
            
            if currentSubtitleIndex == 0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showCongratulations = true
                    }
                }
            }
        }
    }
    
    private func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorized.")
                case .denied:
                    print("Tracking denied.")
                case .notDetermined:
                    print("Tracking not determined.")
                case .restricted:
                    print("Tracking restricted.")
                @unknown default:
                    print("Unknown tracking status.")
                }
            }
        }
    }
}

struct CongratulationView: View {
    @Bindable var userStats: UserStats
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("🎉 Congratulations, \(userStats.name)!")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("You're all set! Let's dive into your brain training journey.")
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                userStats.onboardingDone = true
                saveUserStats()  // Save the user's onboarding completion status
            }) {
                Text("Let's Get Started")
                    .frame(width: 150)
                    .padding()
                    .background(Color.mainBlueFluo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .transition(.opacity)
    }
    
    private func saveUserStats() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save user stats: \(error)")
        }
    }
}

#Preview {
    OnboardingStep6(currentStep: .constant(6), userStats: UserStats())
}

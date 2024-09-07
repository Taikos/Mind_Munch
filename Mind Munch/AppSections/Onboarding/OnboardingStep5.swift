//
//  OnboardingStep5.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import RiveRuntime

struct OnboardingStep5: View {
    @Binding var currentStep: Int
    @State private var isNotificationAllowed: Bool? = nil
    
    var body: some View {
        VStack {
            HeaderView(title: "Stay Informed", subtitle: "Mind Munch would like to send you notifications to keep you updated on your progress and new challenges.")

            RiveViewModel(fileName: "Master_3").view()
                .scaledToFill()
                .frame(height: 300)
                .padding()
                .cornerRadius(15)

            Spacer()

            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        HapticFeedbackManager.shared.hapticFeedback(.strong)

                        requestNotificationPermission(allow: false)
                    }) {
                        Text("Don’t Allow")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(isNotificationAllowed == false ? Color.black : Color.clear)
                            .foregroundColor(isNotificationAllowed == false ? .white : .black)
                    }

                    Divider()
                        .frame(height: 50)

                    Button(action: {
                        requestNotificationPermission(allow: true)
                    }) {
                        Text("Allow")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(isNotificationAllowed == true ? Color.black : Color.clear)
                            .foregroundColor(isNotificationAllowed == true ? .white : .black)
                    }
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
            .padding(.horizontal)

            Spacer()

            Text("You can manage notifications in settings anytime. We will only notify you about important updates and brain exercises.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                if isNotificationAllowed == nil {
                    requestNotificationPermission(allow: true)
                } else {
                    currentStep += 1
                }
            }) {
                Text("Next")
                    .frame(width: 150)
                    .padding()
                    .background(isNotificationAllowed == nil ? Color.mainBlueDark : Color.mainBlueFluo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(isNotificationAllowed == nil)
        }
        .padding()
        .onAppear {
            checkNotificationStatus()
        }
    }

    private func requestNotificationPermission(allow: Bool) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Request permission if not determined yet
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    DispatchQueue.main.async {
                        self.isNotificationAllowed = granted
                        if granted || !allow {
                            self.currentStep += 1
                        }
                    }
                }
            case .denied, .provisional:
                // If denied or provisional, proceed based on user's choice
                DispatchQueue.main.async {
                    self.isNotificationAllowed = false
                    if !allow {
                        self.currentStep += 1
                    }
                }
            case .authorized:
                // If already authorized, proceed
                DispatchQueue.main.async {
                    self.isNotificationAllowed = true
                    self.currentStep += 1
                }
            case .ephemeral:
                // If ephemeral, proceed
                DispatchQueue.main.async {
                    self.isNotificationAllowed = true
                    self.currentStep += 1
                }
            @unknown default:
                break
            }
        }
    }

    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationAllowed = settings.authorizationStatus == .authorized
            }
        }
    }
}

#Preview {
    OnboardingStep5(currentStep: .constant(5))
}

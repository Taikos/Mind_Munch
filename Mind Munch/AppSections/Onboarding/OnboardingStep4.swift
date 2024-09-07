//
//  OnboardingStep4.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import StoreKit

struct OnboardingStep4: View {
    @Binding var currentStep: Int
    let appDownloadLink = "https://apps.apple.com/app/id6670610058"

    var body: some View {
        VStack {
            RatingView()
            Spacer()
            Button(action: {
                HapticFeedbackManager.shared.hapticFeedback(.strong)

                requestAppReview()
                currentStep += 1
            }) {
                Text("Next")
                    .frame(width: 150)
                    .padding()
                    .background(Color.mainBlueFluo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
    }

    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct RatingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HeaderView(title: "Rate Your Experience", subtitle: "Mind Munch was created to help you grow stronger mentally. Your feedback helps us improve!")

            HStack {
                Spacer()
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.mainOrangePastel)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.mainOrangePastel)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.mainOrangePastel)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.mainOrangePastel)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.mainOrangePastel)
                Spacer()
            }
            .padding()
            .background(Color.mainGreyLight.opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.mainBlueDark, lineWidth: 1)
            )

            Text("Join the community of brain exercisers!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: -10) {
                Spacer()
                Image("pp5")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.mainPinkPastel))
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 1)
                    )
                Image("pp4")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.mainBluePastel))
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 1)
                    )
                Image("pp3")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.mainGreyPastel))
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 1)
                    )
                Spacer()
            }
            .padding()

            HStack {
                Spacer()
                Text("+1.3K Mind Munch users are growing their cognitive skills!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ReviewCard(name: "John M.", image: "pp6", stars: 5, comment: "Mind Munch is incredible! It has become my daily go-to for improving my cognitive strength.", color: Color.mainBlueWhite)
                    ReviewCard(name: "Sarah T.", image: "pp1", stars: 5, comment: "This app makes brain training fun and challenging. I love how my progress is private yet impactful.", color: Color.mainPinkRegular)
                    ReviewCard(name: "Emily R.", image: "pp2", stars: 4, comment: "Mind Munch makes learning exciting, and I can see my improvement daily. This app is a must-have!", color: Color.mainGreyLight)
                }
            }
            .padding()
        }
    }
}

struct ReviewCard: View {
    let name: String
    let image: String
    let stars: Int
    let comment: String
    let color: Color

    var body: some View {
        HStack(alignment: .top) {
            Image(image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .background(Circle().foregroundColor(color))
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(name)
                        .font(.headline)
                        .bold()
                    Spacer()
                    ForEach(0..<stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.mainOrangePastel)
                            .scaledToFit()
                            .frame(width: 15)
                    }
                }

                Text("“\(comment)”")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .truncationMode(.tail)
                    .frame(maxWidth: 200, alignment: .leading)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .padding()
        .background(Color.mainBlueDark.opacity(0.8))
        .cornerRadius(15)
    }
}

#Preview {
    OnboardingStep4(currentStep: .constant(4))
}

//
//  QuickShopView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI

import SwiftUI
import StoreKit

// MARK: - Double functions between Quick Shop and Shop / Could be improved

struct QuickShopView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var userStats: UserStats
    @State private var products: [Product] = []
    @State private var purchaseInProgress = false
    
    let productIdentifiers = [
        "com.gto.Mind_Munch.life",
        "com.gto.Mind_Munch.life5",
        "com.gto.Mind_Munch.life10"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Out of Lives!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Purchase additional lives to continue playing.")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                HStack {
                    Spacer()

                    if products.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else {
                        ForEach(products, id: \.id) { product in
                            ShopButton(
                                title: "\(product.displayName)",
                                subtitle: product.displayPrice, icon: "heart.fill",
                                action: {
                                    Task {
                                        await purchase(product: product)
                                    }
                                    HapticFeedbackManager.shared.hapticFeedback(.strong)
                                },
                                disabled: purchaseInProgress
                            )
                        }
                    }
                    Spacer()
                }
                
                Button(action: {
                    HapticFeedbackManager.shared.hapticFeedback(.medium)
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
                .padding(.top)
            }
            .padding()
        }
        .onAppear {
            Task {
                await fetchProducts()
            }
        }
    }
    
    private func fetchProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIdentifiers)
            products = storeProducts
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
        }
    }
    
    private func purchase(product: Product) async {
        purchaseInProgress = true
        defer { purchaseInProgress = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                if case .verified(_) = verification {
                    switch product.id {
                    case "com.gto.Mind_Munch.life":
                        userStats.remainingLives += 1
                    case "com.gto.Mind_Munch.lifex5":
                        userStats.remainingLives += 5
                    case "com.gto.Mind_Munch.lifex10":
                        userStats.remainingLives += 10
                    default:
                        break
                    }
                    dismiss()
                } else {
                    print("Purchase failed verification.")
                }
            case .pending:
                print("Purchase pending.")
            case .userCancelled:
                print("Purchase cancelled.")
            @unknown default:
                print("Unknown purchase result.")
            }
        } catch {
            print("Failed to purchase product: \(error.localizedDescription)")
        }
    }
}

struct ShopButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    let disabled: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if !disabled {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = false
                    }
                    action()
                }
                HapticFeedbackManager.shared.hapticFeedback(.medium)
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(disabled ? .gray : .white)
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(disabled ? .gray : .white)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(disabled ? .gray.opacity(0.7) : .white.opacity(0.7))
            }
            .frame(width: 100, height: 100)
            .background(
                ZStack {
                    Circle()
                        .fill(disabled ? Color.gray.opacity(0.3) : Color.mainBlueFluo.opacity(0.8))
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .clear]),
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing))
                        .blendMode(.overlay)
                }
            )
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .disabled(disabled)
    }
}

#Preview {
    QuickShopView(userStats: UserStats())
        .modelContainer(for: [UserStats.self, GameRecord.self], inMemory: true)
}

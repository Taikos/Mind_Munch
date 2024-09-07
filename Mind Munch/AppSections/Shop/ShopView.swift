//
//  ShopView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI
import StoreKit

// MARK: - Double functions between Quick Shop and Shop / Could be improved

struct ShopView: View {
    @Environment(\.dismiss) var dismiss
        @Bindable var userStats: UserStats
        @State private var products: [Product] = []
        @State private var purchaseInProgress = false
        @State private var errorMessage: String?
        @Binding var selectedTab: Int
        
        let productIdentifiers = [
            "com.gto.Mind_Munch.life",
            "com.gto.Mind_Munch.life5",
            "com.gto.Mind_Munch.life10"
        ]
        
        var body: some View {
            ZStack {
                OverallBackground()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        if products.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView("Loading products...")
                                Spacer()
                            }
                        } else {
                            ForEach(products, id: \.id) { product in
                                ShopItemView(
                                    title: product.displayName,
                                    price: product.displayPrice,
                                    image: imageFor(product: product)
                                )
                                .onTapGesture {
                                    Task {
                                        await purchase(product: product)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding(.top, 70)
                
                OverallHeader(userStats: userStats, selectedTab: $selectedTab)
            }
            .alert(isPresented: .constant(errorMessage != nil), content: {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "An error occurred."),
                    dismissButton: .default(Text("OK"), action: {
                        errorMessage = nil
                    })
                )
            })
            .onAppear {
                Task {
                    await fetchProducts()
                }
            }
        }
        
        private func fetchProducts() async {
            do {
                products = try await Product.products(for: productIdentifiers)
            } catch {
                errorMessage = "Failed to fetch products: \(error.localizedDescription)"
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
                        case "com.gto.Mind_Munch.life5":
                            userStats.remainingLives += 5
                        case "com.gto.Mind_Munch.life10":
                            userStats.remainingLives += 10
                        default:
                            break
                        }
                        dismiss()
                    } else {
                        errorMessage = "Purchase failed verification."
                    }
                case .pending:
                    errorMessage = "Purchase is pending."
                case .userCancelled:
                    errorMessage = "Purchase was cancelled."
                @unknown default:
                    errorMessage = "An unknown error occurred."
                }
            } catch {
                errorMessage = "Failed to purchase product: \(error.localizedDescription)"
            }
        }
        
        private func imageFor(product: Product) -> String {
            switch product.id {
            case "com.gto.Mind_Munch.life5":
                return "lifePackx5"
            case "com.gto.Mind_Munch.life10":
                return "lifePackx10"
            default:
                return "lifePack"
            }
        }
    }



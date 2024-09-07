//
//  ShopItems.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

// MARK: - Main Shop
struct ShopItemView: View {
    let title: String
    let price: String
    let image: String

    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(4.0)
                .padding(5)
            Text(title)
                .font(.headline)
            Text(price)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
        .shadow(radius: 4)
    }
}

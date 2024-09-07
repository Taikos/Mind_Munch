//
//  HeaderView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

// MARK: - Onboarding
struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.mainBlueWhite)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
}

#Preview {
    HeaderView(title: "aa", subtitle: "dd")
}

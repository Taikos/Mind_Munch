//
//  OverallBackground.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI

struct OverallBackground: View {
    var body: some View {
        LinearGradient(
                        colors: [.mainBlueDark, .mainBlueWhite],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    OverallBackground()
}

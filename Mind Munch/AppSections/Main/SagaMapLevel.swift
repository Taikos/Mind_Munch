//
//  SagaMapLevel.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI

// MARK: - Map modelisation - could be improved

struct LevelButton: View {
    let level: Int
    let isLocked: Bool
    let highestlvl: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(level)")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(
                    Circle()
                        .fill(isLocked ? Color("MainPink-Pastel").opacity(0.5) : (level == highestlvl ? Color.green : Color("mainBlue-White")))
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 6)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)                                .blur(radius: 2)
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 6, x: 4, y: 6)
                .opacity(isLocked ? 0.4 : 1)
        }
        .disabled(isLocked)
    }
}

#Preview {
    LevelButton(level: 2, isLocked: true, highestlvl: 2, action: {print("Demo")})
}

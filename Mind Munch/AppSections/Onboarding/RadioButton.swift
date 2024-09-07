//
//  RadioButton.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

// MARK: - Onboarding
struct RadioButton: View {
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .stroke(isSelected ? Color.white : Color.mainBlueDark, lineWidth: 2)
                    .background(Circle().fill(isSelected ? Color.mainBlueFluo : Color.clear))
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(isSelected ? Color.black : Color.white)
                        .font(.headline)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? Color.mainGreyPastel : Color.mainBlueDark)
                }
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.white : Color.mainGreyLight.opacity(0.3))
            .cornerRadius(10)
        }
    }
}

#Preview {
    RadioButton(title: "aaa", description: "ddddd", isSelected: true, action: {print("hello")})
}

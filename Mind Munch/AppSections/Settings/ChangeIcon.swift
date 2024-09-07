//
//  ChangeIcon.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

struct ChangeIcon: View {
    //Fist one is the main icon
    let iconNames = [nil, "pIcon-0", "pIcon-1", "pIcon-2", "pIcon-3", "pIcon-4", "pIcon-5"]
    
    @State private var showIAPSheet = false

    var body: some View {
        ZStack {
            OverallBackground().edgesIgnoringSafeArea(.all)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(iconNames.indices, id: \.self) { index in
                        let iconName = iconNames[index]
                        if let image = loadImage(for: iconName) {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 1))
                                .onTapGesture {
                                    HapticFeedbackManager.shared.hapticFeedback(.strong)
                                    changeAppIcon(to: iconName)
                                }
                        } else {
                            Image(systemName: "app.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 1))
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func loadImage(for iconName: String?) -> Image? {
        if let iconName = iconName, let uiImage = UIImage(named: iconName) {
            return Image(uiImage: uiImage)
        } else if iconName == nil, let defaultImage = UIImage(named: "AppIcon") {
            return Image(uiImage: defaultImage)
        } else {
            return nil
        }
    }
    
    private func changeAppIcon(to iconName: String?) {
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error setting alternate icon: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ChangeIcon()
}


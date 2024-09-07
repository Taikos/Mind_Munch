//
//  Common.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import AVFoundation
import DeviceKit
import SwiftUI

// MARK: - Global / Font / Sound / ...

extension Font {
    static func LufgaBoldFont(size: CGFloat) -> Font {
      return .custom("LufgaBold", size: size)
    }
    static func LufgaRegularFont(size: CGFloat) -> Font {
      return .custom("LufgaRegular", size: size)
    }
    static func LufgaLightFont(size: CGFloat) -> Font {
      return .custom("LufgaLight", size: size)
    }
    static func LufgaMediumFont(size: CGFloat) -> Font {
      return .custom("LufgaMedium", size: size)
    }
    static func LufgaBoldItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaBoldItalic", size: size)
    }
    static func LufgaExtraBoldFont(size: CGFloat) -> Font {
      return .custom("LufgaExtraBold", size: size)
    }
    static func LufgaBlackFont(size: CGFloat) -> Font {
      return .custom("LufgaBlack", size: size)
    }
    static func LufgaSemiBoldFont(size: CGFloat) -> Font {
      return .custom("LufgaSemiBold", size: size)
    }
    static func LufgaItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaItalic", size: size)
    }
    static func LufgaThinFont(size: CGFloat) -> Font {
      return .custom("LufgaThin", size: size)
    }
    static func LufgaExtraLightFont(size: CGFloat) -> Font {
      return .custom("LufgaExtraLight", size: size)
    }
    static func LufgaBlackItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaBlackItalic", size: size)
    }
    static func LufgaLightItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaLightItalic", size: size)
    }
    static func LufgaExtraBoldItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaExtraBoldItalic", size: size)
    }
    static func LufgaMediumItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaMediumItalic", size: size)
    }
    static func LufgaSemiBoldItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaSemiBoldItalic", size: size)
    }
    static func LufgaThinItalicFont(size: CGFloat) -> Font {
      return .custom("LufgaThinItalic", size: size)
    }
}

let groupOfAllowedDevices: [Device] = [.iPhone11, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone13Mini, .simulator(.iPhone11), .simulator(.iPhone12), .simulator(.iPhone12Mini), .simulator(.iPhone12Pro), .simulator(.iPhone13), .simulator(.iPhone13Pro), .simulator(.iPhone13Mini)]

class ColorUtils {
    // Helper function to calculate the color distance in RGB space
    static func colorDistance(_ color1: Color, _ color2: Color) -> Double {
        let color1RGB = UIColor(color1).cgColor.components ?? [0, 0, 0]
        let color2RGB = UIColor(color2).cgColor.components ?? [0, 0, 0]
        
        let redDiff = color1RGB[0] - color2RGB[0]
        let greenDiff = color1RGB[1] - color2RGB[1]
        let blueDiff = color1RGB[2] - color2RGB[2]
        
        // Calculate Euclidean distance between the two colors
        return sqrt(redDiff * redDiff + greenDiff * greenDiff + blueDiff * blueDiff)
    }

    // Function to generate distinct random colors
    static func generateRandomColors(count: Int, minimumDifference: Double = 0.5) -> [Color] {
        var colors: [Color] = []

        while colors.count < count {
            let newColor = Color(red: Double.random(in: 0...1),
                                 green: Double.random(in: 0...1),
                                 blue: Double.random(in: 0...1))
            
            // Ensure the new color is sufficiently different from all previously generated colors
            if colors.allSatisfy({ colorDistance($0, newColor) >= minimumDifference }) {
                colors.append(newColor)
            }
        }
        return colors
    }
}


class SoundManager {
    static let shared = SoundManager()

    var audioPlayer: AVAudioPlayer?

    func playSound(soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3") else { return }

        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not find and play the sound file.")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}

extension Color {
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.opacity(1 - percentage / 100)
    }
}

//
//  GameElements.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import SwiftUI

// MARK: - Game Elem Manager
class ColoredElement: Identifiable, Equatable {
    var id = UUID()
    var colorRed: Double
    var colorGreen: Double
    var colorBlue: Double
    var colorOpacity: Double
    
    var color: Color {
        Color(red: colorRed, green: colorGreen, blue: colorBlue, opacity: colorOpacity)
    }
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.colorRed = Double(red)
        self.colorGreen = Double(green)
        self.colorBlue = Double(blue)
        self.colorOpacity = Double(alpha)
    }
    
    // Equatable component
    static func == (lhs: ColoredElement, rhs: ColoredElement) -> Bool {
        return lhs.colorRed == rhs.colorRed &&
               lhs.colorGreen == rhs.colorGreen &&
               lhs.colorBlue == rhs.colorBlue &&
               lhs.colorOpacity == rhs.colorOpacity
    }
}

class Jar: Identifiable, Equatable {
    var elements: [ColoredElement]
    let capacity: Int

    init(elements: [ColoredElement] = [], capacity: Int = 4) {
        self.elements = elements
        self.capacity = capacity
    }

    var isFull: Bool { elements.count == capacity }
    var isEmpty: Bool { elements.isEmpty }
    var isComplete: Bool { isFull && elements.allSatisfy { $0.color == elements[0].color } }

    // Equatable component
    static func == (lhs: Jar, rhs: Jar) -> Bool {
        return lhs.id == rhs.id
    }

    var debugDescription: String {
        "Jar(\(elements.map { $0.color.description }.joined(separator: ", ")))"
    }
}


class Level {
    var jars: [Jar]
    var difficulty: Int
    
    init(jars: [Jar], difficulty: Int) {
        self.jars = jars
        self.difficulty = difficulty
        print("Level initialized with \(jars.count) jars and difficulty \(difficulty)")
    }
}


//LEGACY
extension Color {
    var description: String {
        if self == .red { return "Red" }
        if self == .blue { return "Blue" }
        return "Unknown"
    }
}

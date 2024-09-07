//
//  GameLevelFactory.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import SwiftData
import SwiftUI
// MARK: - Level Generator - Based on several params to increase difficulty (details below)

class LevelFactory {
    static func generateLevel(difficulty: Int, userStats: UserStats) -> Level {
        // Adjust the number of colors and jars based on difficulty
                let baseColorCount = min(5, 2 + difficulty / 5)  // More colors as difficulty increases
                let baseEmptyJarCount = max(1, 2 - difficulty / 10)  // Fewer empty jars as difficulty increases
                
                let jarCount = baseColorCount + baseEmptyJarCount  // Total jars = filled + empty
                let colors = ColorUtils.generateRandomColors(count: baseColorCount)
                
                var elements: [ColoredElement] = []
                for color in colors {
                    elements += Array(repeating: ColoredElement(color: color), count: 4)
                }
                elements.shuffle()
                
                var jars: [Jar] = []
                for i in 0..<jarCount {
                    if i < baseColorCount {
                        let startIndex = i * 4
                        let endIndex = startIndex + 4
                        jars.append(Jar(elements: Array(elements[startIndex..<endIndex])))
                    } else {
                        jars.append(Jar())  // Add empty jars
                    }
                }

                // Return a level with the adjusted difficulty
                return Level(jars: jars, difficulty: difficulty)
        
    }
    
    static func generateLevel(userStats: UserStats) -> Level {
         let baseDifficulty = userStats.highestLevelReached
         let difficultyMultiplier = calculateDifficulty(userStats: userStats)
         let finalDifficulty = Int(Double(baseDifficulty) * difficultyMultiplier)
         
         return generateLevel(difficulty: finalDifficulty, userStats: userStats)
     }
     
     // ALGORITHM - Calculate difficulty based on user performance (time, score, lives)
     static func calculateDifficulty(userStats: UserStats) -> Double {
         let timeFactor = 1.0 - min(1.0, userStats.totalTimeSpent / 1000) // slower times reduce difficulty
         let scoreFactor = 1.0 + Double(userStats.score) / 10000 // high scores increase difficulty
         let lifeFactor = userStats.remainingLives > 1 ? 1.1 : 0.9 // more lives make it slightly harder
         
         return timeFactor * scoreFactor * lifeFactor
     }
    
}

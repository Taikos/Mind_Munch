//
//  UserSettings.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import AVKit
import AVFoundation
import SwiftData

// MARK: - User data manager - DB

@Model
class UserStats {
    var name: String
    var pic: String
    var score: Int
    var highestLevelReached: Int
    var totalTimeSpent: Double
    var remainingLives: Int
    var lastConnectionDate: Date
    var lastLifeGainTime: Date
    var extraJars: Int
    var undoMoves: Int
    var onboardingDone: Bool
    
    init(name: String = "Mind Muncher", pic: String = "pp1", score: Int = 0, highestLevelReached: Int = 1, totalTimeSpent: Double = 0, remainingLives: Int = 3, lastConnectionDate: Date = Date(), lastLifeGainTime: Date = Date(), extraJars: Int = 3, undoMoves: Int = 3, onboardingDone: Bool = false) {
        self.name = name
        self.pic = pic
        self.score = score
        self.highestLevelReached = highestLevelReached
        self.totalTimeSpent = totalTimeSpent
        self.remainingLives = remainingLives
        self.lastConnectionDate = lastConnectionDate
        self.lastLifeGainTime = lastLifeGainTime
        self.extraJars = extraJars
        self.undoMoves = undoMoves
        self.onboardingDone = onboardingDone
    }
    
    // Function to lose a life
    func loseLife() {
            remainingLives -= 1
            if remainingLives < 0 { remainingLives = 0 }
        }
        
        func gainLife() {
            remainingLives += 1
            extraJars += 1
            undoMoves += 4
            if remainingLives > 3 { remainingLives = 3 }
            if extraJars > 2 { extraJars = 2 }
            if undoMoves > 4 { undoMoves = 4 }
            lastLifeGainTime = Date()
        }

        func canGainLife() -> Bool {
            let fiveMinutes: TimeInterval = 6 * 10
            return Date().timeIntervalSince(lastLifeGainTime) >= fiveMinutes
        }
        
        func addExtraJar() {
            if extraJars > 0 {
                extraJars -= 1
            } else {
                //New IAP Coming
            }
        }
        
        func undoLastMove() {
            if undoMoves > 0 {
                undoMoves -= 1
            } else {
                //New IAP Coming
            }
        }
}

//PROFILE ELEMENTS
func generatePerformanceStats(from userStats: UserStats) -> (analysis: Double, visualizing: Double, persistence: Double, brainAge: Double) {
    let maxLevel = Double(userStats.highestLevelReached)
    let totalTimeSpent = userStats.totalTimeSpent
    let score = Double(userStats.score)

    let analysis = maxLevel * 1.5 * 3
    let speed = totalTimeSpent > 0 ? maxLevel / totalTimeSpent : 0
    let visualizing = min(speed * 100, 100) * 3
    let persistence = min((totalTimeSpent / 100) * maxLevel, 100) * 3
    let brainAge = min((maxLevel + score / 1000) * 1.2, 100) * 3

    return (analysis: analysis, visualizing: visualizing, persistence: persistence, brainAge: brainAge)
}



//SETTINGS ELEMENTS
//func updateLastOpened() {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .medium
//    dateFormatter.timeStyle = .medium
//    
//    let now = Date()
//    UserDefaults.standard.set(now, forKey: "lastOpened")
//    
//    let lastOpenedString = dateFormatter.string(from: now)
//    UserDefaults.standard.set(lastOpenedString, forKey: "lastOpenedString")
//}
//
//func getLastOpened() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .medium
//    dateFormatter.timeStyle = .medium
//    
//    if let lastOpened = UserDefaults.standard.object(forKey: "lastOpened") as? Date {
//        return dateFormatter.string(from: lastOpened)
//    } else {
//        return "Never"
//    }
//}
//
//func generateAndStoreUserID() {
//    // Check if we already have a saved user ID
//    if UserDefaults.standard.string(forKey: "userID") == nil {
//        // Generate a new UUID String
//        let newUserID = UUID().uuidString
//        // Store the new user ID in UserDefaults
//        UserDefaults.standard.set(newUserID, forKey: "userID")
//    }
//}
//
//func getUserID() -> String {
//    return UserDefaults.standard.string(forKey: "userID") ?? "Secret User"
//}

//
//  LeaderboardView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

// MARK: - Sample Leaderboard Generator
func generateLeaderboard(for user: UserStats) -> [(Int, String, String, Int, Bool)] {
    var leaderboard: [(Int, String, String, Int, Bool)] = []
    let fakeScores = Array(500..<340000).shuffled()
    
    let profilePictures = ["pp1", "pp2", "pp3", "pp4", "pp5", "pp6"]
    
    let gamingPseudonyms = [
        "ShadowHunter", "LoneWolf", "BlazeMaster", "SilentAssassin", "PhantomRider",
        "IronFist", "StormBreaker", "DarkKnight", "FrostWarden", "VenomStrike",
        "ThunderClap", "WindWalker", "StarSlinger", "RageFury", "NightRaven"
    ]
    
    // Generate random leaderboard entries
    for score in fakeScores {
        let pseudo = gamingPseudonyms.randomElement() ?? "Player"
        let profilePicture = profilePictures.randomElement() ?? "pp1"
        leaderboard.append((0, pseudo, profilePicture, score, false))
    }
    
    // Insert the user's score into the leaderboard
    leaderboard.append((0, user.name, user.pic, user.score, true))
    
    // Sort the leaderboard by score in descending order
    leaderboard.sort { $0.3 > $1.3 }
    
    // Assign positions and find user's position
    var userPosition = 0
    for i in 0..<leaderboard.count {
        leaderboard[i].0 = i + 1
        if leaderboard[i].4 { // Check if this is the user's entry
            userPosition = i
        }
    }
    
    // Calculate the range to display (3 above and 3 below the user)
    let start = max(0, userPosition - 3)
    let end = min(leaderboard.count - 1, start + 6)  // Ensure we always show 7 entries if possible
    
    // If we're near the end of the leaderboard, adjust the start to show 7 entries
    let adjustedStart = max(0, end - 6)
    
    // Return the slice of the leaderboard
    return Array(leaderboard[adjustedStart...end])
}

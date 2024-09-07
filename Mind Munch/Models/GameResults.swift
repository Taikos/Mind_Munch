//
//  GameResults.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import SwiftData

@Model
class GameRecord {
    var score: Int
    var moves: Int
    var timeElapsed: Double
    var date: Date
    
    init(score: Int, moves: Int, timeElapsed: Double) {
        self.score = score
        self.moves = moves
        self.timeElapsed = timeElapsed
        self.date = Date()
    }
}

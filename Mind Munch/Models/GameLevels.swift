//
//  GameLevels.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import Foundation
import SwiftData

// MARK: - Game Manager
class GameState: ObservableObject {
    @Published var level: Level?
    @Published var score: Int
    @Published var moves: Int
    @Published var timeElapsed: Double
    @Published var gameOver: Bool
    @Published var hasWon: Bool
    @Published var userStats: UserStats

    private var startTime: Date?  // Track the start time

    private var moveHistory: [(Jar, Jar, ColoredElement)] = []
    
    init(level: Level?, userStats: UserStats) {
        self.level = level
        self.score = 0
        self.moves = 0
        self.timeElapsed = 0
        self.gameOver = false
        self.hasWon = false
        self.userStats = userStats
        self.startTime = Date()  // Start timer when the level begins
    }

    func moveElement(from sourceJar: Jar, to destinationJar: Jar) -> Bool {
        guard !sourceJar.isEmpty,
              !destinationJar.isFull,
              let elementToMove = sourceJar.elements.last,
              destinationJar.isEmpty || destinationJar.elements.last?.color == elementToMove.color else {
            print("Move not allowed")
            return false
        }

        // Find all consecutive same-colored balls at the top of the source jar
        var elementsToMove: [ColoredElement] = [elementToMove]
        for i in (0..<(sourceJar.elements.count - 1)).reversed() {
            let nextElement = sourceJar.elements[i]
            if nextElement.color == elementToMove.color {
                elementsToMove.append(nextElement)
            } else {
                break
            }
        }

        // Ensure the destination jar has enough space for all the elements
        if destinationJar.capacity - destinationJar.elements.count < elementsToMove.count {
            print("Not enough space in destination jar")
            return false
        }

        // Remove all consecutive elements from the source jar
        // Corrected this part to remove only the necessary elements
        for _ in 0..<elementsToMove.count {
            sourceJar.elements.removeLast()
        }

        // Move the elements to the destination jar
        destinationJar.elements.append(contentsOf: elementsToMove)

        // Track the move history for undo
        moveHistory.append((sourceJar, destinationJar, elementToMove))

        moves += 1
        print("Move completed. New state: \(self.debugDescription)")
        checkGameState()
        return true
    }
    
    func checkGameState() {
        if level?.jars.allSatisfy({ $0.isEmpty || $0.isComplete }) == true {
            completeLevel()  // Call this when the level is completed
        } else if !hasValidMoves() {
            gameOver = true
            hasWon = false
            userStats.loseLife()  // Reduce lives if the game is over
            if userStats.remainingLives <= 0 {
                gameOver = true  // Trigger game over if no lives remain
            }
        }
        }
    func addExtraJar() {
        userStats.addExtraJar()
        level?.jars.append(Jar())
    }

    func undoLastMove() {
        guard let lastMove = moveHistory.popLast() else { return }  // Retrieve the last move
        let (sourceJar, destinationJar, movedElement) = lastMove

        // Find how many elements were moved together by comparing the destination jar and source jar
        var elementsToUndo = [movedElement]
        
        // Check for consecutive elements of the same color at the end of the destination jar
        for element in destinationJar.elements.reversed() {
            if element.color == movedElement.color && elementsToUndo.count < sourceJar.capacity {
                elementsToUndo.append(element)
            } else {
                break
            }
        }

        // Ensure we are undoing the correct number of elements
        for _ in 0..<elementsToUndo.count {
            if let lastElement = destinationJar.elements.popLast(), lastElement.color == movedElement.color {
                sourceJar.elements.append(lastElement)
            }
        }

        moves -= 1
        userStats.undoLastMove()
    }

    func restartLevel() {
        userStats.loseLife()
        
        if userStats.remainingLives <= 0 {
            // Game over if no lives remain
            gameOver = true
            hasWon = false
        } else {
            // Reset the level with the current difficulty
            level = LevelFactory.generateLevel(difficulty: level?.difficulty ?? 1, userStats: userStats)
            gameOver = false
        }
    }
    
    // Function to calculate score and time once the level is completed
    func completeLevel() {
        if let startTime = startTime {
            timeElapsed = Date().timeIntervalSince(startTime)  // Calculate time taken
        }
        score = calculateScore()  // Calculate score based on some formula
        hasWon = true
        gameOver = false
        userStats.score += score  // Update user stats
    }

    private func calculateScore() -> Int {
        // Example: Base score minus penalties for extra moves, plus time bonus
        let baseScore = 1000
        let movePenalty = moves * 10
        let timeBonus = max(0, 1000 - Int(timeElapsed))
        return baseScore - movePenalty + timeBonus
    }


        
        func hasValidMoves() -> Bool {
            guard let jars = level?.jars else { return false }
            
            for sourceJar in jars where !sourceJar.isEmpty {
                for destinationJar in jars where sourceJar !== destinationJar {
                    if destinationJar.isEmpty || (destinationJar.elements.last?.color == sourceJar.elements.last?.color && !destinationJar.isFull) {
                        return true
                    }
                }
            }
            return false
        }
    
    //DEBUG
    var debugDescription: String {
        let jarsDescription = level?.jars.map { "Jar: \($0.elements.map { $0.color.description }.joined(separator: ", "))" }.joined(separator: " | ") ?? "No jars"
        return "Moves: \(moves), Jars: [\(jarsDescription)]"
    }
}

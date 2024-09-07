//
//  ResultScreen.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI
   

// Result Screen for showing game results and confetti or rain effect based on win/loss
struct ResultScreen: View {
    @Environment(\.modelContext) private var modelContext
    let gameState: GameState
    @Binding var gameStarted: Bool
    var onPlayAgain: () -> Void
    @State private var showQuickShop = false
    @State private var showEffect = false
    
    var body: some View {
        ZStack {
OverallBackground().edgesIgnoringSafeArea(.all)
            
            if showEffect {
                if gameState.hasWon {
                    ConfettiView()
                } else {
                    RainView()
                }
            }
            
            VStack(spacing: 30) {
                Text(gameState.hasWon ? "🎉 You Won!" : "☠️ Game Over")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.mainBlueFluo.opacity(0.9))
                    )
                    .shadow(radius: 10)
                
                // Stat Views
                VStack(spacing: 16) {
                    StatView(title: "🏆 Score", value: "\(gameState.score)")
                    StatView(title: "🌀 Moves", value: "\(gameState.moves)")
                    StatView(title: "⏱ Time", value: String(format: "%.2f sec", gameState.timeElapsed))
                    StatView(title: "❤️ Lives", value: "\(gameState.userStats.remainingLives)")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.mainGreyLight.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.mainBlueDark, lineWidth: 1.5)
                        )
                )
                .shadow(radius: 10)
                if gameState.hasWon {
                    ActionButton(title: "Next Level", action: {
                        unlockNextLevel()
                        HapticFeedbackManager.shared.hapticFeedback(.medium)
                        gameStarted = false
                    })
                } else {
                    if gameState.userStats.remainingLives > 0 {
                        ActionButton(title: "Retry", action: onPlayAgain
                        )
                    } else {
                        ActionButton(title: "Buy More Lives", action: { showQuickShop = true
                            HapticFeedbackManager.shared.hapticFeedback(.medium)

                        })
                    }
                    ActionButton(title: "Main Menu", action: { gameStarted = false
                        HapticFeedbackManager.shared.hapticFeedback(.medium)

                    })
                }
            }
            .padding()
        }
        .onAppear {
            showEffect = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showEffect = false
            }
        }
        .sheet(isPresented: $showQuickShop) {
            QuickShopView(userStats: gameState.userStats)
                .presentationDetents([.height(500), .medium, .large])
                .presentationDragIndicator(.automatic)
        }
    }
    
    private func unlockNextLevel() {
        gameState.userStats.highestLevelReached += 1
        try? modelContext.save()
    }
}

// Custom Confetti View
struct ConfettiView: View {
    @State private var confetti = [Confetti]()
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()  // Faster timer
    
    var body: some View {
        ZStack {
            ForEach(confetti) { confettiPiece in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(confettiPiece.color)
                    .position(x: confettiPiece.x, y: confettiPiece.y)
                    .rotationEffect(.degrees(confettiPiece.rotation))
                    .opacity(confettiPiece.opacity)
            }
        }
        .onAppear {
            for _ in 0..<100 {  // More confetti for denser effect
                confetti.append(Confetti())
            }
        }
        .onReceive(timer) { _ in
            for i in 0..<confetti.count {
                confetti[i].y += confetti[i].speed
                confetti[i].rotation += Double.random(in: -10...10)
                
                if confetti[i].y > UIScreen.main.bounds.height {
                    confetti[i].y = -50
                    confetti[i].x = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
                }
                
                if confetti[i].opacity > 0 {
                    confetti[i].opacity -= 0.02
                }
            }
        }
    }
}

// Confetti data model
struct Confetti: Identifiable {
    let id = UUID()
    var x = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
    var y = CGFloat.random(in: -50..<UIScreen.main.bounds.height)
    let color = Color.randomConfettiColor()
    var rotation = Double.random(in: 0...360)
    var speed = Double.random(in: 5...15)
    var opacity = Double.random(in: 0.6...1.0)
}

// Custom Raindrop View
struct RainView: View {
    @State private var raindrops = [Raindrop]()
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()  // Faster timer for smooth animation
    
    var body: some View {
        ZStack {
            ForEach(raindrops) { raindrop in
                Circle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 4, height: 8)  // Raindrop size
                    .position(x: raindrop.x, y: raindrop.y)
            }
        }
        .onAppear {
            for _ in 0..<150 {  // Increase the number of raindrops for denser effect
                raindrops.append(Raindrop())
            }
        }
        .onReceive(timer) { _ in
            for i in 0..<raindrops.count {
                raindrops[i].y += raindrops[i].speed
                
                // Reset raindrop to the top when it reaches the bottom
                if raindrops[i].y > UIScreen.main.bounds.height {
                    raindrops[i].y = -50  // Reset above the visible screen
                    raindrops[i].x = CGFloat.random(in: 0..<UIScreen.main.bounds.width)  // Random x position
                }
            }
        }
    }
}

// Raindrop data model
struct Raindrop: Identifiable {
    let id = UUID()
    var x = CGFloat.random(in: 0..<UIScreen.main.bounds.width)  // Random starting x position
    var y = CGFloat.random(in: -100..<UIScreen.main.bounds.height)  // Start from a random y position above the screen
    var speed = Double.random(in: 5...15)  // Random speed for each raindrop
}

// Color extension to generate random confetti colors
extension Color {
    static func randomConfettiColor() -> Color {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        return colors.randomElement() ?? .white
    }
}

// Supporting StatView and ActionButton
struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.title3)
                .foregroundColor(.white)
        }
    }
}

struct ActionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(Color.white.opacity(0.2)))
        }
    }
}

struct ResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        let mockUserStats = UserStats()
        let mockGameState = GameState(level: LevelFactory.generateLevel(difficulty: 1, userStats: mockUserStats), userStats: mockUserStats)
        mockGameState.score = 1000
        mockGameState.moves = 50
        mockGameState.timeElapsed = 120.5
        
        return ResultScreen(gameState: mockGameState, gameStarted: .constant(false), onPlayAgain: {})
            .modelContainer(for: [UserStats.self, GameRecord.self], inMemory: true)
    }
}

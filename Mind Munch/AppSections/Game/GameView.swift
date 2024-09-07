//
//  GameView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI
import GoogleMobileAds


// MARK: - Game - All component included for optimization
// Except Particles Part

struct GameControlButton: View {
    let action: () -> Void
    let imageName: String
    let label: String
    let disabled: Bool
    let unitCount: Int

    var body: some View {
        VStack(spacing: 4) {
            Button(action: action) {
                VStack(spacing: 8) {
                    Image(systemName: imageName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(disabled ? .gray : .white)

                    Text(label)
                        .font(.system(size: 8, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(disabled ? .gray : .white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(width: 100, height: 80)
                .background(
                    ZStack {
                        Circle()
                            .fill(disabled ? Color.gray.opacity(0.3) : Color.mainBlueFluo.opacity(0.8))
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .clear]),
                                                 startPoint: .topLeading,
                                                 endPoint: .bottomTrailing))
                            .blendMode(.overlay)
                    }
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .scaleEffect(disabled ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: disabled)
            .disabled(disabled)

            // Unit count below the button
            Text("\(unitCount)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(disabled ? .gray : .white)
        }
    }
}
struct JarView: View {
    let jar: Jar
    let isSelected: Bool
    let action: () -> Void
    
    @State private var bumpEffect: CGFloat = 1.0
    @State private var isAnimating = false
    @State private var showParticles = false
    @State private var showCompletionAnimation = false  // For completion animation
    @State private var completionScale: CGFloat = 1.0
    @State private var jarColor: Color = .white.opacity(0.5)
    
    var body: some View {
        ZStack {
            // Improved Jar Shape
            JarShape()
                .fill(Color.white.opacity(0.2))
                .overlay(
                    JarShape()
                        .stroke(isSelected ? Color.yellow : Color.white.opacity(0.4), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .frame(width: 40, height: 140)
            
            // Fluid content with correct positioning
            ZStack(alignment: .bottom) {
                ForEach(Array(jar.elements.enumerated().reversed()), id: \.offset) { index, element in
                    FluidBall(color: element.color)
                        .frame(width: 30, height: 30)  // Fixed size for balls
                        .offset(y: -CGFloat(index) * 30)  // Control the vertical spacing
                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                removal: .scale.combined(with: .opacity)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)  // Ensure content doesn't affect jar size
            .mask(JarShape())
            .scaleEffect(showCompletionAnimation ? 1.1 : 1.0)  // Completion animation: scale up when the jar is complete
            .animation(.spring(), value: showCompletionAnimation)  // Spring animation for smooth scaling
            
            // Subtle Glare effect
            JarShape()
                .fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .mask(
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white, .white]),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                )
                .frame(width: 15)
                .offset(x: -15, y: 0)
                .blendMode(.screen)
            
            // Jar count
            Text("\(jar.elements.count)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(4)
                .background(Circle().fill(Color.black.opacity(0.6)))
                .offset(x: 20, y: -65)

            // Particle effect when the jar is complete
            if showParticles {
                ParticleSystem(duration: 1, particles: 20)
                    .frame(width: 40, height: 140)
            }
        }
        .padding(.top)
        .frame(width: 70, height: 130)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .scaleEffect(bumpEffect)
                .scaleEffect(completionScale)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: bumpEffect)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: completionScale)
                .onChange(of: jar.elements.count) { oldCount, newCount in
                    if newCount > oldCount {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            bumpEffect = 1.05
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                bumpEffect = 1.0
                            }
                        }
                    }
                    
                    if jar.isComplete {
                        completionAnimation()
                    }
                }
                .onTapGesture(perform: action)
            }
            
            private func completionAnimation() {
                showParticles = true
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    jarColor = Color.yellow.opacity(0.7)
                    completionScale = 1.1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        jarColor = .white.opacity(0.8)
                        completionScale = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showParticles = false
                    }
                }
            }
        }


struct JarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let cornerRadius: CGFloat = width / 8
        
        // Top curve
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(0),
                    clockwise: false)
        
        // Right side
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        
        // Bottom curve
        path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)
        
        // Left side
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        // Top left corner
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        
        return path
    }
}

struct FluidBall: View {
    let color: Color
    
    var body: some View {
        Image("ball_1")
            .resizable()
            .scaledToFill()
            .foregroundColor(color)
            .overlay(
                Circle()
                    .fill(RadialGradient(gradient: Gradient(colors: [.white.opacity(0.7), .clear]),
                                         center: .topLeading,
                                         startRadius: 1,
                                         endRadius: 15))
                    .blendMode(.screen)
            )
            .overlay(
                Circle()
                    .stroke(color.darker(), lineWidth: 0.5)
            )
            .shadow(color: color.opacity(0.3), radius: 1, x: 0, y: 1)
    }
}



struct GameView: View {
    @ObservedObject var gameState: GameState
    @Binding var showResultScreen: Bool
    
    @State private var selectedJar: Jar?
    private let adsViewModel = InterstitialViewModel()
    @State private var shakeAmount: CGFloat = 0

    var body: some View {
        VStack {
            // Top Section: Score and Lives
            HStack {
                            VStack {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(gameState.score)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                Text("Moves: \(gameState.moves)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack {
                                HStack {
                                    Image(systemName: "heart.fill") // Lives icon
                                        .foregroundColor(.red)
                                    Text("\(gameState.userStats.remainingLives)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                            }
                            Spacer()
                            Button(action: {
                                HapticFeedbackManager.shared.hapticFeedback(.strong)
                                gameState.userStats.remainingLives -= 1
                                gameState.gameOver = true
                                showResultScreen = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
            
            // Middle Section: Grid of Jars
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 20) {
                    ForEach(gameState.level?.jars ?? []) { jar in
                        JarView(jar: jar, isSelected: selectedJar?.id == jar.id) {
                            jarTapped(jar)
                        }
                        .shadow(radius: 8)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)


            }
            
            HStack(spacing: 20) {
                 GameControlButton(action: {
                     HapticFeedbackManager.shared.hapticFeedback(.medium)

                     gameState.restartLevel()
                 }, imageName: "arrow.clockwise", label: "Restart", disabled: gameState.userStats.remainingLives < 0, unitCount: gameState.userStats.remainingLives)
                 
                 GameControlButton(action: {
                     HapticFeedbackManager.shared.hapticFeedback(.medium)

                     gameState.undoLastMove()
                 }, imageName: "arrow.uturn.backward", label: "Undo", disabled: gameState.userStats.undoMoves <= 0, unitCount: gameState.userStats.undoMoves)
                 
                 GameControlButton(action: {
                     HapticFeedbackManager.shared.hapticFeedback(.medium)

                     gameState.addExtraJar()
                 }, imageName: "plus.square", label: "Jar", disabled: gameState.userStats.extraJars <= 0, unitCount: gameState.userStats.extraJars)
             }
             .padding(.horizontal)
             .padding(.bottom, 30)
        }
        .padding(.bottom)
        .background(OverallBackground())
        .onAppear {
            Task {
                await adsViewModel.loadAd()
            }
        }
        .onChange(of: gameState.moves) { _, _ in
            checkGameStatus()
        }
        .onChange(of: gameState.gameOver) {
            if gameState.gameOver {
                adsViewModel.showAd()
                showResultScreen = true
            }
        }
    }

    private func jarTapped(_ jar: Jar) {
        withAnimation(.spring()) {
            if selectedJar == jar {
                // Deselect the jar if it's already selected
                selectedJar = nil
            } else if let selectedJar = selectedJar {
                // Move the element between jars if possible
                if gameState.moveElement(from: selectedJar, to: jar) {
                    self.selectedJar = nil  // Reset selection after a successful move
                }
                else {
                    withAnimation(.default) {
                        shakeAmount = 5
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.default) {
                            shakeAmount = 0
                        }
                    }
                }
            } else {
                selectedJar = jar  // Select the tapped jar
            }
        }
    }

    private func checkGameStatus() {
        gameState.checkGameState()
        if gameState.gameOver || gameState.hasWon {
            showResultScreen = true  // Trigger result screen if the game is over
        }
    }
}
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let mockLevel = LevelFactory.generateLevel(difficulty: 1, userStats: UserStats())
        let mockGameState = GameState(level: mockLevel, userStats: UserStats())
        return GameView(gameState: mockGameState, showResultScreen: .constant(true))
            .modelContainer(for: [UserStats.self], inMemory: true)
    }
}

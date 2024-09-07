//
//  CandySortGame.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI
import SwiftData

// MARK: - MAIN
struct CandySortGame: View {
    @Environment(\.modelContext) private var modelContext
    @State private var gameState: GameState?
    @State private var userStats: UserStats?
    let timer = Timer.publish(every: 40, on: .main, in: .common).autoconnect()

    @State private var gameStarted: Bool = false
    @State private var showResultScreen: Bool = false
    @State private var selectedLevel: Int = 1
    @State private var selectedTab: Int = 0
    @State private var showPreGameView: Bool = false
    @State private var showQuickShop: Bool = false
    
    var body: some View {
        ZStack {
            OverallBackground()
            
            if !(userStats?.onboardingDone ?? false) {
                OnboardingView(userStats: userStats ?? UserStats())
            } else {
                if !gameStarted && !showPreGameView {
                    // Saga Map or Level Selection screen
                    TabView(selection: $selectedTab) {
                        sagaMapView()
                            .tabItem {
                                Image(systemName: "map.fill")
                                Text("Saga Map")
                            }
                            .tag(0)
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(Color.black.opacity(0.8), for: .tabBar)
                        
                        ProfileView(userStats: userStats ?? UserStats(), selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                            .tag(1)
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(Color.black.opacity(0.8), for: .tabBar)
                        
                        ShopView(userStats: userStats ?? UserStats(), selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "cart.fill")
                                Text("Shop")
                            }
                            .tag(2)
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(Color.black.opacity(0.8), for: .tabBar)
                    }
                    
                } else if showPreGameView {
                    PreGameView(showPreGameView: $showPreGameView, userStats: userStats ?? UserStats())
                } else if let gameState = gameState, !showResultScreen {
                    GameView(gameState: gameState, showResultScreen: $showResultScreen)
                } else if showResultScreen {
                    if let gameState = gameState {
                        ResultScreen(gameState: gameState, gameStarted: $gameStarted, onPlayAgain: startNewGameBasedOnResult)
                    }
                }
            }
        }
        .onAppear {
            fetchOrCreateUserStats()
        }
    }
    private func fetchOrCreateUserStats() {
        let descriptor = FetchDescriptor<UserStats>()

        do {
            let results = try modelContext.fetch(descriptor)
            if let existingUserStats = results.first {
                self.userStats = existingUserStats
            } else {
                let newUserStats = UserStats()
                modelContext.insert(newUserStats)
                self.userStats = newUserStats
                try? modelContext.save()
            }
        } catch {
            print("Error fetching UserStats: \(error.localizedDescription)")
        }
    }

    private func startNewGame(userStats: UserStats, level: Int) {
        print("Starting new game at level \(level) with UserStats")
        
        let initialLevel = LevelFactory.generateLevel(difficulty: level, userStats: userStats)
        let newGameState = GameState(level: initialLevel, userStats: userStats)
        
        // Reset the game state for the new level
        newGameState.score = 0
        newGameState.moves = 0
        newGameState.timeElapsed = 0
        newGameState.gameOver = false
        newGameState.hasWon = false
        showResultScreen = false
        
        showPreGameView = true
        self.gameState = newGameState
    }

    // Restart or retry based on win/loss
    private func startNewGameBasedOnResult() {
        guard let userStats = userStats else { return }

        if let gameState = gameState, gameState.hasWon {
            userStats.highestLevelReached += 1
            startNewGame(userStats: userStats, level: userStats.highestLevelReached)
        } else {
            startNewGame(userStats: userStats, level: selectedLevel)
        }

        do {
            try modelContext.save()
        } catch {
            print("Error saving userStats: \(error)")
        }

        showResultScreen = false
        gameState?.gameOver = false
    }
    
    
    
    private func sagaMapView() -> some View {
        ZStack {
            OverallBackground()
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        VStack(spacing: 50) {
                            ForEach((1...300).reversed(), id: \.self) { level in
                                LevelButton(level: level, isLocked: level > (userStats?.highestLevelReached ?? 1), highestlvl: userStats?.highestLevelReached ?? 1) {
                                    if level == (userStats?.highestLevelReached ?? 1) && userStats?.remainingLives ?? 0 > 0  {
                                        selectedLevel = level
                                        gameStarted = true
                                        startNewGame(userStats: userStats!, level: level)
                                    }
                                    else {
                                        showQuickShop = true
                                    }
                                }
                                .frame(width: 70, height: 70)
                                .offset(x: CGFloat.random(in: -50...50))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 200)
                        .padding(.bottom, 50)
                        .onAppear {
                            proxy.scrollTo(1, anchor: .bottom)
                        }
                    }
                }
            
            OverallHeader(userStats: userStats ?? UserStats(), selectedTab: $selectedTab)
        }
        .sheet(isPresented: $showQuickShop) {
            QuickShopView(userStats: gameState?.userStats ?? UserStats())
                .presentationDetents([.height(500), .medium, .large])
                .presentationDragIndicator(.automatic)
        }
        .onReceive(timer) { _ in
              Task {
                  await checkForLifeRegeneration()
              }
          }
      }
      
      private func checkForLifeRegeneration() async {
          guard let userStats = userStats else { return }
          
          if (userStats.canGainLife() && userStats.remainingLives < 3) || (userStats.canGainLife() && userStats.undoMoves < 4) || (userStats.canGainLife() && userStats.extraJars < 2) {
              await MainActor.run {
                  userStats.gainLife()
                  try? modelContext.save()
              }
          }
      }
  }

struct CandySortGame_Previews: PreviewProvider {
    static var previews: some View {
        CandySortGame()
            .modelContainer(for: [UserStats.self, GameRecord.self], inMemory: true)
    }
}

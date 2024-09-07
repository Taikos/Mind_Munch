//
//  ProfileView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

import SwiftData

// MARK: - Profile including Radar and Leaderboard

struct ProfileView: View {
    @Bindable var userStats: UserStats
    @Binding var selectedTab: Int
    
    var body: some View {
        let stats = generatePerformanceStats(from: userStats)
        
        ZStack {
            OverallBackground()
            
            ScrollView {
                VStack(spacing: 40) {
                    // Section: Overall
                    VStack(spacing: 20) {
                        profileHeader
                        levelProgressView
                        totalTimeSpentView
                    }
                    
                    // Section: Performance
                    VStack(spacing: 20) {
                        RadarChartView(analysis: stats.analysis, visualizing: stats.visualizing, persistence: stats.persistence, brainAge: stats.brainAge)
                            .frame(width: 420, height: 400)
                    }
                    
                    // Section: Leaderboard
                    leaderboardView
                    
                }
                .padding()
            }
            .padding(.top, 70)
            
            OverallHeader(userStats: userStats, selectedTab: $selectedTab)
        }
    }
    
    // MARK: - Profile Header
    var profileHeader: some View {
        VStack(spacing: 10) {
            Image("\(userStats.pic)")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .overlay(
                    Circle().stroke(Color.mainGreyPastel, lineWidth: 4)
                )
            
            Text(userStats.name)
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    // MARK: - Level Progress View
    var levelProgressView: some View {
        VStack(spacing: 5) {
            HStack {
                Text("LEVEL \(userStats.highestLevelReached)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Spacer()
                Text("LEVEL 300")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: levelProgress())                .progressViewStyle(LinearProgressViewStyle(tint: Color.purple))
                .frame(height: 8)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Total Time Spent View
    var totalTimeSpentView: some View {
        VStack(spacing: 10) {
            Text("Total Time Spent")
                .font(.headline)
            
            let totalTimeSpentInDays = userStats.totalTimeSpent / 24
            
            ProgressView(value: totalTimeSpentInDays / 30) // Assuming 30 days max for loading bar
                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                .frame(height: 8)
            
            Text("\(String(format: "%.2f", totalTimeSpentInDays)) days spent")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Leaderboard View
    var leaderboardView: some View {
        VStack(spacing: 10) {
            Text("Leaderboard")
                .font(.title2)
                .fontWeight(.heavy)
            
            VStack(spacing: 5) {
                ForEach(generateLeaderboard(for: userStats), id: \.0) { (position, name, profilePicture, score, isUser) in
                    HStack(spacing: 15) {
                        // Profile Image
                        Image(profilePicture)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(isUser ? Color.blue : Color.gray, lineWidth: 2)
                            )
                        
                        // Ranking and Name
                        VStack(alignment: .leading, spacing: 4) {
                            Text(name)
                                .font(.headline)
                                .foregroundColor(isUser ? Color.blue : Color.primary)
                            Text("#\(position)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // Score
                        Text("\(score) pts")
                            .font(.headline)
                            .foregroundColor(isUser ? Color.blue : Color.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(isUser ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(5)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        isUser ? Color.mainBlueBold.opacity(0.4) : Color.clear
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Calculate Level Progress
    private func levelProgress() -> Double {
        return Double(userStats.highestLevelReached) / 300.0
    }
}
#Preview {
    ProfileView(userStats: UserStats(), selectedTab: .constant(1))
}

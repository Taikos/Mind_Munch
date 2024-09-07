//
//  Effects.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 06/09/2024.
//

import SwiftUI
import Foundation
import AVKit

// MARK: - Custom Video
struct CustomVideoPlayerView: View {
    private let player: AVPlayer = {
        let url = Bundle.main.url(forResource: "demo", withExtension: "mov")!  // Replace with your video URL
        let player = AVPlayer(url: url)
        player.isMuted = true  // Mute the player
        return player
    }()

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()  // Autoplay video when the view appears
            }
            .onDisappear {
                player.pause()  // Pause video when the view disappears
            }
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.2)  // Control the size
            .cornerRadius(15)  // Add corner radius
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)  // Optional border for emphasis
            )
            .disabled(true)  // Disable interaction (no play/pause)
            .allowsHitTesting(false)  // Ensure no user interaction
    }
}

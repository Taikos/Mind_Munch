//
//  Particles.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import Foundation
import SwiftUI


// MARK: - We move stuff

struct Particle: Hashable {
    let x: Double
    let y: Double
    let scale: Double
    let speed: Double
    let angle: Double
}

struct ParticleSystem: View {
    let duration: Double
    let particles: Int
    
    @State private var time: Double = 0
    @State private var particleData: [Particle] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, color: .white))
                context.addFilter(.blur(radius: 3))
                
                for particle in particleData {
                    if let symbol = context.resolveSymbol(id: 0) {
                        context.opacity = 1 - time / duration
                        context.scaleBy(x: particle.scale, y: particle.scale)
                        context.rotate(by: .radians(particle.angle * .pi / 180))
                        
                        let offset = (time * particle.speed)
                        let x = particle.x + offset * cos(particle.angle * .pi / 180)
                        let y = particle.y + offset * sin(particle.angle * .pi / 180)
                        context.draw(symbol, at: CGPoint(x: x, y: y))
                        
                        context.transform = .identity
                    }
                }
            } symbols: {
                Circle()
                    .fill(.white)
                    .frame(width: 8, height: 8)
                    .tag(0)
            }
        }
        .onAppear {
            particleData = (0..<particles).map { _ in
                Particle(
                    x: Double.random(in: 0...UIScreen.main.bounds.width),
                    y: Double.random(in: 0...UIScreen.main.bounds.height),
                    scale: Double.random(in: 0.1...1),
                    speed: Double.random(in: 20...200),
                    angle: Double.random(in: 0...360)
                )
            }
            
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                time = duration
            }
        }
    }
}

struct ParticleModifier: ViewModifier {
    let duration: Double
    let particles: Int
    
    func body(content: Content) -> some View {
        content.overlay(
            ParticleSystem(duration: duration, particles: particles)
                .allowsHitTesting(false)
        )
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {
    func shake(with amount: CGFloat) -> some View {
        modifier(ShakeEffect(amount: amount, animatableData: amount))
    }
    
    func particleEffect(duration: Double, particles: Int) -> some View {
        modifier(ParticleModifier(duration: duration, particles: particles))
    }
}

struct WaveView: Shape {
    var waveOffset: CGFloat

    var animatableData: CGFloat {
        get { waveOffset }
        set { waveOffset = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2

        path.move(to: CGPoint(x: 0, y: midHeight))

        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / 50
            let y = sin(relativeX + waveOffset) * 20 + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

struct ParticleEffect: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<20, id: \.self) { _ in
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
                    .animation(
                        Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5)
                            .repeatForever()
                            .speed(.random(in: 0.1...0.5))
                            .delay(.random(in: 0...1)),
                        value: UUID()
                    )
            }
        }
    }
}

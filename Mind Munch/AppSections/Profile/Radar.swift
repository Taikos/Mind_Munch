//
//  Radar.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

// MARK: - Radar schema for profile

struct RadarChartView: View {
    var analysis: Double
    var visualizing: Double
    var persistence: Double
    var brainAge: Double
    
    private var hasEnoughData: Bool {
        return analysis > 0 || visualizing > 0 || persistence > 0 || brainAge > 0
    }
    
    private var maxValue: Double {
        return max(100, [analysis, visualizing, persistence, brainAge].max() ?? 0)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Performance Analysis")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            if !hasEnoughData {
                VStack(spacing: 20) {
                    Text("Play a bit more to get your graph calculated")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Image("ball_2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
            } else {
                ZStack {
                    // Background grid
                    RadarChart(values: [maxValue, maxValue, maxValue, maxValue],
                               labels: ["Analysis", "Visualizing", "Persistence", "Brain Age"],
                               maxValue: maxValue)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    
                    // Data chart
                    RadarChart(values: [analysis, visualizing, persistence, brainAge],
                               labels: ["Analysis", "Visualizing", "Persistence", "Brain Age"],
                               maxValue: maxValue)
                        .fill(Color.pink.opacity(0.2))
                    
                    RadarChart(values: [analysis, visualizing, persistence, brainAge],
                               labels: ["Analysis", "Visualizing", "Persistence", "Brain Age"],
                               maxValue: maxValue)
                        .stroke(Color.pink, lineWidth: 2)
                    
                    // Central point
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 8, height: 8)
                    
                    // Labels
                    RadarChartLabels(labels: ["Analysis", "Visualizing", "Persistence", "Brain Age"])
                }
                .frame(width: 200, height: 200)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding()
    }
}

struct RadarChart: Shape {
    var values: [Double]
    var labels: [String]
    var maxValue: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = .pi * 2 / Double(values.count)
        let radius = min(rect.width, rect.height) / 2

        for (index, value) in values.enumerated() {
            let normalizedValue = nonLinearScale(value: value, maxValue: maxValue)
            let x = center.x + radius * normalizedValue * cos(angle * Double(index) - .pi / 2)
            let y = center.y + radius * normalizedValue * sin(angle * Double(index) - .pi / 2)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()

        return path
    }
    
    private func nonLinearScale(value: Double, maxValue: Double) -> CGFloat {
        let normalizedValue = value / maxValue
        return CGFloat(pow(normalizedValue, 0.5))  // Square root scaling
    }
}

struct RadarChartLabels: View {
    var labels: [String]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.labels.count, id: \.self) { index in
                self.label(for: self.labels[index],
                           at: self.point(for: index, in: geometry.size))
            }
        }
    }
    
    private func point(for index: Int, in size: CGSize) -> CGPoint {
        let angle = 2 * .pi / CGFloat(self.labels.count) * CGFloat(index) - .pi / 2
        let radius = min(size.width, size.height) / 2
        return CGPoint(
            x: size.width / 2 + radius * 1.2 * cos(angle),
            y: size.height / 2 + radius * 1.2 * sin(angle)
        )
    }
    
    private func label(for text: String, at point: CGPoint) -> some View {
        Text(text)
            .font(.system(size: 4, weight: .semibold))
            .foregroundColor(.primary)
            .position(x: point.x, y: point.y)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 20)
    }
}

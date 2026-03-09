//
//  RangeSlider.swift
//  DietApp
//
//  Created by Omar Yunusov on 01.03.26.
//

import SwiftUI

struct RangeSlider: View {
    
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    var step: Double = 1
    var trackHeight: CGFloat = 8
    
    @State private var activeThumb: Thumb? = nil
    
    enum Thumb { case lower, upper }
    
    private func clamp(_ value: Double) -> Double {
        min(max(value, bounds.lowerBound), bounds.upperBound)
    }
    
    private func stepped(_ value: Double) -> Double {
        guard step > 0 else { return value }
        return (value / step).rounded() * step
    }
    
    private func xPosition(for value: Double, width: CGFloat) -> CGFloat {
        let total = bounds.upperBound - bounds.lowerBound
        if total == 0 { return 0 }
        let ratio = (value - bounds.lowerBound) / total
        return CGFloat(ratio) * width
    }
    
    private func value(for x: CGFloat, width: CGFloat) -> Double {
        let clampedX = min(max(0, x), width)
        let total = bounds.upperBound - bounds.lowerBound
        if total == 0 { return bounds.lowerBound }
        let ratio = Double(clampedX / width)
        return bounds.lowerBound + ratio * total
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = max(geo.size.width, 1) // non-finite olmasın
            
            let lowerX = xPosition(for: range.lowerBound, width: width)
            let upperX = xPosition(for: range.upperBound, width: width)
            
            ZStack(alignment: .leading) {
                
                // Track
                Capsule()
                    .fill(LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: trackHeight)
                    .frame(maxHeight: .infinity, alignment: .center)
                
                // Selected range
                Capsule()
                    .fill(Color.green)
                    .frame(width: max(0, upperX - lowerX), height: trackHeight)
                    .offset(x: lowerX)
                    .frame(maxHeight: .infinity, alignment: .center)
                
                // Lower thumb
                thumbView(isActive: activeThumb == .lower)
                    .position(x: lowerX, y: geo.size.height / 2)
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { g in
                                activeThumb = .lower
                                let newValue = stepped(clamp(value(for: g.location.x, width: width)))
                                // lower <= upper
                                let finalLower = min(newValue, range.upperBound)
                                range = finalLower...range.upperBound
                            }
                            .onEnded { _ in activeThumb = nil }
                    )
                
               
                // Upper thumb
                thumbView(isActive: activeThumb == .upper)
                    .position(x: upperX, y: geo.size.height / 2)
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { g in
                                activeThumb = .upper
                                let newValue = stepped(clamp(value(for: g.location.x, width: width)))
                                let finalUpper = max(newValue, range.lowerBound)
                                range = range.lowerBound...finalUpper
                            }
                            .onEnded { _ in activeThumb = nil }
                    )
            }
            .frame(height: 28)
            .contentShape(Rectangle())
        }
        .frame(height: 28)
    }
    
    @ViewBuilder
    private func thumbView(isActive: Bool) -> some View {
        Circle()
            .fill(Color.white)
            .overlay(
                Circle()
                    .stroke(isActive ? .black : Color.gray.opacity(0.35), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
            .frame(width: 22, height: 22)
    }
}

//
//  Components.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 27/06/2024.
//

import SwiftUI

struct IntensityIndicator: View {
    var intensity: Double
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    private func colorForIntensity(_ intensity: Double) -> Color {
        switch intensity {
        case 0...3:
            return .green
        case 4...6:
            return .yellow
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}

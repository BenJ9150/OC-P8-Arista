//
//  Components.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 27/06/2024.
//

import SwiftUI

// MARK: Intensity indicator

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

// MARK: Exercise Icons

struct IconForCategory: View {

    let exercise: String

    var body: some View {
        Image(systemName: iconForCategory(exercise))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24)
    }

    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Aérobic":
            return "figure.step.training"
        case "Basketball":
            return "basketball.fill"
        case "Course à pied":
            return "figure.run"
        case "Cyclisme":
            return "bicycle"
        case "Football":
            return "sportscourt"
        case "Marche rapide":
            return "figure.walk"
        case "Natation":
            return "waveform.path.ecg"
        case "Tennis":
            return "figure.tennis"

        default:
            return "questionmark"
        }
    }
}

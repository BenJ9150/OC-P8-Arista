//
//  IntExtension.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 19/07/2024.
//

import SwiftUI

extension Int16 {
    func qualityColor() -> Color {
        switch 10 - self {
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

    func intensityColor() -> Color {
        switch self {
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

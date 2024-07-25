//
//  IntensityIndicator.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 27/06/2024.
//

import SwiftUI

struct IntensityIndicator: View {
    var intensity: Int16

    var body: some View {
        Circle()
            .fill(intensity.intensityColor())
            .frame(width: 10, height: 10)
    }
}

//
//  IntensityIndicatorView.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 27/06/2024.
//

import SwiftUI

struct IntensityIndicatorView: View {
    var intensity: Int16

    var body: some View {
        Circle()
            .fill(intensity.intensityColor())
            .frame(width: 16, height: 16)
    }
}

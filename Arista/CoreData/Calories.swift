//
//  Calories.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 26/07/2024.
//

import Foundation
import SwiftUI

class Calories: NSObject, Summary {

    var duration: Int32

    var chartColor: Color {
        return .orange
    }

    init(duration: Int32) {
        self.duration = duration
    }
}

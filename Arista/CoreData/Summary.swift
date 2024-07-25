//
//  Summary.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 25/07/2024.
//

import Foundation
import SwiftUI

protocol Summary {

    var duration: Int32 { get set }
    var chartColor: Color { get }
}

struct AnySummary: Summary, Hashable {

    var duration: Int32
    var chartColor: Color

    init<T: Summary>(_ summary: T) {
        self.duration = summary.duration
        self.chartColor = summary.chartColor
    }
}

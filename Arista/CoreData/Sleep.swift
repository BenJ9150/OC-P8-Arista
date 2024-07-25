//
//  Sleep.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData
import SwiftUI

public class Sleep: NSManagedObject, Summary {

    var date: String {
        return startDate?.formatted() ?? ""
    }

    var dateWithoutTime: Date {
        return startDate?.withoutTime() ?? Date()
    }

    var chartColor: Color {
        return quality.qualityColor()
    }
}

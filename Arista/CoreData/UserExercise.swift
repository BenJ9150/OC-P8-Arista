//
//  UserExercise.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 21/06/2024.
//

import Foundation
import CoreData
import SwiftUI

public class UserExercise: NSManagedObject, Summary {

    var date: String {
        return startDate?.formatted() ?? ""
    }

    var category: String {
        return exerciseType?.type ?? ""
    }

    var dateWithoutTime: Date {
        return startDate?.withoutTime() ?? Date()
    }

    var chartColor: Color {
        return intensity.intensityColor()
    }
}

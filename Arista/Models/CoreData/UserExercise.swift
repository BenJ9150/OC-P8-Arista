//
//  UserExercise.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 21/06/2024.
//

import Foundation
import CoreData

public class UserExercise: NSManagedObject {

    var date: String {
        guard let date = startDate else {
            return ""
        }
        return "\(date.formatted())"
    }

    var category: String {
        return exercise?.type ?? ""
    }
}

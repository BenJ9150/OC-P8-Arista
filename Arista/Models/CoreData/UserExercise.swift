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
        return startDate?.formatted() ?? ""
    }

    var category: String {
        return exerciseType?.type ?? ""
    }
}

//
//  Sleep.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 14/06/2024.
//

import Foundation
import CoreData

public class Sleep: NSManagedObject {

    var date: String {
        guard let date = startDate else {
            return ""
        }
        return "\(date.formatted())"
    }
}

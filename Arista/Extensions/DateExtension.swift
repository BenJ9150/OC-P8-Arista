//
//  DateExtension.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 19/07/2024.
//

import Foundation

extension Date {

    func withoutTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }

    func toString(format: String = "d MMM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: self)
    }
}

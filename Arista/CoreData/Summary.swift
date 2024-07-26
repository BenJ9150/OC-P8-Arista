//
//  Summary.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 25/07/2024.
//

import Foundation
import SwiftUI

protocol Summary: Hashable {

    var duration: Int32 { get set }
    var chartColor: Color { get }
}

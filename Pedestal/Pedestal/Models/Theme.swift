//
//  Theme.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

enum Theme: String {
    case background
    case secondary
    case tertiary
    
    var color: Color {
        Color(rawValue)
    }
}

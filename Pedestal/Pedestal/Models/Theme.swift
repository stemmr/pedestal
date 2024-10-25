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
    
    // Text accent colors
    case title
    case subtitle
    case body
    
    var color: Color {
        Color(rawValue)
    }
}

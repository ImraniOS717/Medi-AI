//
//  Colors_Extension.swift
//  Practice
//
//  Created by Ibtidah MacMini on 15/09/2025.
//

import SwiftUI

extension Color {
    /// #C7C7C7
    static let lightCustom : Color = Color(hex:"#C7C7C7")
    /// #1C1C1C
    static let customBlack : Color = Color(hex:"#1C1C1C")
    /// #EDEDED
    static let lightGray : Color = Color(hex:"#EDEDED")
    /// #595959
    static let customGray : Color = Color(hex:"#595959")
    /// #50F839
    static let customGreenColor : Color = Color(hex:"#50F839")
    /// #20205C
    static let customColor : Color = Color(hex:"#20205C")
    /// #FFFFFF
    static let customWhite : Color = Color(hex:"#FFFFFF")
    /// #1BA620
    static let customGreen : Color = Color(hex:"#1BA620")
    /// #20205C1A
    static let customPurple : Color = Color(hex:"#20205C1A")
    
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}



//
//  CustomButtonView.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import SwiftUI

struct CustomButtonView: View {
    
    var buttonTitle: String
    var buttonAction: (() -> Void)
    
    var buttonImage: String = ""
    var shouldShowImage: Bool = false
    
    var buttonFont: Font = Font.regularFont(size: 17)
    var buttonBgColor: Color = .blue
    var buttonForegroundColor: Color = .customBlack
    
    var body: some View {
        Button(action: { buttonAction() }, label: {
            HStack(spacing: 5) {
                if shouldShowImage {
                    Image(buttonImage)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                Text(buttonTitle)
                    .foregroundColor(buttonForegroundColor)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .font(buttonFont)
                    .background(buttonBgColor)
                    .cornerRadius(1000)
            }
        })
        .frame(height: 46)
    }
}

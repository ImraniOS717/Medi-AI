//
//  LoginView.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    var body: some View {
        
        CustomButtonView(buttonTitle: ViewConstants.address,
                         buttonAction: {},
                         buttonImage: "",
                         buttonFont: .regularFont(size: 12),
                         buttonBgColor: .customBlack,
                         buttonForegroundColor: .blue)
        
        .padding(.horizontal, 20)
        
        
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}

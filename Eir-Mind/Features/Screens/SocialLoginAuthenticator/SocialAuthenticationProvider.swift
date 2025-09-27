//
//  SocialAuthenticationProvider.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 27/9/2025.
//


import Foundation
import UIKit

/// Common interface for all authentication providers
protocol SocialAuthenticationProvider {
    func login(viewController: UIViewController) async throws -> SocialSignInUser
}

protocol SocialAuthenticationProviderLogout: SocialAuthenticationProvider {
    func signOut() async
}

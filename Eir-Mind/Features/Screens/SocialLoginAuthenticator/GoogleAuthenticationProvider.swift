//
//  GoogleAuthenticationProvider.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 27/9/2025.
//

import Foundation
//import GoogleSignIn

//public class GoogleAuthenticationProvider: SocialAuthenticationProviderLogout {
//
//    func login(viewController: UIViewController) async throws -> SocialSignInUser {
//        try await withCheckedThrowingContinuation { continuation in
//            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
//                guard error == nil else {
//                    continuation.resume(throwing: error!)
//                    return
//                }
//                guard let signInResult = signInResult else {
//                    continuation.resume(throwing: NSError(domain: "GoogleSignInError", code: 1, userInfo: nil))
//                    return
//                }
//                let user = signInResult.user
//                user.refreshTokensIfNeeded { user, error in
//                    guard error == nil else {
//                        continuation.resume(throwing: error!)
//                        return
//                    }
//                    guard let user = user else {
//                        continuation.resume(throwing: NSError(domain: "GoogleSignInError", code: 1, userInfo: nil))
//                        return
//                    }
//                    printer.print(user.accessToken)
//                    let googleUser = SocialSignInUser(
//                        id: user.idToken?.tokenString ?? "",
//                        name: user.profile?.name ?? "",
//                        email: user.profile?.email ?? "",
//                        profilePicUrl: user.profile?.imageURL(withDimension: 320)?.absoluteString,
//                        provider: .google
//                    )
//                    continuation.resume(returning: googleUser)
//                }
//            }
//        }
//    }
//
//    func signOut() async {
//        GIDSignIn.sharedInstance.signOut()
//    }
//}

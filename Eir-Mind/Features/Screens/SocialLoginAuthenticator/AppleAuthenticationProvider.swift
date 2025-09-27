//
//  AppleAuthenticationProvider.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 27/9/2025.
//

import AuthenticationServices
import UIKit

class AppleAuthenticationProvider: NSObject, SocialAuthenticationProviderLogout {

    // MARK: - Variables and Properties
    private var continuation: CheckedContinuation<SocialSignInUser, Error>?

    // MARK: - SocialAuthenticationProvider Protocol Methods
    func login(viewController: UIViewController) async throws -> SocialSignInUser {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self

            /// Perform the Apple login request and await the result
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                authorizationController.performRequests()
                /// The result will be handled in the delegate method
            }
        } else {
            let error = NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sign in with Apple is not available on this version of iOS"])
            throw error
        }
    }

    func signOut() async {
        checkAppleAuthorization()
    }
}

extension AppleAuthenticationProvider: ASAuthorizationControllerDelegate {

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let firstName = fullName?.givenName
            let lastName = fullName?.familyName

            var keyChainFirstName = firstName ?? ""
            var keyChainLastName = lastName ?? ""
            var keyChainEmail = email ?? ""

            if userIdentifier != "" {
                let isSaved = KeychainWrapper.standard.set(userIdentifier, forKey: StoreAppleCredential.appleuserIdentifier)
                print("Saved userIdentifier in Keychain: \(isSaved)") // Debugging the save result
            }

            if KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleFirstName) == nil {
                if let name = firstName, !name.isEmpty {
                    let isSaved = KeychainWrapper.standard.set(name, forKey: StoreAppleCredential.appleFirstName)
                    print("Saved firstName in Keychain: \(isSaved)") // Debugging the save result
                }
            } else {
                let firstName = KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleFirstName)
                keyChainFirstName = firstName ?? ""
            }

            if KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleLastName) == nil {
                if let lastName = lastName, !lastName.isEmpty {
                    let isSaved = KeychainWrapper.standard.set(lastName, forKey: StoreAppleCredential.appleLastName)
                    print("Saved lastName in Keychain: \(isSaved)") // Debugging the save result
                }
            } else {
                let lastName = KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleLastName)
                keyChainLastName = lastName ?? ""
            }

            if KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleEmail) == nil {
                if let mail = email, !mail.isEmpty {
                    let isSaved = KeychainWrapper.standard.set(mail, forKey: StoreAppleCredential.appleEmail)
                    print("Saved email in Keychain: \(isSaved)") // Debugging the save result
                }
            } else {
                let mail = KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleEmail)
                keyChainEmail = mail ?? ""
            }
            var accessToken: String = ""
            if let identityTokenData = appleIDCredential.identityToken, let identityToken = String(data: identityTokenData, encoding: .utf8) {
                accessToken = identityToken
                print("Identity Token: \(identityToken)")
            }

            // If email is empty, show an error to the user (Uncomment if you need this behavior)
            // if keyChainEmail == "" {
            //     let emailError = NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to your email is required to sign in to our app. Please go to Settings and enable email sharing for our app to continue."])
            //     continuation?.resume(throwing: emailError)
            // } else {
            let userInfo = SocialSignInUser(id: accessToken, name: firstName ?? "\(keyChainFirstName) \(keyChainLastName)", email: keyChainEmail, profilePicUrl: nil, provider: .apple)
            continuation?.resume(returning: userInfo)
            // }
        } else {
            let error = NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "We couldn’t complete your login. Please try again or use a different method.".localize])
            continuation?.resume(throwing: error)
        }
    }

    private func checkAppleAuthorization() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let valuew = KeychainWrapper.standard.string(forKey: StoreAppleCredential.appleuserIdentifier) ?? ""
            appleIDProvider.getCredentialState(forUserID: valuew) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("Authorized")
                    break /// The Apple ID credential is valid.
                case .revoked, .notFound:
                    /// The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    KeychainWrapper.standard.removeObject(forKey: StoreAppleCredential.appleFirstName)
                    KeychainWrapper.standard.removeObject(forKey: StoreAppleCredential.appleLastName)
                    KeychainWrapper.standard.removeObject(forKey: StoreAppleCredential.appleEmail)
                    print("Revoked or not found")
                default:
                    break
                }
            }
        }
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        printer.print("Authorization failed with error: \(error.localizedDescription)", severity: .high)
        /// Handle the failure case
        /// Determine the error code and show a user-friendly message
        var errorMessage = "An error occurred during sign-in. Please try again."

        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                errorMessage = "Sign in was cancelled. Please try again."
            case .failed:
                errorMessage = "Sign-in failed. Please try again later."
            case .invalidResponse:
                errorMessage = "There was an issue with the response. Please try again."
            case .notHandled:
                errorMessage = "The request was not handled. Please try again."
            case .unknown:
                errorMessage = "An unknown error occurred. Please try again."
            default:
                errorMessage = "An unexpected error occurred. Please try again."
            }
        }
        checkAppleAuthorization()
        printer.print("Error during Apple sign-in: \(errorMessage)", severity: .high)
        errorMessage = "We couldn’t complete your login. Please try again or use a different method.".localize
        /// Show the user-friendly error message
        let userFriendlyError = NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])

        /// Resume the continuation with the user-friendly error
        continuation?.resume(throwing: userFriendlyError)
    }
}

extension AppleAuthenticationProvider: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last)!
    }
}

//
//  FirebaseAuth.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import Combine

final class FirebaseAuthService: ObservableObject {
    
    static let shared = FirebaseAuthService()
    
    @Published var isLoggedIn: Bool = false
    
    // Keep handle to avoid memory leak
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
            }
        }
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Email/Password
    func registerUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(result?.user.uid ?? ""))
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(result?.user.uid ?? ""))
                }
            }
        }
    }
    
    // MARK: - Google Sign-In
    func signInWithGoogle(presenting viewController: UIViewController,
                          completion: @escaping (Result<String, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Missing CLIENT_ID in GoogleService-Info.plist"])))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "GoogleSignIn", code: -2,
                                                userInfo: [NSLocalizedDescriptionKey: "Failed to get Google ID token"])))
                }
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(authResult?.user.uid ?? ""))
                    }
                }
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
    }
}


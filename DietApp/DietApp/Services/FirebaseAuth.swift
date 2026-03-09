//
//  FirebaseAuth.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import FirebaseAuth
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
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}

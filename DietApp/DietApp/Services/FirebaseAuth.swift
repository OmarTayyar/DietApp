//
//  FirebaseAuth.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import FirebaseAuth
import Combine

final class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
        
        @Published var isLoggedIn: Bool = false
        
        private init() {
            listenToAuthState { user in
                self.isLoggedIn = user != nil
            }
        }
    
    func registerUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.user.uid ?? ""))
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.user.uid ?? ""))
            }
        }
    }
    
    func signOut(completion: @escaping (Bool, Error?) -> Void) {
         do {
             try Auth.auth().signOut()
             completion(true, nil)
         } catch let error {
             completion(false, error)
         }
     }
    
    func listenToAuthState(completion: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { _ , user in
            completion(user)
        }
    }
}

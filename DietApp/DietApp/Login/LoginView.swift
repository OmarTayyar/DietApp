//
//  LoginView.swift
//  DietApp
//
//  Created by Omar Yunusov on 17.02.26.
//
import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack {
               
                Image(.dietAppLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("Create a meal plan\non the go")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                Text("Choose dishes, view recipes, add to favourites, and create a meal plan")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                HStack {
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#79C314"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }

                    Button(action: {
                        FirebaseAuthService.shared.loginUser(email: email, password: password) { result in
                            switch result {
                            case .success:
                                break // RootView auth listener handles navigation
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Sign In")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background()
                            .foregroundColor(Color(hex: "#79C314"))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.green, lineWidth: 1)
                            )
                    }
                }

                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .padding(.top, 24)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 32)

                Text("OR")
                    .font(.subheadline)
                    .padding(.top, 16)

                HStack {
                    Button(action: {
                        print("Google Login")
                    }) {
                        HStack {
                            Image(.googleLogo)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Google")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                    }

                    Button(action: {
                        print("Apple Login")
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.black)
                            Text("Apple")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 32)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

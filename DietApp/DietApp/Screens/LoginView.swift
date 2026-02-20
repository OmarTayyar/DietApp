//
//  LoginView.swift
//  DietApp
//
//  Created by Omar Yunusov on 17.02.26.
//
import SwiftUI

struct LoginView: View {
    var body: some View {
            VStack {
               
                Image(.dietAppLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                // Title
                Text("Create a meal plan\non the go")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                

                // Subtitle
                Text("Choose dishes, view recipes, add to favourites, and create a meal plan")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                // SignUp / SignIn Buttons
                HStack {
                    Button(action: {
                        // Sign Up action
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
                        // Sign In action
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

                // Email & Password Fields
                VStack(spacing: 16) {
                    TextField("Email", text: .constant(""))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .padding(.top, 24)

                    SecureField("Password", text: .constant(""))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 32)

                // OR Section
                Text("OR")
                    .font(.subheadline)
                    .padding(.top, 16)

                // Google / Apple Login
                HStack {
                    Button(action: {
                        print("Google Login Success")
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
                        print("Apple Login Success")
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
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
}

#Preview {
    LoginView()
}

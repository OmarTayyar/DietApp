//
//  MyProfileView.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//


import SwiftUI
import PhotosUI
import FirebaseAuth

struct MyProfileView: View {

    // MARK: - State
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    @State private var profileImage: UIImage?       = nil
    @State private var headerImage: UIImage?        = nil

    @State private var showProfileImagePicker: Bool = false
    @State private var showHeaderImagePicker: Bool  = false
    @State private var profileImageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var headerImageSource: UIImagePickerController.SourceType  = .photoLibrary

    @State private var showProfileSourceSheet: Bool = false
    @State private var showHeaderSourceSheet: Bool  = false
    @State private var showLogoutAlert: Bool        = false


    // User info from Firebase
    private var userEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }
    private var userName: String {
        Auth.auth().currentUser?.displayName ?? "Omar"
    }

    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: Header Banner
                headerBanner

                // MARK: Profile Info
                VStack(spacing: 0) {
                    // Name
                    Text(userName)
                        .font(.title3.bold())
                        .padding(.top, 12)
                        .padding(.bottom, 16)

                    // Mail row
                    infoRow(label: "Mail", value: userEmail)

                    Divider().padding(.horizontal, 20)

                    // MARK: Dark Mode
                    HStack(spacing: 14) {
                        Image(systemName: "moon")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .frame(width: 24)

                        Text("Dark mode")
                            .font(.body)

                        Spacer()

                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                            .tint(Color(.systemGray3))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)

                    Divider().padding(.horizontal, 20)

                    // MARK: Log Out
                    Button(action: { showLogoutAlert = true }) {
                        HStack(spacing: 14) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                                .frame(width: 24)

                            Text("Log out")
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                    }

                    Divider().padding(.horizontal, 20)
                }
                .background(Color(.systemBackground))
            }
        }
        .ignoresSafeArea(edges: .top)
        .preferredColorScheme(isDarkMode ? .dark : .light)

        // MARK: - Alerts & Sheets
        .confirmationDialog("Choose photo source", isPresented: $showProfileSourceSheet, titleVisibility: .visible) {
            Button("Photo Library") {
                profileImageSource = .photoLibrary
                showProfileImagePicker = true
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    profileImageSource = .camera
                    showProfileImagePicker = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }

        .confirmationDialog("Choose background photo", isPresented: $showHeaderSourceSheet, titleVisibility: .visible) {
            Button("Photo Library") {
                headerImageSource = .photoLibrary
                showHeaderImagePicker = true
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    headerImageSource = .camera
                    showHeaderImagePicker = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }

        .sheet(isPresented: $showProfileImagePicker) {
            ImagePicker(sourceType: profileImageSource, selectedImage: $profileImage)
        }

        .sheet(isPresented: $showHeaderImagePicker) {
            ImagePicker(sourceType: headerImageSource, selectedImage: $headerImage)
        }

        .alert("Do you want to log out?", isPresented: $showLogoutAlert) {
            Button("Log out", role: .destructive) { logOut() }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Header Banner
    private var headerBanner: some View {
        ZStack(alignment: .bottom) {

            // Background color / image
            Group {
                if let headerImage {
                    Image(uiImage: headerImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.red
                }
            }
            .frame(height: 200)
            .clipped()

            // Edit header button (bottom-right of banner)
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showHeaderSourceSheet = true }) {
                        Image(systemName: "pencil")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(7)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 12)
                    .padding(.top, 52)
                }
                Spacer()
            }
            .frame(height: 200)
            
            profileAvatar
                .offset(y: 50)
        }
        .frame(height: 200)
        .padding(.bottom, 50)
    }

    // MARK: - Profile Avatar
    private var profileAvatar: some View {
           ZStack(alignment: .bottomTrailing) {
              Group {
                if let profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(Color(.systemGray5))
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 44))
                                .foregroundColor(Color(.systemGray3))
                        )
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 4))

            Button(action: { showProfileSourceSheet = true }) {
                Image(systemName: "pencil")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color(.systemGray))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 1.5))
            }
            .offset(x: 2, y: 2)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private func logOut() {
        try? Auth.auth().signOut()
    }
}



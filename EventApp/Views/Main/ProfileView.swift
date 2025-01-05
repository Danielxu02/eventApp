//
//  ProfileView.swift
//  EventApp
//
//  Created by Daniel Xu on 12/29/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager
    @State private var username: String = "Loading..."
    @State private var bio: String = "Loading..."
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            // Profile Picture
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.gray)
                .padding(.top, 40)
            
            // Username
            Text(username)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 8)
            
            // Bio
            Text(bio)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.top, 4)
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Edit Profile Button
            Button(action: {
                isEditing.toggle()
            }) {
                Text("Edit Profile")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
            
            // Logout Button
            Button(action: {
                session.signOut()
            }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            loadUserData()
        }
        .sheet(isPresented: $isEditing) {
            EditProfileView(username: $username, bio: $bio)
        }
    }
    
    func loadUserData() {
        if let user = session.currentUser {
            username = user.displayName ?? "User"
            bio = "Welcome to your profile, \(user.email ?? "Unknown")!"
        } else {
            username = "Guest"
            bio = "Please log in to see your profile details."
        }
    }
}

// Edit Profile View (No Change)
struct EditProfileView: View {
    @Binding var username: String
    @Binding var bio: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                }
                
                Section(header: Text("Bio")) {
                    TextField("Bio", text: $bio)
                }
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionManager())
    }
}

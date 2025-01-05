//
//  SessionManager.swift
//  EventApp
//
//  Created by Daniel Xu on 1/3/25.
//

import SwiftUI
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?  // Retain listener

    init() {
        listenForAuthChanges()
    }

    func listenForAuthChanges() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.isLoggedIn = true
                self.currentUser = user
            } else {
                self.isLoggedIn = false
                self.currentUser = nil
            }
        }
    }

    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

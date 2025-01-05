//
//  ContentView.swift
//  EventApp
//
//  Created by Daniel Xu on 12/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        NavigationStack {
            if session.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ActivityListView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            CreatePostView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionManager())  // Provide mock session
    }
}

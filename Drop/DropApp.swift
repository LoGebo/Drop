//
//  DropApp.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

@main
struct DropApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .environment(\.symbolVariants, .fill)
                }
            
            RoutesView()
                .tabItem {
                    Label("Routes", systemImage: "map")
                        .environment(\.symbolVariants, .fill)
                }
            
            AlertsView()
                .tabItem {
                    Label("Alerts", systemImage: "bell")
                        .environment(\.symbolVariants, .fill)
                }
            
            UserView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .environment(\.symbolVariants, .fill)
                }
        }
        .accentColor(.green)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

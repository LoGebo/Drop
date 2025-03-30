import SwiftUI

@main
struct DropApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                NavigationStack {
                    RoutesView()
                }
                .tabItem {
                    Label("Routes", systemImage: "map.fill")
                }
                
                NavigationStack {
                    UserView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            }
            .tint(.green)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
} 

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                switch coordinator.appState {
                case .launch:
                    LaunchView()
                case .main:
                    Choose()
                case .register:
                    RegisterView()
                case .login:
                    LoginView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                route.destination
                    .environmentObject(coordinator)
            }
        }
        .animation(.default, value: coordinator.appState)
        .transition(.opacity)
    }
}


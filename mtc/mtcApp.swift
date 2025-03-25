
import SwiftUI

@main
struct mtcApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppCoordinator.shared)
        }
    }
}

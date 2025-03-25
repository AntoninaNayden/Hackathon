
import SwiftUI
import Combine


final class AppCoordinator: ObservableObject {
    
    static let shared = AppCoordinator()
    
    enum AppState {
        case launch
        case main
        case register
        case login
    }
    
    @Published var selectedSignature: UIImage?
    @Published var navigationPath = NavigationPath()
    @Published var currentRoute: AppRoute?
    @Published var appState: AppState = .launch {
        didSet {
            navigationPath.removeLast(navigationPath.count)
            if appState == .main {
                hasShownPaywall = false
            }
        }
    }
    
    // App Storage
    @AppStorage("hasSeenLaunch") var hasSeenLaunch = false
    
    private var cancellables = Set<AnyCancellable>()
    private var hasShownPaywall = false
    private var hasShownOnboardingPaywall = false
    private let keychainManager = KeychainService()
    
    private init() {}
    
    func navigate(to route: AppRoute) {
        currentRoute = route
        navigationPath.append(route)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func completeLaunch() {
        hasSeenLaunch = true
        let hasToken = KeychainService.shared.getToken(type: .access) != nil
        if hasToken {
            appState = .login
        }
        else {
            appState = .register
        }
    }
}

enum AppRoute: Hashable {
    case login
    case register
    case auf2(email: String, password: String)
    case main
    case sensor

    @ViewBuilder
    var destination: some View {
        switch self {
        case .login:
            LoginView()
        case .register:
            RegisterView()
        case .auf2(let email, let password):
            TwoFactorAuthView(email: email, password: password)
        case .main:
            Choose()
        case .sensor:
            SensorsView()
        }
    }
}

//
//extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//    
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}
//

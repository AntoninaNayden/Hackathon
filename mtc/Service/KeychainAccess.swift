//import KeychainAccess
//
//class KeychainService {
//    static let shared = KeychainService()
//    private let keychain = Keychain(service: "com.YOUR_APP_BUNDLE_ID.auth")
//    
//    enum TokenType: String {
//        case access
//        case refresh
//    }
//    
//    func save(token: String, type: TokenType) {
//        keychain[type.rawValue + "Token"] = token
//    }
//    
//    func getToken(type: TokenType) -> String? {
//        return keychain[type.rawValue + "Token"]
//    }
//    
//    func deleteTokens() {
//        keychain["accessToken"] = nil
//        keychain["refreshToken"] = nil
//    }
//}
//

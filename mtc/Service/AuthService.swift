
import Alamofire
import KeychainAccess
import Foundation

// MARK: - TokenResponse
struct TokenResponse: Decodable {
    let accessToken: String
    let accessTokenExpiration: String
    let refreshToken: String
    let refreshTokenExpiration: String
}


struct ErrorResponse: Decodable {
    let message: String
    let code: Int
}

// MARK: - Custom Errors
enum AuthError: Error {
    case invalidResponse
    case missingToken
    case invalidCredentials
    case tokenRefreshFailed
}

// MARK: - Auth Service
class AuthService {
    static let shared = AuthService()
    private let baseURL = "https://www.smikerls.site"
    
    private init() {}
    
    // MARK: - Registration
    func register(email: String, name: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/account/sign-up"
        
        let parameters: [String: Any] = [
            "email": email,
            "name": name,
            "password": password
        ]
        
        print("📡 Отправка запроса регистрации на:", url)
        print("📤 Параметры запроса:", parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                print("📥 Получен ответ от сервера")
                print("🔍 Статус код:", response.response?.statusCode ?? 0)
                
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("📜 Тело ответа:\n\(rawResponse)")
                } else {
                    print("⚠️ Нет данных в ответе")
                }
                
                switch response.result {
                case .success:
                    print("✅ Регистрация прошла успешно")
                    completion(.success(()))
                case .failure(let error):
                    print("❌ Ошибка при регистрации:", error.localizedDescription)
                    completion(.failure(self.handleError(error, data: response.data)))
                }
            }
    }
    
    // MARK: - Login
    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        let url = "\(baseURL)/Auth/sign-in"
        let parameters = SignInRequest(email: email, password: password)
        
        print("📡 Отправка запроса на логин на:", url)
        print("📤 Параметры запроса:", parameters)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: TokenResponse.self) { response in
                print("📥 Получен ответ от сервера")
                print("🔍 Статус код:", response.response?.statusCode ?? 0)
                
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("📜 Тело ответа:\n\(rawResponse)")
                } else {
                    print("⚠️ Нет данных в ответе")
                }
                
                switch response.result {
                case .success(let tokens):
                    print("✅ Логин успешен! Токен:", tokens.accessToken)
                    KeychainService.shared.save(token: tokens.accessToken, type: .access)
                    KeychainService.shared.save(token: tokens.refreshToken, type: .refresh)
                    completion(.success(tokens))
                case .failure(let error):
                    print("❌ Ошибка при логине:", error.localizedDescription)
                    completion(.failure(self.handleError(error, data: response.data)))
                }
            }
    }

    
    func confirmEmail(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
           let url = "\(baseURL)/account/email/confirmation"
           let parameters: [String: Any] = ["email": email, "code": code]

           AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
               .validate()
               .response { response in
                   switch response.result {
                   case .success:
                       completion(.success(()))
                   case .failure(let error):
                       completion(.failure(self.handleError(error, data: response.data)))
                   }
               }
       }

    
    // MARK: - 2FA Verification
    func verify2FA(code: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        let url = "\(baseURL)/Auth/sign-in/2fa"
        
        guard let email = KeychainService.shared.getEmail(),
              let password = KeychainService.shared.getPassword() else {
            print("❌ Ошибка: отсутствуют email или пароль в Keychain")
            completion(.failure(AuthError.invalidCredentials))
            return
        }
        
        let parameters = SignInWithCodeRequest(
            email: email,
            password: password,
            code: code
        )
        
        print("📡 Отправка запроса 2FA на:", url)
        print("📤 Параметры запроса:", parameters)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: TokenResponse.self) { response in
                
                print("📥 Получен ответ от сервера")
                print("🔍 Статус код:", response.response?.statusCode ?? 0)
                
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("📜 Тело ответа:\n\(rawResponse)")
                } else {
                    print("⚠️ Нет данных в ответе")
                }
                
                switch response.result {
                case .success(let tokens):
                    KeychainService.shared.save(token: tokens.accessToken, type: .access)
                    KeychainService.shared.save(token: tokens.refreshToken, type: .refresh)
                    completion(.success(tokens))
                case .failure(let error):
                    print("❌ Ошибка при верификации 2FA:", error.localizedDescription)
                    let handledError = self.handleError(error, data: response.data)
                    print("🔴 Обработанная ошибка:", handledError.localizedDescription)
                    completion(.failure(handledError))
                }
            }
    }
    
    // MARK: - Token Refresh
    func refreshToken(completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        let url = "\(baseURL)/Auth/tokens"
        guard let refreshToken = KeychainService.shared.getToken(type: .refresh) else {
            print("❌ Ошибка: отсутствует refresh token в Keychain")
            completion(.failure(AuthError.missingToken))
            return
        }
        
        let parameters = RefreshTokenRequest(refreshToken: refreshToken)
        
        print("📡 Отправка запроса на обновление токена на:", url)
        print("📤 Параметры запроса:", parameters)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: TokenResponse.self) { response in
                print("📥 Получен ответ от сервера")
                print("🔍 Статус код:", response.response?.statusCode ?? 0)
                
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("📜 Тело ответа:\n\(rawResponse)")
                } else {
                    print("⚠️ Нет данных в ответе")
                }
                
                switch response.result {
                case .success(let tokens):
                    print("✅ Токен обновлен! Новый токен:", tokens.accessToken)
                    KeychainService.shared.save(token: tokens.accessToken, type: .access)
                    KeychainService.shared.save(token: tokens.refreshToken, type: .refresh)
                    completion(.success(tokens))
                case .failure(let error):
                    print("❌ Ошибка при обновлении токена:", error.localizedDescription)
                    KeychainService.shared.deleteAll()
                    completion(.failure(self.handleError(error, data: response.data)))
                }
            }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: AFError, data: Data?) -> Error {
        print("⚠️ Обработка ошибки...")
        
        if let data = data,
           let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            print("📝 Сообщение об ошибке от сервера:", errorResponse.message)
            return NSError(
                domain: "APIError",
                code: errorResponse.code,
                userInfo: [NSLocalizedDescriptionKey: errorResponse.message]
            )
        }
        
        print("🛑 Не удалось декодировать ошибку из ответа.")
        return error
    }
}


// MARK: - Keychain Service
class KeychainService {
    static let shared = KeychainService()
    private let keychain = Keychain(service: "com.YOUR_APP_BUNDLE_ID.auth")
    
    enum TokenType: String {
        case access
        case refresh
    }
    
    func save(token: String, type: TokenType) {
        keychain[type.rawValue + "Token"] = token
    }
    
    func getToken(type: TokenType) -> String? {
        return keychain[type.rawValue + "Token"]
    }
    
    func save(email: String, password: String) {
        keychain["email"] = email
        keychain["password"] = password
    }
    
    func getEmail() -> String? {
        return keychain["email"]
    }
    
    func getPassword() -> String? {
        return keychain["password"]
    }
    
    func deleteAll() {
        keychain["accessToken"] = nil
        keychain["refreshToken"] = nil
        keychain["email"] = nil
        keychain["password"] = nil
    }
}

// MARK: - Request Models
struct SignInRequest: Encodable {
    let email: String
    let password: String
}

struct SignInWithCodeRequest: Encodable {
    let email: String
    let password: String
    let code: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

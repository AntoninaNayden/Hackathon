import SwiftUI

struct TwoFactorAuthView: View {
    @State private var code = ""
    @State private var errorMessage = ""

    var email: String
    var password: String
    
    @State private var is2FAVerified = false

    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            FloatingImagesView()

            VStack(spacing: 16) {
                TextField("Код", text: $code)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)

                Button("Подтвердить") {
                    verify2FA()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 155/255, green: 5/255, blue: 3/255))
                .foregroundColor(.white)
                .cornerRadius(8)

                Text(errorMessage)
                    .foregroundColor(Color(red: 155/255, green: 5/255, blue: 3/255))
            }
            .padding()
            if is2FAVerified {
                Text("2FA успешна!")
                    .foregroundColor(.green)
                    .font(.headline)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func verify2FA() {
        AuthService.shared.confirmEmail(email: email, code: code) { result in
            switch result {
            case .success:
                print("✅ Почта подтверждена!")

                AuthService.shared.login(email: email, password: password) { loginResult in
                    switch loginResult {
                    case .success(let tokenResponse):
                        KeychainService.shared.save(token: tokenResponse.accessToken, type: .access)
                        KeychainService.shared.save(token: tokenResponse.refreshToken, type: .refresh)
                        print("✅ Логин успешен! Токены сохранены в Keychain.")

                        DispatchQueue.main.async {
                            self.is2FAVerified = true
                            self.coordinator.navigate(to: .main)
                        }
                        
                    case .failure(let error):
                        self.errorMessage = "Ошибка при логине: \(error.localizedDescription)"
                    }
                }

            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }

//        AuthService.shared.verify2FA(code: code) {  result in
//            switch result {
//            case .success(let tokenResponse):
//                print("✅ 2FA успешно подтверждена! Токен:", tokenResponse.token)
//           
//                
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.errorMessage = error.localizedDescription
//                    print("❌ Ошибка 2FA:", error.localizedDescription)
//                }
//            }
//        }
    }
}

#Preview {
    TwoFactorAuthView(email: "user@example.com", password: "userPassword")
}


import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isRegistered = false
    @State private var confirmationCode = ""
    @State private var isEmailConfirmed = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                FloatingImagesView()

                VStack(spacing: 16) {
                    // Ввод email
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                    // Ввод имени
                    TextField("Имя", text: $name)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                    // Ввод пароля
                    SecureField("Пароль", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                    Button("Зарегистрироваться") {
                        AuthService.shared.register(email: email, name: name, password: password) { result in
                            switch result {
                            case .success:
                                print("✅ Регистрация успешна!")
                                KeychainService.shared.save(email: email, password: password)
                                print("🔐 Данные сохранены в Keychain")
                                isRegistered = true
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 155/255, green: 5/255, blue: 3/255))
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    }
                    Text(errorMessage)
                        .foregroundColor(Color(red: 155/255, green: 5/255, blue: 3/255))
                        .padding()
                        NavigationLink(destination: TwoFactorAuthView(email: email, password: password), isActive: $isRegistered) {
                            EmptyView()
                        }
                }
            }
        }
    }


#Preview {
    RegisterView()
}

import SwiftUI

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @EnvironmentObject private var coordinator: AppCoordinator
    
    
    var body: some View {
        ZStack {
            // Фон
            Color.black
                .edgesIgnoringSafeArea(.all)
//            
            // Плавающие буквы M, T, S
            FloatingImagesView()
            
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                
                SecureField("Пароль", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            
                Button("Войти") {
                    login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 155/255, green: 5/255, blue: 3/255))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Text(errorMessage)
                    .foregroundColor(Color(red: 155/255, green: 5/255, blue: 3/255))
                   // .foregroundColor(.red)
                    .padding(.top, 38)
            }
            .padding()
        }
    }
    
   
    
    // Логика входа
    private func login() {
        AuthService.shared.login(email: email, password: password) { result in
            switch result {
            case .success:
                print("✅ Вход успешен!")
                DispatchQueue.main.async {
                    self.coordinator.navigate(to: .main)
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginView()
}



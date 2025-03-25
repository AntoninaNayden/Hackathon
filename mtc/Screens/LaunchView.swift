
import SwiftUI

struct LaunchView: View {
    @State private var mOffset: CGFloat = 100
    @State private var tOffset: CGFloat = 500
    @State private var sOffset: CGFloat = 600
    
    @State private var mFloatingOffset: CGFloat = 0
    @State private var tFloatingOffset: CGFloat = 0
    @State private var sFloatingOffset: CGFloat = 0
    
    @ObservedObject private var coordinator = AppCoordinator.shared
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            Image("m")
                .resizable()
                .scaledToFit()
                .colorMultiply(Color(red: 0.7, green: 0.0, blue: 0.13))
                .frame(width: 200, height: 220)
                .offset(x: -100, y: mOffset + mFloatingOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.0)) {
                        mOffset = -260
                    }

                    withAnimation(
                        Animation.easeInOut(duration: 2.5)
                            .repeatForever(autoreverses: true)
                    ) {
                        mFloatingOffset = -25
                    }
                }

            Image("t")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 220)
                .colorMultiply(Color(red: 0.7, green: 0.0, blue: 0.13))
                .offset(x: 100, y: tOffset + tFloatingOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.5)) {
                        tOffset = -60
                    }
                    withAnimation(
                        Animation.easeInOut(duration: 3.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        tFloatingOffset = 20
                    }
                }

            Image("s")
                .resizable()
                .scaledToFit()
                .frame(width: 210, height: 230)
                .colorMultiply(Color(red: 0.63, green: 0.0, blue: 0.13))
                .offset(x: -30, y: sOffset + sFloatingOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: 3.0)) {
                        sOffset = 240
                    }
                    withAnimation(
                        Animation.easeInOut(duration: 2.8)
                            .repeatForever(autoreverses: true)
                    ) {
                        sFloatingOffset = -18
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let hasToken = KeychainService.shared.getToken(type: .access) != nil
                print("Токен в Keychain: \(hasToken ? "есть" : "нет")")
                
                if hasToken {
                    coordinator.navigate(to: .login)
                    coordinator.completeLaunch()
                } else {
                    coordinator.navigate(to: .register)
                    coordinator.completeLaunch()
                }
            }
        }
    }
}

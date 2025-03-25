
import SwiftUI

struct FloatingImagesView: View {
    @State private var mOffset: CGFloat = 100
    @State private var tOffset: CGFloat = 500
    @State private var sOffset: CGFloat = 600
    
    @State private var mFloatingOffset: CGFloat = 0
    @State private var tFloatingOffset: CGFloat = 0
    @State private var sFloatingOffset: CGFloat = 0
    
    
    var body: some View {
        ZStack {
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
    }
}


struct MetalImages: View {
    @State private var mOffset: CGFloat = -300
    @State private var tOffset: CGFloat = 500
    @State private var sOffset: CGFloat = 600
    
    @State private var mFloatingOffset: CGFloat = 0
    @State private var tFloatingOffset: CGFloat = 0
    @State private var sFloatingOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image("metal4")
                .resizable()
                .blur(radius: 4)
                .scaledToFit()
                .colorMultiply(Color(red: 0.8, green: 0.0, blue: 0.13))
                .frame(width: 300, height: 320)
                .offset(x: -100, y: mOffset + mFloatingOffset)
                .position(x: 200, y: 340)

            Image("metal5")
                .resizable()
                .blur(radius: 4)
                .scaledToFit()
                .frame(width: 400, height: 420)
                .colorMultiply(Color(red: 0.8, green: 0.0, blue: 0.13))
                .offset(x: 130, y: tOffset + tFloatingOffset)
                .position(x: 200, y: -130)

            

            Image("metal3")
                .resizable()
                .blur(radius: 4)
                .scaledToFit()
                .frame(width: 360, height: 380)
                .colorMultiply(Color(red: 1, green: 0.0, blue: 0.13))
                .offset(x: -90, y: sOffset + sFloatingOffset)
                .position(x: 180, y: 70)

        }
    }
}



struct ProfileView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            MetalImages()
            
            VStack(spacing: 16) {
                Text("Ваш профиль")
                    .font(.title)
                    .foregroundColor(.white)
                
                Button("Выйти") {
//                    KeychainService.shared.deleteToken()
                    isLoggedIn = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 183/255, green: 13/255, blue: 34/255))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView()
}



import SwiftUI

enum Tab {
    case profile
    case world
    case user
}

struct MainTabView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 70) {
            Button(action: {
                selectedTab = .profile
            }) {
                Image("persona")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .colorMultiply(selectedTab == .profile ? Color(red: 0.8, green: 0.0, blue: 0.13) : .white)
                    
                
            }
  
            Button(action: {
                selectedTab = .world
            }) {
                Image("globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 31, height: 31)
                    .colorMultiply(selectedTab == .world ? Color(red: 0.8, green: 0.0, blue: 0.13) : .white)
                    .padding(.top, 4)
                   
                    
            }
           
            Button(action: {
                selectedTab = .user
            }) {
                Image("user")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .colorMultiply(selectedTab == .user ? Color(red: 0.8, green: 0.0, blue: 0.13) : .white)
                   
            }
        }
        .padding(.vertical, 16)
        .background(Color.black)
        .cornerRadius(20)
        .shadow(radius: 5)
       // .frame(width: 700)
        .frame(maxWidth: .infinity)
        //.padding(.horizontal, 16)
        //.padding(.bottom, 16)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(selectedTab: .constant(.profile))
            .previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}


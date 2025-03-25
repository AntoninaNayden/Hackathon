//
//  Grafik.swift
//  mtc
//
//  Created by Antonina on 19.03.25.
//

import SwiftUI

struct GrafikView: View {
    @Environment(\.dismiss) var dismiss
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack(spacing: 20) {
                
                Button(action: {
                    dismiss()
                }) {
                    Image("Close")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(.leading, geometry.size.height * 0.40)
                
                Text("Grafik")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: geometry.size.width / 2)

            }
            .padding()
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height > 0 {
                            dragOffset = gesture.translation.height
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.height > 10 {
                            withAnimation {
                                dismiss()
                            }
                        } else {
                            withAnimation {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
    }
}


#Preview {
    GrafikView()
}

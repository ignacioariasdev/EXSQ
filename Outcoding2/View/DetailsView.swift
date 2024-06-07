//
//  DetailsView.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import SwiftUI

struct DetailsView: View {
    var title: String
    var description: String
    
    @State private var animate: Bool = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
            Text(description)
                .font(.body)
        }
        .padding()
        .scaleEffect(animate ? 1 : 0.5)
        .opacity(animate ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 0)) {
                animate = true
            }
        }
        .onDisappear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 0)) {
                animate = false
            }
        }
    }
}


#Preview {
    DetailsView(title: "", description: "")
}

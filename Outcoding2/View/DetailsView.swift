//
//  DetailsView.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import SwiftUI
import Kingfisher

struct DetailsView: View {
    var imageUrl: URL
    var title: String
    var description: String
    var origin: String
    
    var lifeSpan: String
    let affectionLevel: Int
    
    @State private var animate: Bool = false
    
    var body: some View {
        VStack {
            KFImage(imageUrl)
                .resizable()
                .placeholder {
                    ProgressView().padding()
                }
                .cornerRadius(10)
                .scaledToFit()
            
            Text(title)
                .font(.largeTitle)
                        
            VStack(alignment: .leading, spacing: 15) {
                Text(origin)
                
                Text("Life Span: \(lifeSpan)")
                
                Text("Affection Level: \(affectionLevel)")
                
                ProgressBar(value: affectionLevel)
                    .frame(height: 20)
                    .padding(.horizontal)
            }
            .font(.headline)
            .padding()
            
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
        Spacer()
    }
}

struct ProgressBar: View {
    var value: Int
    var maxValue: Int = 10
    @State private var animatedProgress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle() // Background
                    .foregroundColor(.gray.opacity(0.3))
                    .cornerRadius(45)

                Rectangle() // Foreground
                    .frame(width: animatedProgress * geometry.size.width)
                    .foregroundColor(interpolateColor(value: value, maxValue: maxValue))
                    .cornerRadius(45)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = CGFloat(value) / CGFloat(maxValue)
            }
        }
    }

    private func interpolateColor(value: Int, maxValue: Int) -> Color {
        let fraction = Double(value) / Double(maxValue)
        if fraction < 0.33 {
            return .red
        } else if fraction < 0.66 {
            return .yellow
        } else {
            return .green
        }
    }
}


#Preview {
    DetailsView(imageUrl: URL(string: "www.example.com")!, title: "", description: "", origin: "", lifeSpan: "", affectionLevel: 0)
}

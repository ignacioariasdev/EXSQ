//
//  ContentView.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if !viewModel.anyError.isEmpty {
                    Text("HttpStatusCode: " + viewModel.httpStatusCode.description)
                    Text(viewModel.anyError)
                }
                if viewModel.listMain.isEmpty && viewModel.anyError.isEmpty {
                    VStack {
                        Text("Waiting for backend ")
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    ForEach(viewModel.listMain) { model in
                        ForEach(model.breeds) { breeds in
                            NavigationLink {
                                if let imageUrl = try? viewModel.getImageUrl(from: model.url) {
                                    DetailsView(imageUrl: imageUrl, title: breeds.name, description: breeds.description, origin: breeds.origin, lifeSpan: breeds.lifeSpan, affectionLevel: breeds.affectionLevel)
                                } else {
                                    Text("Image not available")
                                        .accessibilityLabel("No image available for \(breeds.name)")
                                }
                            } label: {
                                if let imageUrl = try? viewModel.getImageUrl(from: model.url) {
                                    Dashboard(imageUrl: imageUrl, breed: breeds)
                                        .equatable()
                                        .accessibilityElement(children: .combine)
                                } else {
                                    Text("Image not available")
                                        .accessibilityLabel("No image available for \(breeds.name)")
                                }
                            }
                        }
                        .onAppear {
                            Task {
                                try await viewModel.didDisplayedLastItem(item: model)
                            }
                        }
                    }
                    .transition(.blurReplace)
                }
            }
            .listStyle(.plain)
            .accessibilityIdentifier("BreedsList")
            .animation(.easeInOut, value: viewModel.listMain.isEmpty)
        }
        .navigationTitle("Breeds List")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct Dashboard: View, Equatable {
    let imageUrl: URL
    let breed: ModelResults
    
    var body: some View {
        LazyVStack {
            Text(breed.name)
                .accessibilityElement(children: .combine)
            
            KFImage(imageUrl)
                .resizable()
                .placeholder {
                    ProgressView().padding()
                }
                .cornerRadius(10)
                .scaledToFit()
                .accessibilityLabel("Image of \(breed.name)")
        }
    }
    
    static func == (lhs: Dashboard, rhs: Dashboard) -> Bool {
        return lhs.breed.appId == rhs.breed.appId &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.breed.name == rhs.breed.name
    }
}


#Preview {
    ContentView()
}

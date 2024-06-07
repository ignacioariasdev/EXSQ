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
                    Text("Waiting for backend ")
                    Text("HttpStatusCode: " + viewModel.httpStatusCode.description)
                    Text(viewModel.anyError)
                }
                if viewModel.listMain.isEmpty {
                    Text("Waiting for backend ")
                        .transition(.opacity)
                } else {
                    ForEach(viewModel.listMain) { model in
                        ForEach(model.breeds) { breeds in
                            NavigationLink {
                                DetailsView(title: breeds.name, description: breeds.description)
                            } label: {
                                if let imageUrl = try? viewModel.getImageUrl(from: model.url) {
                                    Dashboard(imageUrl: imageUrl, breed: breeds)
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
                    .transition(.slide)
                }
            }
            .accessibilityIdentifier("BreedsList")
            .animation(.easeInOut, value: viewModel.listMain.isEmpty)
        }
        .navigationTitle("Breeds List")
           .navigationBarTitleDisplayMode(.inline)
    }
}


struct Dashboard: View {
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
}


#Preview {
    ContentView()
}

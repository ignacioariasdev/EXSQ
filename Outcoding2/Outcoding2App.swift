//
//  Outcoding2App.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import SwiftUI

@main
struct Outcoding2App: App {


    var viewModel: ViewModel
    var api: API

    init() {
        api = API()
        viewModel = ViewModel(api: api)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

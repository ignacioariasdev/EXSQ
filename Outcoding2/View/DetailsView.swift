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
    var body: some View {
        Text(title)
        Text(description)
            .padding()
    }
}

#Preview {
    DetailsView(title: "", description: "")
}

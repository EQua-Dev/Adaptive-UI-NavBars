//
//  ContentView.swift
//  AdaptiveLayoutDesign
//
//  Created by Richard Uzor on 13/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
  Home()
    }


}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

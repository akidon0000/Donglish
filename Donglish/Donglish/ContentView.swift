//
//  ContentView.swift
//  Donglish
//
//  Created by Akihiro Matsuyama on 2026/03/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Donglish")
                .font(.largeTitle)
                .navigationTitle("Donglish")
        }
    }
}

#Preview {
    ContentView()
}

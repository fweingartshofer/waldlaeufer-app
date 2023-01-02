//
//  ContentView.swift
//  waldlaeufer
//
//  Created by Florian Weingartshofer on 29.12.22.
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                HeatmapView()
                        .ignoresSafeArea(edges: .all)
                VStack {
                    Spacer()
                    AddButton()
                            .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

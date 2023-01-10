//
//  ContentView.swift
//  waldlaeufer
//
//  Created by Florian Weingartshofer on 29.12.22.
//
//

import SwiftUI

struct ContentView: View {

    @StateObject private var manager = LocationManagerViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                HeatmapView(region: $manager.region)
                        .ignoresSafeArea(edges: .all)
                VStack {
                    Spacer()
                    AddButtonView()
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

//
//  AddButton.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 29.12.22.
//
//

import SwiftUI

struct AddButton: View {
    @State private var showingSheet = false
    var body: some View {
        Button {
            showingSheet = !showingSheet
        } label: {
            Image(systemName: "plus")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            AddLocationDataView()
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}

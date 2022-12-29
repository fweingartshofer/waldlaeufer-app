//
//  AddButton.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 29.12.22.
//
//

import SwiftUI

struct AddButton: View {
    var body: some View {
        Button(action: addLocationData) {
            Image(systemName: "plus")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
        }.buttonStyle(PlainButtonStyle())
    }

    func addLocationData() {
        print("-- add location data entry --")
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}

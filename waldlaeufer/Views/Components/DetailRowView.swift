//
//  DetailRowView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 03.01.23.
//
//

import SwiftUI

struct DetailRowView: View {

    var label: String
    var content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            Text(content)
                    .foregroundColor(.primary)
                    .font(.headline)
        }
    }
}

struct DetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        DetailRowView(label: "label", content: "content")
    }
}

//
//  EditTagView.swift
//  waldlaeufer
//
//  Created by Florian Weingartshofer on 02.01.23.
//
//

import SwiftUI
import SwiftUIFlowLayout

struct EditTagView: View {

    @Binding public var tags: [String]
    @State private var currentTag: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Tags", text: $currentTag)
                .onSubmit(appendCurrentTagAndClear)
                .focused($isFocused)
        List {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
            }
                    .onDelete { indexSet in
                        tags.remove(atOffsets: indexSet)
                    }
        }
    }

    func appendCurrentTagAndClear() {
        isFocused = true
        if (!tags.contains(where: { $0.caseInsensitiveCompare(currentTag) == .orderedSame })) {
            tags.append(currentTag)
        }
        currentTag = ""
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        EditTagView(tags: .constant([]))
    }
}

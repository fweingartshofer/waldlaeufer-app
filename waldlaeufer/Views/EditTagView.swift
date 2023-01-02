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

    @State private var tags: [String] = []
    @State private var currentTag: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            TextField("Tags", text: $currentTag)
                    .onSubmit(appendCurrentTagAndClear)
                    .focused($isFocused)
        }
        FlowLayout(
                mode: .scrollable,
                items: tags,
                itemSpacing: 4
        ) { tag in
            HStack {
                Text(tag)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                Button() {
                    print("\(tag)")
                    tags = tags.filter { $0 != tag }
                } label: {
                    Image(systemName: "delete.left")
                }
            }
                    .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .border(Color.blue)
                                    .foregroundColor(Color.gray))
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
        EditTagView()
    }
}

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

    @Binding public var tags: [Tag]

    @StateObject var viewModel: EditTagViewModel = EditTagViewModel()

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Tags", text: $viewModel.currentTagName)
                .focused($isFocused)
                .onSubmit(appendAndClear)
                .onChange(of: viewModel.currentTagName) { value in
                    viewModel.search(value, tagsToExclude: tags)
                }
                .onAppear {
                    viewModel.start()
                }
        List(viewModel.searchResults, id: \.name) { tag in
            Button(action: {
                tags.append(tag)
                viewModel.currentTagName = ""
            }) {
                Text(tag.name)
            }
        }
                .offset()
        List {
            ForEach(tags, id: \.name) { tag in
                Text(tag.name)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
            }
                    .onDelete { indexSet in
                        tags.remove(atOffsets: indexSet)
                    }
        }
    }

    func appendAndClear() {
        isFocused = true
        if (!tags.contains(where: { $0.name.caseInsensitiveCompare(viewModel.currentTagName) == .orderedSame })) {
            tags.append(Tag(id: nil, name: viewModel.currentTagName))
        }
        viewModel.currentTagName = ""
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        EditTagView(tags: .constant([]))
    }
}

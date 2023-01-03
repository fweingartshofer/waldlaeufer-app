//
//  AddLocationDataView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 02.01.23.
//
//

import SwiftUI
import FirebaseFirestore

struct AddLocationDataView: View {

    @State private var wellbeing: SubjectiveWellbeing = .GOOD
    @State private var timestamp = Date.now
    @State private var useCustomLocation = false
    @State private var tags: [String] = []

    @StateObject var manager = LocationViewModel()
    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var viewModel = LocationDataViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $wellbeing, label: Text("Subjective Wellbeing")) {
                        ForEach(SubjectiveWellbeing.allCases, id: \.self) {
                            Text($0.description).tag($0)
                        }
                    }
                    Toggle("Custom location", isOn: $useCustomLocation)
                    DatePicker("Date & Time", selection: $timestamp)
                    EditTagView(tags: $tags)
                }
                Spacer()
            }
                    .navigationBarTitle(Text("New location entry"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        saveAndClose()
                    }) {
                        Text("Done").bold()
                    })
        }
    }

    func saveAndClose() {
        let newLocationData = LocationData(
                id: nil,
                timestamp: timestamp,
                subjectiveWellbeing: wellbeing,
                geoLocation: useCustomLocation
                        ? GeoLocation(latitude: 0, longitude: 0)
                        : GeoLocation(coordinates: manager.region),
                db: nil,
                radius: nil,
                tags: tags
        )

        viewModel.insert(locationData: newLocationData)
        dismiss()
    }
}

struct AddLocationDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationDataView()
    }
}

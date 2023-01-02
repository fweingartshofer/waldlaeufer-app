//
//  AddLocationDataView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 02.01.23.
//
//

import SwiftUI

struct AddLocationDataView: View {

    @State private var wellbeing: SubjectiveWellbeing = .GOOD
    @State private var timestamp = Date.now
    @State private var useCustomLocation = false
    @State private var tagInput: String = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $wellbeing, label: Text("Subjective Wellbeing")) {
                        ForEach(SubjectiveWellbeing.allCases, id: \.self) {
                            Text($0.description).tag($0)
                        }
                    }
                    EditTagView()
                    Toggle("Custom location", isOn: $useCustomLocation)
                    DatePicker("Date & Time", selection: $timestamp)
                }
                Spacer()
            }
            .navigationBarTitle("Add new entry")
            .navigationBarItems(trailing: Button(action: {
                saveAndClose()
            }) {
                Text("Done").bold()
            })
        }
    }

    func saveAndClose() {
        let newLocationData = LocationData(
                timestamp: $timestamp.wrappedValue,
                subjectiveWellbeing: $wellbeing.wrappedValue,
                geoLocation: GeoLocation(0, 0),
                db: nil,
                radius: nil,
                tags: [$tagInput.wrappedValue]
        )

        RepositoryFactory.getFirebaseLocationRepository().insert(
                locationData: newLocationData)
        dismiss()
    }
}

struct AddLocationDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationDataView()
    }
}

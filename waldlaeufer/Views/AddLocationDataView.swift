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

    @StateObject var manager = LocationManager()
    @Environment(\.dismiss) private var dismiss

    private var viewModel = LocationDataViewModel()

    public var db: Float?

    init(db: Float?) {
        self.db = db
    }

    var body: some View {
        NavigationStack {
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
                    .navigationBarItems(
                            leading: Button(action: {
                                dismiss()
                            }) {
                                Text("Cancel").bold()
                            }, trailing: Button(action: {
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
                db: db != nil ? round(db! * 1000) / 1000.0 : nil,
                radius: nil,
                tags: tags
        )

        viewModel.insert(locationData: newLocationData)
        dismiss()
    }
}

struct AddLocationDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationDataView(db: nil)
    }
}

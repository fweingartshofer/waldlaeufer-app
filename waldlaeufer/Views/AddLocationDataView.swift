//
//  AddLocationDataView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 02.01.23.
//
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct AddLocationDataView: View {
    @State private var wellbeing: SubjectiveWellbeing = .GOOD
    @State private var timestamp = Date.now
    @State private var useCustomLocation = false
    @State private var stressLevel: Double? = nil
    @State private var tags: [Tag] = []
    @State private var radius: CustomLocation = CustomLocation(coordinate: CLLocationCoordinate2D())

    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel = AddLocationDataViewModel()

    var db: Float?
    @State var userLocation: MKCoordinateRegion
    @State var customLocation: MKCoordinateRegion?

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .saving:
                    ProgressView()
                case .form:
                    VStack(spacing: 0) {
                        MetaInfoView(db: db, stressLevel: $stressLevel)
                                .frame(height: 180)
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
                    }
                            .padding(0)
                            .navigationBarTitle(Text("How do you feel?"), displayMode: .inline)
                            .navigationBarItems(
                                    leading: Button(action: {
                                        dismiss()
                                    }) {
                                        Text("Cancel").bold()
                                    }, trailing: Button(action: {
                                if useCustomLocation {
                                    viewModel.state = .customMap
                                } else {
                                    saveAndClose()
                                }
                            }) {
                                Text(useCustomLocation ? "Continue" : "Done").bold()
                            })
                case .customMap:
                    Map(
                            coordinateRegion: Binding(
                                    get: { customLocation ?? userLocation },
                                    set: {
                                        customLocation = $0
                                        radius = CustomLocation(coordinate: customLocation!.center)
                                    }
                            ),
                            showsUserLocation: true,
                            userTrackingMode: .none,
                            annotationItems: [radius]) { (location: CustomLocation) in
                        MapAnnotation(coordinate: radius.coordinate, content: {
                            ZStack {
                                Circle()
                                        .fill(Color.gray.opacity(0.8))
                                        .frame(width: 8, height: 8)
                                Circle()
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 256, height: 256)
                            }

                        })
                    }
                            .navigationBarTitle(Text("Choose custom location"), displayMode: .inline)
                            .navigationBarItems(
                                    leading: Button("Cancel", action: { viewModel.state = .form }).bold(),
                                    trailing: Button("Save", action: saveAndClose)
                            )
                }
            }
                    .task {
                        stressLevel = viewModel.getStressLevel()
                        wellbeing = mapDbAndStressLevelToWellbeing(db: db, stressLevel: stressLevel)
                    }
        }
    }

    func saveAndClose() {
        let newLocationData = LocationData(
                id: nil,
                timestamp: timestamp,
                subjectiveWellbeing: wellbeing,
                geoLocation: GeoLocation(coordinates: useCustomLocation && customLocation != nil
                        ? customLocation!.center
                        : userLocation.center),
                db: db?.round(places: 3),
                radius: nil,
                tags: tags
        )
        viewModel.insert(locationData: newLocationData)
        dismiss()
    }
}

struct CustomLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct AddLocationDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationDataView(db: 160, userLocation: MKCoordinateRegion())
    }
}

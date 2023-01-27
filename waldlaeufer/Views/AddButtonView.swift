//
//  AddButtonView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 29.12.22.
//
//

import SwiftUI
import MapKit

struct AddButtonView: View {
    @State private var showingSheet = false
    @State private var showingAlert = false

    @State private var isRecording = false
    @Binding var currentRegion: MKCoordinateRegion

    @State var db: Float = 0

    var body: some View {
        Button {
            showingAlert = !showingAlert
        } label: {
            Image(systemName: "plus")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
        }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingSheet) {
                        if isRecording {
                            SoundRecorderView(isRecording: $isRecording, db: $db)
                                    .presentationDetents([.medium])
                        } else {
                            AddLocationDataView(currentRegion: currentRegion, db: db)
                                    .presentationDetents([.large])
                        }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                            title: Text("Do you want to record sound or skip straight to the survey?"),
                            primaryButton: .default(Text("Record sound")) {
                                isRecording = true
                                showingSheet.toggle()
                            },
                            secondaryButton: .default(Text("Go to survey")) {
                                showingSheet.toggle()
                            }
                    )
                }
    }
}

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonView(currentRegion: .constant(MKCoordinateRegion()))
    }
}

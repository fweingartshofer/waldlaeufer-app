//
//  AddButtonView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 29.12.22.
//
//

import SwiftUI

struct AddButtonView: View {
    @State private var showingSheet = false
    @State private var showingAlert = false

    @State private var isRecording = false

    @ObservedObject private var microphoneMonitor = MicrophoneViewModel(numberOfSamples: SoundRecorderView.numberOfSamples)

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
                            SoundRecorderView(microphoneMonitor: microphoneMonitor, isRecording: $isRecording)
                                    .presentationDetents([.medium])
                        } else {
                            AddLocationDataView(db: microphoneMonitor.decibel)
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
        AddButtonView()
    }
}

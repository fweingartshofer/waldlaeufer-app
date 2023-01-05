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
    @State private var timeRemaining = 10
    @State private var timer: Timer?

    @ObservedObject private var microphoneMonitor = MicrophoneMonitor(numberOfSamples: 20)

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
                        NavigationView {
                            VStack {
                                SoundVisualizerView(mic: microphoneMonitor)
                                Text("\(timeRemaining) seconds remaining")
                                Text(String(format: "Max Db: %.2f", microphoneMonitor.decibel))
                            }.navigationBarTitle(Text("Recording sound"), displayMode: .inline)
                        }
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
                                startTimer()
                            },
                            secondaryButton: .default(Text("Go to survey")) {
                                showingSheet = !showingSheet
                            }
                    )
                }
    }

    func startTimer() {
        microphoneMonitor.startRecording()
        isRecording = true
        showingSheet = true
        timeRemaining = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timeRemaining = 0
                self.isRecording = false
                timer.invalidate()
                microphoneMonitor.stopRecording()
            }
        }
    }
}

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonView()
    }
}

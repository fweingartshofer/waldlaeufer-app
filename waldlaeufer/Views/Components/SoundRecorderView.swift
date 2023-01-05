//
//  SoundRecorderView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 05.01.23.
//
//

import SwiftUI

struct SoundRecorderView: View {

    public static let numberOfSamples = 20

    @ObservedObject public var microphoneMonitor: MicrophoneMonitor

    @State private var timeRemaining = 10
    @State private var timer: Timer?

    @Binding public var isRecording: Bool

    var body: some View {
        NavigationView {
            VStack {
                Text("\(timeRemaining) seconds remaining")
                Text(String(format: "Max Db: %.2f", microphoneMonitor.decibel))
            }
                    .navigationBarTitle(Text("Recording sound"), displayMode: .inline)
        }.onAppear(perform: {
                    startTimer()
                })
        HStack(spacing: 4) {
            ForEach(microphoneMonitor.windowedSamples.suffix(SoundRecorderView.numberOfSamples), id: \.self) {
                (level: Float) in
                SoundbarView(value: normalizeSoundLevel(level: level), numberOfSamples: SoundRecorderView.numberOfSamples)
            }
        }
                .frame(height: 180)
    }

    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        return CGFloat(level * (200 / 25)) // scaled to max at 200 (our height of our bar)
    }

    func startTimer() {
        microphoneMonitor.startRecording()
        isRecording = true
        timeRemaining = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timeRemaining = 0
                timer.invalidate()
                microphoneMonitor.stopRecording()
                isRecording = false
            }
        }
    }
}

struct SoundRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        SoundRecorderView(microphoneMonitor: MicrophoneMonitor(numberOfSamples: 10)
                , isRecording: .constant(true))
    }
}

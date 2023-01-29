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

    @State private var timeRemaining = 10
    @State private var timer: Timer?

    @Binding public var isRecording: Bool

    @StateObject private var viewModel: SoundRecorderViewModel = SoundRecorderViewModel(numberOfSamples: SoundRecorderView.numberOfSamples)

    @Binding var db: Float

    var body: some View {
        NavigationView {
            VStack {
                Text("\(timeRemaining)s")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                Text(String(format: "%.2f db", viewModel.db))
                        .font(.system(size: 20))
            }
                    .navigationBarTitle(Text("Recording sound"), displayMode: .inline)
        }.onAppear(perform: {
                    startTimer()
                })
        HStack(spacing: 4) {
            ForEach(viewModel.windowedSamples, id: \.self) {
                (level: Float) in
                SoundbarView(value: normalizeSoundLevel(level: level), numberOfSamples: SoundRecorderView.numberOfSamples)
            }
        }
                .frame(height: 160)
    }

    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        return CGFloat(level * (200 / 25)) // scaled to max at 200 (our height of our bar)
    }

    func startTimer() {
        viewModel.startRecording()
        isRecording = true
        timeRemaining = 10

        print("start timer")

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("timer running \(timeRemaining)")
            if timeRemaining > 0 {
                print("dB \(viewModel.db)")
                self.timeRemaining -= 1
            } else {
                self.timeRemaining = 0
                timer.invalidate()
                viewModel.stopRecording()
                isRecording = false
                db = viewModel.db

            }
        }
    }
}

struct SoundRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        SoundRecorderView(isRecording: .constant(true), db: .constant(0))
    }
}

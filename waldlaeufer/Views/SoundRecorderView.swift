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

    @StateObject private var viewModel: SoundRecorderViewModel
            = SoundRecorderViewModel(numberOfSamples: SoundRecorderView.numberOfSamples)

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
        }
                .onAppear(perform: {
                    startTimer()
                })
        HStack(spacing: 4) {
            ForEach(viewModel.windowedSamples.map {
                SoundbarItem(value: $0)
            }) {
                (item: SoundbarItem) in
                SoundbarView(item: item, numberOfSamples: SoundRecorderView.numberOfSamples)
            }
        }
                .frame(height: 160)
    }

    func startTimer() {
        viewModel.startRecording()
        isRecording = true
        timeRemaining = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
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

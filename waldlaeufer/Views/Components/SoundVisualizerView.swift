//
//  SoundVisualizerView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 05.01.23.
//
//

import SwiftUI

struct SoundVisualizerView: View {

    private static let numberOfSamples = 20

    @ObservedObject public var mic: MicrophoneMonitor

    var body: some View {
        HStack(spacing: 4) {
            ForEach(mic.windowedSamples.suffix(SoundVisualizerView.numberOfSamples), id: \.self) { (level: Float) in
                SoundbarView(value: normalizeSoundLevel(level: level), numberOfSamples: SoundVisualizerView.numberOfSamples)
            }
        }
                .frame(height: 180)
    }

    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        return CGFloat(level * (200 / 25)) // scaled to max at 200 (our height of our bar)
    }
}

struct SoundVisualizerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundVisualizerView(mic: MicrophoneMonitor(numberOfSamples: 10))
    }
}

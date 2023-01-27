//
// Created by Andreas Wenzelhuemer on 04.01.23.
//

import Foundation
import AVFoundation

final class SoundRecorderViewModel: ObservableObject {

    private var audioRecorder: AVAudioRecorder
    private var timer: Timer?

    private var sampleIndex: Int = 0
    private let numberOfSamples: Int
    private let minValue: Float = -160.0

    @Published public var windowedSamples: [Float]
    @Published public var db: Float = 0

    private var allSamples: [Float] = []

    init(numberOfSamples: Int) {
        allSamples = []
        windowedSamples = [Float](repeating: minValue, count: numberOfSamples)
        self.numberOfSamples = numberOfSamples

        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }

        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func startRecording() {
        allSamples = []

        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.audioRecorder.updateMeters()
            let power = self.audioRecorder.averagePower(forChannel: 0)
            self.windowedSamples[self.sampleIndex] = power
            self.sampleIndex = (self.sampleIndex + 1) % self.numberOfSamples
            self.allSamples.append(self.powerToDecibels(power: self.audioRecorder.peakPower(forChannel: 0)))
            self.db = self.calculateDecibel()
        })
    }

    public func stopRecording() {
        timer?.invalidate()
        audioRecorder.stop()
        windowedSamples = [Float](repeating: minValue, count: numberOfSamples)
        sampleIndex = 0
    }

    private func calculateDecibel() -> Float {
        allSamples.max() ?? 0
    }

    private func powerToDecibels(power: Float) -> Float {
        db = 20 * log10(-20 / power)
        print(db)
        return db
    }

    deinit {
        stopRecording()
    }
}
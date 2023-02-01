//
// Created by Andreas Wenzelhuemer on 04.01.23.
//

import Foundation
import AVFoundation

final class SoundRecorderViewModel: ObservableObject {

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    private var sampleIndex: Int = 0
    private let numberOfSamples: Int
    private let minValue: Float = -160.0

    @Published public var windowedSamples: [Float]
    @Published public var db: Float = 0

    private var allSamples: [Float] = []

    private var recorderSettings: [String: Any] =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
            ]

    init(numberOfSamples: Int) {
        allSamples = []
        windowedSamples = [Float](repeating: minValue, count: numberOfSamples)
        self.numberOfSamples = numberOfSamples
        audioRecorder = createAudioRecorder()
    }

    private func createAudioRecorder() -> AVAudioRecorder {
        let audioSession = createAudioSession()
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        do {
            let recorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            return recorder
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func createAudioSession() -> AVAudioSession {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    print("Error requesting authorization for audio session.")
                }
            }
        }
        return audioSession
    }

    public func startRecording() {
        allSamples = []
        if let audioRecorder {
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                audioRecorder.updateMeters()
                let power = audioRecorder.averagePower(forChannel: 0)
                self.windowedSamples[self.sampleIndex] = power
                self.sampleIndex = (self.sampleIndex + 1) % self.numberOfSamples
                self.allSamples.append(self.dbfsToDecibel(power: audioRecorder.peakPower(forChannel: 0)))
                self.db = self.calculateDecibel()
            })
        }
    }

    public func stopRecording() {
        timer?.invalidate()
        audioRecorder?.stop()
        windowedSamples = [Float](repeating: minValue, count: numberOfSamples)
        sampleIndex = 0
    }

    private func calculateDecibel() -> Float {
        allSamples.max() ?? 0
    }

    private func dbfsToDecibel(power: Float) -> Float {
        let referenceValue: Float = 18e-1
        let minDbfs: Float = -120.0
        db = ((power + abs(minDbfs)) / referenceValue)
        return db
    }

    deinit {
        stopRecording()
    }
}

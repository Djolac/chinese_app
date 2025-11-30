//
//  AudioRecorder.swift
//  ChineseVoiceTranslator
//
//  Created by Djordje Petkovic on 25. 11. 2025..
//
import AVFoundation

class AudioRecorder: NSObject {
    private var recorder: AVAudioRecorder?
    private var audioURL: URL?

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)

        let tempDir = FileManager.default.temporaryDirectory
        audioURL = tempDir.appendingPathComponent("recording.m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try? AVAudioRecorder(url: audioURL!, settings: settings)
        recorder?.record()
    }

    func stopRecording() -> URL? {
        recorder?.stop()
        return audioURL
    }
}

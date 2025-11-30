import SwiftUI

struct ContentView: View {
    @State private var isRecording = false
    @State private var result: TranslationResult?
    @State private var errorMessage: String?

    private let recorder = AudioRecorder()
    private let api = APIClient()

    var body: some View {
        VStack(spacing: 20) {
            Text("Chinese Voice Translator")
                .font(.title2)
                .padding()

            Button(isRecording ? "Stop Recording" : "Start Recording") {
                if isRecording {
                    if let url = recorder.stopRecording() {
                        isRecording = false
                        api.uploadAudio(url: url) { res, err in
                            DispatchQueue.main.async {
                                if let err = err { errorMessage = err }
                                result = res
                            }
                        }
                    }
                } else {
                    errorMessage = nil
                    result = nil
                    recorder.startRecording()
                    isRecording = true
                }
            }
            .padding()
            .background(isRecording ? Color.red : Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())

            if let result = result {
                VStack(alignment: .leading, spacing: 12) {
                    Text("🗣 Chinese (transcription)")
                        .font(.headline)
                    Text(result.chinese_transcription)

                    if let improved = result.improved_chinese {
                        Text("✍️ Improved Chinese:")
                            .font(.headline)
                        Text(improved)
                    }

                    if let english = result.english_translation {
                        Text("🇺🇸 English translation:")
                            .font(.headline)
                        Text(english)
                    }
                }
                .padding()
            }

            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
    }
}


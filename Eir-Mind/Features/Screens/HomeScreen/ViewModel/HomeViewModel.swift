//
//  HomeViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import Foundation
import AVFoundation
import Speech

final class HomeViewModel: ObservableObject {
    
    // MARK: - Init()
    init() {
        callSetupAudioMethods()
        transcribeAudioApiCall()
    }
    // MARK: - Body
    // MARK: - Private Variables and Properties
    @Published var transcribedText: String = ""
    var audioRecorder: AVAudioRecorder?
    let audioEngine = AVAudioEngine()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: -

    // MARK: - Helpers
    func getAgents(completion: @escaping ((Bool) -> Void)) {
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.diagnosisAgentEndPoint,
                                                method: .get,
                                                completion: { (result: Result<GenericResponse<[DiagnosisAgentResponse]>, Error>) in
            switch result {
            case .success(let response):
                printer.print("✅ Get Agents Response: \(response)")
                completion(true)
            case .failure(let error):
                printer.print("❌ Failed to Get Agents: \(error.localizedDescription)", severity: .high)
                completion(false)
            }
        })
    }
    
    private func callSetupAudioMethods() {
        do {
            try setupRecorder()
            try setupAudioSession()
        } catch let error {
            printer.print("HomeViewModel ==> Failed to Call Setup Audio Methods: \(error.localizedDescription)")
        }
    }
    
    func requestRecordPermission() {
        AVAudioApplication.requestRecordPermission { isGranted in
            guard isGranted else { return }
            printer.print("HomeViewModel ==> AudioSession Authorization Granted")
        }
        
        SFSpeechRecognizer.requestAuthorization { status in
            if status != .authorized {
                print("HomeViewModel ==> Speech permission not granted.")
            }
            printer.print("HomeViewModel ==> SFSpeechRecognizer Authorization Granted")
        }
    }
    
    func startRecording() {
        /// whenever i tap twice time on startRecording button the app is crash we should need to fix this 
        audioRecorder?.record()
        do {
            try startSpeechRecognition()
        } catch let error {
            printer.print("HomeViewModel ==> Failed to Start Speech Recognition: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        stopSpeechRecognition()
    }
    
    
    func setupRecorder() throws {
        let recordingSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC, AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("recording.m4a")
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: recordingSettings)
        audioRecorder?.prepareToRecord()
    }
    
    func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
    }
    
    
    private func startSpeechRecognition() throws {
        printer.print("HomeViewModel ==> Starting speech recognition...")
        transcribedText = ""
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                }
            }
            
            if let error = error {
                printer.print("❌ HomeViewModel ==> Speech recognition error: \(error.localizedDescription)", severity: .high)
                self.stopSpeechRecognition()
            }
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    private func stopSpeechRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        printer.print("HomeViewModel ==> 🛑 Speech recognition stopped.", severity: .high)
    }
    
    func transcribeAudioApiCall() {
        guard let fileURL = audioRecorder?.url else {
            printer.print("❌ HomeViewModel ==> No audio file available.", severity: .high)
            return
        }
        
        guard let audioData = try? Data(contentsOf: fileURL) else {
            printer.print("❌ HomeViewModel ==> Failed to read audio file data.", severity: .high)
            return
        }
        
        let formData: [MultipartFormData] = [
            MultipartFormData(name: "transcribe_audio", fileName: "recording.m4a", mimeType: "audio/m4a", data: audioData),
            MultipartFormData(name: "language", value: userData?.user?.preferences?.language ?? ""),
            MultipartFormData(name: "model", value: userData?.user?.preferences?.model ?? ""),
            MultipartFormData(name: "temperature", value: "\(String(describing: userData?.user?.transcription_settings?.temperature))")
        ]
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.transcribeEndPoint,
                                                method: .post,
                                                formData: formData,
                                                token: userData?.token) { (result: Result<GenericResponse<TranscriptionResponse>, Error>) in
            switch result {
            case .success(let response):
                MAIN_THREAD.async {
                    self.transcribedText = response.data?.text ?? ""
                }
            case .failure(let error):
                printer.print("❌ HomeViewModel ==> API call failed: \(error.localizedDescription)", severity: .high)
            }
        }
    }

    
    

    
    
    
    
    
}

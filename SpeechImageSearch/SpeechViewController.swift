//
//  SpeechViewController.swift
//  SpeechImageSearch
//
//  Created by ChAe on 03/12/2018.
//  Copyright © 2018 ChAe. All rights reserved.
//

import UIKit
import KakaoNewtoneSpeech
import MediaPlayer

class SpeechViewController: UIViewController {
    var speechRecognizer: MTSpeechRecognizerClient?
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var speechEffectView: SpeechEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        MTSpeechRecognizer.isRecordingAvailable()
        speechEffectView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.descLabel.text = "버튼을 누르고 검색어를 말하세요."
        self.descLabel.textColor = UIColor.darkText
    }
}

extension SpeechViewController: SpeechEffectViewDelegate {
    func startSpeechEffect() -> Bool {
        guard self.speechRecognizer == nil, MTSpeechRecognizer.isRecordingAvailable() else {
            return false
        }
        
        var config: [AnyHashable: Any] = [SpeechRecognizerConfigKeyServiceType: SpeechRecognizerServiceTypeWeb]
        
        // AVAudio Session Option 설정
        config[SpeechRecognizerConfigKeyAudioType] = AVAudioSession.CategoryOptions.allowBluetooth.rawValue | AVAudioSession.CategoryOptions.mixWithOthers.rawValue
        config[SpeechRecognizerConfigKeyAudioCategory] =  AVAudioSession.Category.playAndRecord
        
        config[SpeechRecognizerConfigKeyAudioConfigOn] = false
        
        self.speechRecognizer = MTSpeechRecognizerClient(config: config)
        self.speechRecognizer?.delegate = self
        
        self.speechRecognizer?.startRecording()
        
        self.descLabel.text = "검색어를 말해 주세요."
        self.descLabel.textColor = UIColor.darkText
        
        return true
    }
    
    func cancelSpeechEffect() {
        if let speechRecognizer = self.speechRecognizer, speechRecognizer.checkIsWorking() {
            speechRecognizer.cancelRecording()
            self.speechRecognizer = nil
            
            self.descLabel.text = "버튼을 누르고 검색어를 말하세요."
            self.descLabel.textColor = UIColor.darkText
        }
    }
}

extension SpeechViewController: MTSpeechRecognizerDelegate {
    func onReady() {
        print(#function)
    }
    
    func onBeginningOfSpeech() {
        print(#function)
    }
    
    func onEndOfSpeech() {
        print(#function)
    }
    
    func onError(_ errorCode: MTSpeechRecognizerError, message: String!) {
        print(#function)
        self.speechRecognizer = nil
        speechEffectView.resetSpeechEffect(animated: true)
        
        self.descLabel.text = "인식하지 못했습니다."
        self.descLabel.textColor = UIColor.darkText
    }
    
    func onPartialResult(_ partialResult: String!) {
        print(#function, partialResult)
        
        if partialResult.isEmpty == false && partialResult != "..." {
            self.descLabel.text = partialResult
            self.descLabel.textColor = UIColor.darkGray
        }
    }
    
    func onResults(_ results: [Any]!, confidences: [Any]!, marked: Bool) {
        print(#function)
        self.speechRecognizer = nil
        speechEffectView.showFindEffect()
        NSLog("@@ end = ", results)
        
        if let keyword = results.first as? String {
            self.descLabel.text = keyword
            self.descLabel.textColor = #colorLiteral(red: 0.1215686275, green: 0.4078431373, blue: 0.937254902, alpha: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                if let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                    resultVC.keyword = keyword
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        }
    }
    
    func onAudioLevel(_ audioLevel: Float) {
        print(#function, audioLevel)
        speechEffectView.setSpeechLevel(audioLevel)
    }
    
    func onFinished() {
        print(#function)
    }
}


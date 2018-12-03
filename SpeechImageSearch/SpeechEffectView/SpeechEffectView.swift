//
//  SpeechEffectView.swift
//  SpeechImageSearch
//
//  Created by ChAe on 30/11/2018.
//  Copyright © 2018 ChAe. All rights reserved.
//

import UIKit

protocol SpeechEffectViewDelegate: class {
    func startSpeechEffect() -> Bool
    func cancelSpeechEffect()
}

class SpeechEffectView: UIView {
    weak var delegate: SpeechEffectViewDelegate?
    
    private let level1Layer = CAShapeLayer()
    private let level2Layer = CAShapeLayer()
    private let level3Layer = CAShapeLayer()
    private let speechButton: UIButton = UIButton()
    private var progressLayer: CAShapeLayer?
    
    @IBInspectable var idleBackgroundColor: UIColor = #colorLiteral(red: 0.8894147277, green: 0.8894355893, blue: 0.889424324, alpha: 1) {      // 기본 상태 버튼 배경 색상
        didSet {
            if self.speechButton.isSelected == false {
                self.speechButton.setBackgroundImage(idleBackgroundColor.image(), for: .normal)
            }
        }
    }
    
    @IBInspectable var speechBackgroundColor: UIColor = #colorLiteral(red: 0.1215686275, green: 0.4078431373, blue: 0.937254902, alpha: 1) {    // 말하는 상태 (녹음중) 버튼 배경색상
        didSet {
            if self.speechButton.isSelected == true {
                self.speechButton.setBackgroundImage(speechBackgroundColor.image(), for: .normal)
            }
        }
    }
    
    @IBInspectable var idleImage: UIImage? = UIImage(named: "ic_voice") {       // 기본 상태 버튼 이미지
        didSet {
            if self.speechButton.isSelected == false {
                self.speechButton.setImage(idleImage, for: .normal)
            }
        }
    }
    @IBInspectable var speechImage: UIImage? = UIImage(named: "ic_voice_on") {  // 말하는 상태 (녹음중) 버튼 이미지
        didSet {
            if self.speechButton.isSelected == true {
                self.speechButton.setImage(speechImage, for: .normal)
            }
        }
    }
    
    @IBInspectable var level1Color: UIColor = #colorLiteral(red: 0.5725490196, green: 0.7725490196, blue: 0.9725490196, alpha: 1) {     // 녹음 레벨1 색상
        didSet {
            self.level1Layer.fillColor = level1Color.cgColor
        }
    }
    
    @IBInspectable var level2Color: UIColor = #colorLiteral(red: 0.7843137255, green: 0.8823529412, blue: 0.9921568627, alpha: 1) {     // 녹음 레벨2 색상
        didSet {
            self.level2Layer.fillColor = level2Color.cgColor
        }
    }
    
    @IBInspectable var level3Color: UIColor = #colorLiteral(red: 0.8980392157, green: 0.9450980392, blue: 0.9960784314, alpha: 1) {     // 녹음 레벨3 색상
        didSet {
            self.level3Layer.fillColor = level3Color.cgColor
        }
    }
    
    @IBInspectable var findEffectColor: UIColor = #colorLiteral(red: 0.1215686275, green: 0.4078431373, blue: 0.937254902, alpha: 1)    // 검색 효과 색상
    
    @IBInspectable var isProgress: Bool = false {       // 프로그래스 표시 유무
        didSet {
            configProgress()
        }
    }
    
    @IBInspectable var progressColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) {     // 프로그래스 색상
        didSet {
            progressLayer?.strokeColor = progressColor.cgColor
        }
    }
    
    @IBInspectable var progressLineWidth: CGFloat = 3 { // 프로그래스 라인 두께
        didSet {
            updateProgress()
        }
    }
    
    @IBInspectable var progressDuration: Double = 5     // 프로그래스 동작 시간
    
    private static let buttonSizePercent: CGFloat = 0.25    // 버튼 사이즈 (퍼센트)
    private static let level3FixPercent: CGFloat = 0.73     // 말하기 3레벨 고정 사이즈 (퍼센트)
    private var level1DefaultPercent: CGFloat = {           // 말하기 1레벨 기존 사이즈 (퍼센트)
        return (SpeechEffectView.level3FixPercent - SpeechEffectView.buttonSizePercent) / 3.0 + SpeechEffectView.buttonSizePercent
    }()
    private var level2FixPercent: CGFloat = {               // 말하기 2레벨 고정 사이즈 (퍼센트)
        return ((SpeechEffectView.level3FixPercent - SpeechEffectView.buttonSizePercent) / 3.0) * 2.0 + SpeechEffectView.buttonSizePercent
    }()
    
    private var isLevel2Fixed: Bool = false                 // 말하기 레벨2 고정 유무
    private var isLevel3Fixed: Bool = false                 // 말하기 레벨3 고정 유무
    
    private var viewMinSize: CGFloat = 0                    // 현재 뷰 가로/세로 최소 사이즈 (사이즈 변경 감지용)
    
    private var progressWorkItem: DispatchWorkItem?         // 프로그래스 완료후 동작 내용
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewMinSize = min(self.bounds.size.width, self.bounds.size.height)
        
        configSpeechLevel()
        configSpeechButton()
        resetSpeechEffect(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        viewMinSize = min(self.bounds.size.width, self.bounds.size.height)
        
        configSpeechLevel()
        configSpeechButton()
        resetSpeechEffect(animated: false)
        /*
        print("레벨1", level1DefaultPercent)
        print("레벨2", level2FixPercent)
        print("레벨3", SpeechEffectView.level3FixPercent)
        */
    }
    
    override func layoutSubviews() {
        let viewMinSize = min(self.bounds.size.width, self.bounds.size.height)
        if self.viewMinSize != viewMinSize {
            updateSpeechLevel()
            updateSpeechButton()
            updateProgress()
            self.viewMinSize = viewMinSize
        }
    }
    
    // MARK: - Speech Level Methods
    // 말하기 레벨 크기/위치 변경
    private func updateSpeechLevel() {
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: min(self.bounds.size.width, self.bounds.size.height) / 2.0,
                                        startAngle: 0,
                                        endAngle: 2 * .pi,
                                        clockwise: true)
        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.width / 2.0)
        
        level3Layer.path = circularPath.cgPath
        level2Layer.path = circularPath.cgPath
        level1Layer.path = circularPath.cgPath
        
        level3Layer.position = center
        level2Layer.position = center
        level1Layer.position = center
    }
    
    // 말하기 레벨 구성
    private func configSpeechLevel() {
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: min(self.bounds.size.width, self.bounds.size.height) / 2.0,
                                        startAngle: 0,
                                        endAngle: 2 * .pi,
                                        clockwise: true)
        
        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.width / 2.0)
        level3Layer.path = circularPath.cgPath
        level3Layer.fillColor = level3Color.cgColor
        level3Layer.position = center
        layer.addSublayer(level3Layer)

        level2Layer.path = circularPath.cgPath
        level2Layer.fillColor = level2Color.cgColor
        level2Layer.position = center
        layer.addSublayer(level2Layer)

        level1Layer.path = circularPath.cgPath
        level1Layer.fillColor = level1Color.cgColor
        level1Layer.position = center
        layer.addSublayer(level1Layer)
    }
    
    
    // MARK: - Progress Methods
    // 프로그래스 초기화
    private func resetProgress() {
        progressLayer?.removeAllAnimations()
        progressLayer?.strokeEnd = 0
    }
    
    // 프로그래스 사이즈 및 라인두께 변경
    private func updateProgress() {
        let buttonSize = self.bounds.size.width * SpeechEffectView.buttonSizePercent - progressLineWidth
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: buttonSize / 2.0,
                                        startAngle: -.pi / 2,
                                        endAngle: .pi * 2 - .pi / 2,
                                        clockwise: true)
        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.width / 2.0)
        
        progressLayer?.path = circularPath.cgPath
        progressLayer?.position = center
        progressLayer?.lineWidth = progressLineWidth
    }
    
    // 프로그래스 생성 및 기본 설정
    private func configProgress() {
        if let _ = self.progressLayer {
            resetProgress()
            return
        }
        
        let buttonSize = self.bounds.size.width * SpeechEffectView.buttonSizePercent - progressLineWidth
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: buttonSize / 2.0,
                                        startAngle: -.pi / 2,
                                        endAngle: .pi * 2 - .pi / 2,
                                        clockwise: true)
        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.width / 2.0)
        progressLayer = CAShapeLayer()
        progressLayer?.path = circularPath.cgPath
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.lineWidth = progressLineWidth
        progressLayer?.strokeColor = progressColor.cgColor
        progressLayer?.position = center
        progressLayer?.strokeEnd = 0.0
        layer.addSublayer(progressLayer!)
    }
    
    
    // MARK: - Speech Button Methods
    // 말하기 동작 버튼 사이즈 변경
    private func updateSpeechButton() {
        let buttonSize = self.bounds.size.width * SpeechEffectView.buttonSizePercent
        let radius = buttonSize / 2.0
        speechButton.layer.cornerRadius = radius
     
        // find width/height constraint
        let sizeConstraints = speechButton.constraints.filter { ($0.firstAttribute == .width || $0.firstAttribute == .height) && $0.relation == .equal }
        for constraint in sizeConstraints {
            speechButton.removeConstraint(constraint)
        }
        speechButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        speechButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
    }
    
    // 말하기 버튼 기본 설정
    private func configSpeechButton() {
        speechButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonSize = self.bounds.size.width * SpeechEffectView.buttonSizePercent
        let radius = buttonSize / 2.0
        speechButton.layer.cornerRadius = radius
        speechButton.layer.masksToBounds = true
        
        speechButton.setBackgroundImage(idleBackgroundColor.image(), for: .normal)
        speechButton.setImage(idleImage, for: .normal)
        addSubview(speechButton)
        
        speechButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        speechButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        speechButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        speechButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        speechButton.addTarget(self, action: #selector(speechButtonAction(button:)), for: .touchUpInside)
    }
    
    // 버튼 초기화
    private func resetSpeechButton() {
        speechButton.isSelected = false
        speechButton.setBackgroundImage(idleBackgroundColor.image(), for: .normal)
        speechButton.setImage(idleImage, for: .normal)
    }
    
    // MARK: -
    // 말하기 레벨 & 버튼 초기화
    func resetSpeechEffect(animated: Bool) {
        isLevel2Fixed = false
        isLevel3Fixed = false
        
        level2Layer.removeAllAnimations()
        level3Layer.removeAllAnimations()
        
        // progress 초기화
        resetProgress()
        
        if animated == true {
            level1Layer.transform = CATransform3DMakeScale(level1DefaultPercent, level1DefaultPercent, 1)
            scaleAnimate(layer: level1Layer, duration: 0.3, fromValue: level1DefaultPercent, toValue: SpeechEffectView.buttonSizePercent)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.resetSpeechButton()
            }
        } else {
            level1Layer.transform = CATransform3DMakeScale(SpeechEffectView.buttonSizePercent, SpeechEffectView.buttonSizePercent, 1)
            resetSpeechButton()
        }
        
        level2Layer.transform = CATransform3DMakeScale(SpeechEffectView.buttonSizePercent, SpeechEffectView.buttonSizePercent, 1)
        level3Layer.transform = CATransform3DMakeScale(SpeechEffectView.buttonSizePercent, SpeechEffectView.buttonSizePercent, 1)
    }
    
    // 말하기 레벨 설정
    func setSpeechLevel(_ level: Float) {
        guard level >= 0 && level <= 1.0 else {
            return
        }
        
        let adjustScale: CGFloat = max(CGFloat(level) * ((SpeechEffectView.level3FixPercent + 0.02) - (level1DefaultPercent + SpeechEffectView.buttonSizePercent) / 2.0) + (level1DefaultPercent + SpeechEffectView.buttonSizePercent) / 2.0, level1DefaultPercent)
        if let _ = level1Layer.animation(forKey: "scale") {
            level1Layer.removeAllAnimations()
        }
        level1Layer.transform = CATransform3DMakeScale(adjustScale, adjustScale, 1)
        
        // transform.m11 = sx
        // transform.m22 = sy
        // transform.m33 = sz
        
        if isLevel3Fixed == true {
            level3Layer.removeAllAnimations()
            level3Layer.transform = CATransform3DMakeScale(SpeechEffectView.level3FixPercent, SpeechEffectView.level3FixPercent, 1)
        }
        
        if let level2Scale = level2Layer.presentation()?.transform.m11 {
            if level2Scale <= adjustScale {
                level2Layer.removeAllAnimations()
                level2Layer.transform = CATransform3DMakeScale(adjustScale, adjustScale, 1)
                
                if isLevel3Fixed == false {
                    level3Layer.removeAllAnimations()
                    level3Layer.transform = CATransform3DMakeScale(adjustScale, adjustScale, 1)
                }
            } else {
                // 애니 동작 유무 체크
                if level2Layer.animation(forKey: "scale") == nil {
                    if isLevel2Fixed == true {
                        scaleAnimate(layer: level2Layer,
                                     duration: 0.5,
                                     fromValue: level2Scale,
                                     toValue: level2FixPercent)
                        if isLevel3Fixed == false {
                            scaleAnimate(layer: level3Layer,
                                         duration: 0.5,
                                         fromValue: level2Scale,
                                         toValue: level2FixPercent)
                        }
                    } else {
                        scaleAnimate(layer: level2Layer,
                                     duration: 0.5,
                                     fromValue: level2Scale,
                                     toValue: level1DefaultPercent)
                        if isLevel3Fixed == false {
                            scaleAnimate(layer: level3Layer,
                                         duration: 0.5,
                                         fromValue: level2Scale,
                                         toValue: level1DefaultPercent)
                        }
                    }
                }
            }
        }
        
        if adjustScale >= SpeechEffectView.level3FixPercent {
            isLevel3Fixed = true
        }
        
        if adjustScale >= level2FixPercent {
            isLevel2Fixed = true
        }
    }
    
    // 찾기 (발견) 이펙트 애니메이션 동작
    func showFindEffect() {
        // 프로그래스 동작 취소
        progressWorkItem?.cancel()
        progressWorkItem = nil
        
        guard let level3Scale = level3Layer.presentation()?.transform.m11 else {
            self.resetSpeechEffect(animated: true)
            return
        }
        
        resetProgress()
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = self.bounds
        replicatorLayer.instanceCount = 45
        let angle = Float(Double.pi * 2.0) / 45
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        layer.addSublayer(replicatorLayer)
        
        
        let findLayer = CAShapeLayer()
        let layerWidth: CGFloat = 3.0
        let y = self.bounds.height / 2.0 - level3Scale * (self.bounds.height / 2.0) - 10 - (layerWidth * 2)
        let midX = self.bounds.midX - layerWidth / 2.0
        let startPoint = CGPoint(x: midX, y: y)
        let endPoint = CGPoint(x: midX, y: y + layerWidth * 2)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        findLayer.path = path.cgPath
        findLayer.lineWidth = layerWidth
        findLayer.lineCap = CAShapeLayerLineCap.round
        findLayer.strokeColor = findEffectColor.cgColor
        replicatorLayer.addSublayer(findLayer)
        
        
        // Animation
        scaleAnimate(layer: level3Layer,
                     duration: 0.2,
                     fromValue: level3Scale,
                     toValue: 0.8)
        
        let animation_position = CABasicAnimation(keyPath: "position.y")
        animation_position.byValue = -y + 5
        animation_position.duration = 0.2
        animation_position.isRemovedOnCompletion = false
        animation_position.fillMode = CAMediaTimingFillMode.forwards
        findLayer.add(animation_position, forKey: "y")
        
        let animation_stroke = CABasicAnimation(keyPath: "strokeEnd")
        animation_stroke.beginTime = CACurrentMediaTime() + 0.2
        animation_stroke.duration = 0.07
        animation_stroke.fromValue = 1
        animation_stroke.toValue = -1
        animation_stroke.isRemovedOnCompletion = false
        animation_stroke.fillMode = CAMediaTimingFillMode.forwards
        findLayer.add(animation_stroke, forKey: "stroke")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(270)) {
            self.resetSpeechEffect(animated: true)
            
            findLayer.removeFromSuperlayer()
            replicatorLayer.removeFromSuperlayer()
        }
    }
    
    // MARK: - Animation Methods
    // 크기 변경 애니메이션
    private func scaleAnimate(layer: CAShapeLayer, duration: CFTimeInterval, fromValue: CGFloat, toValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        layer.add(animation, forKey: "scale")
    }
    
    // 라인 그리기 애니메이션
    private func strokeEndAnimate(layer: CAShapeLayer?, duration: CFTimeInterval, fromValue: CGFloat, toValue: CGFloat) {
        if let layer = layer {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            
            layer.add(animation, forKey: "stroke")
        }
    }
}

extension SpeechEffectView {
    // 말하기 동작 버튼 액션
    @objc func speechButtonAction(button: UIButton) {
        let isSelected = button.isSelected
        
        // speechButton 이미지 설정이 모두 normal 상태에서 이루어지는 이유는 highlighted adjusts image 효과를 받기 위해 normal에서만 변경 처리
        // selected 상태 설정시 제대로 highlighted adjusts image 효과를 기대하기 어렵다.
        
        if isSelected == true {
            // 동작중 (중지 요청)
            progressWorkItem?.cancel()
            progressWorkItem = nil
            
            resetSpeechEffect(animated: true)
            delegate?.cancelSpeechEffect()
            
            resetProgress()
            
            button.isSelected = !isSelected
        } else {
            // 미동작 (동작 요청)
            if delegate?.startSpeechEffect() == true {
                setSpeechLevel(0)
                speechButton.setBackgroundImage(speechBackgroundColor.image(), for: .normal)
                speechButton.setImage(speechImage, for: .normal)

                if isProgress == true {
                    strokeEndAnimate(layer: progressLayer,
                                     duration: progressDuration,
                                     fromValue: 0,
                                     toValue: 1)
                    
                    progressWorkItem = DispatchWorkItem {
                        self.resetSpeechEffect(animated: true)
                        self.delegate?.cancelSpeechEffect()
                        
                        self.resetProgress()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(progressDuration * 1000)), execute: progressWorkItem!)
                }
                
                button.isSelected = !isSelected
            }
        }
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}

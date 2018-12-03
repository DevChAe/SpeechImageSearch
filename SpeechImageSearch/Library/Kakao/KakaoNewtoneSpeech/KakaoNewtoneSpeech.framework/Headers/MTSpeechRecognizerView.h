//
//  MTSpeechRecognizerView.h
//  DaumSpeech
//
//  Created by KimKyungmin on 13. 9. 25..
//  Copyright (c) 2013 Daum Communications Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSpeechRecognizerViewDelegate.h"

@interface MTSpeechRecognizerView : UIView

/**
 * 음성인식 OpenAPI에서 제공하는 view의 delegate.
 * view가 제공되는 음성인식 OpenAPI를 사용할 때 결과를 받을 수 있는 delegate.
 **/
@property (nonatomic, weak) id<MTSpeechRecognizerViewDelegate> delegate;

/**
 * 음성인식 OpenAPI에서 제공하는 view를 생성한다.
 * @param frame 음성인식 화면이 로드될 뷰의 크기를 설정한다.
 * @param config 음성인식에 사용될 설정값으로 NSDictionary key/value 형태로 설정한다.
 * {@link #MTSpeechRecognizerClient}의 설정 키들을 참고.
 **/
- (id)initWithFrame:(CGRect)frame withConfig:(NSDictionary *)config;

/**
 * 음성인식 화면을 표시한다.
 * {@link #initWithFrame:withConfig:}로 생성한 view를 로드하기 원하는 view에 addSubView 한 뒤,
 * show 메소드를 호출해줘야 음성인식 화면이 로드되고 실행된다.
 **/
- (void)show;

/**
 * 음성인식 화면을 숨긴다.
 * hide 메소드 내부에서 parent view로부터 음성인식 화면을 제거하고 있으므로,
 * 별도로 removeFromSuperview를 호출해 주지 않아도 된다.
 * 음성인식 닫기 버튼이나 화면 외의 여백을 터치했을 때 내부적으로 실행이 된다.
 **/
- (void)hide;

@end

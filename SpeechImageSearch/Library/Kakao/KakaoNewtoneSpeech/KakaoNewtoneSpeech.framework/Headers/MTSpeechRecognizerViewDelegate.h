//
//  MTSpeechRecognizerViewDelegate.h
//  KakaNewtoneSpeech
//
//  Created by KimKyungmin on 13. 10. 17..
//  Copyright (c) 2013 Kakao Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSpeechRecognizerClient.h"

/**
 * 음성인식 라이브러리에서 제공하는 view의 delegate
 **/
@protocol MTSpeechRecognizerViewDelegate <NSObject>
@optional

/**
 * 최종 인식 결과 callback.
 *
 * @param results 음성인식 최종 결과 리스트로 신뢰도 순으로 정렬되어있다.
 * 서제스트 화면에서 사용자가 원하는 결과를 선택한 경우, 선택된 결과가 가장 상위로 정렬된다.
 * @param confidences results의 각각의 결과에 대한 신뢰도 값 리스트.
 * resultTextList의 각 index에 해당하는 결과의 신뢰도 값으로 0번째 data가 음성과 가장 근접한 결과이며 나머지는 후보 결과이다.
 * @param marked results의 신뢰도가 가장 높은 0번째 data가 신뢰할 만한 값인지의 여부를 나타낸다.
 **/
- (void)onResults:(NSArray *)results confidences:(NSArray *)confidences marked:(BOOL)marked;

/**
 * 에러 상황 시 호출 된다.
 *
 * @param errorCode MTSpeechRecognizerError error 코드.
 * @param message 에러 메시지.
 **/
- (void)onError:(MTSpeechRecognizerError)errorCode message:(NSString *)message;

@end

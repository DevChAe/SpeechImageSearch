//
//  MTSpeechRecognizerClient.h
//  KakaNewtoneSpeech
//
//  Created by KimKyungmin on 13. 7. 18..
//  Copyright (c) 2013 Kakao Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @required
 * NSString
 * < deprecated > 발급받은 API Key의 설정 키 (apiKey)
 **/
extern NSString * const SpeechRecognizerConfigKeyApiKey;

/**
 * @optional
 * NSString
 * 음성인식 서비스 타입 설정 키 (serviceType)
 * {@link #SpeechRecognizerServiceTypeWeb}/{@link #SpeechRecognizerServiceTypeDictation}/{@link #SpeechRecognizerServiceTypeLocal}/{@link #SpeechRecognizerServiceTypeWord}
 * 로 구분하여 각각 웹검색/연속어/지도 선택한다.
 * default SpeechRecognizerServiceTypeWeb
 **/
extern NSString * const SpeechRecognizerConfigKeyServiceType;

/**
 * @optional
 * NSNumber (Integer)
 * 녹음에서 인식까지의 전체 타임아웃 설정 키 (globalTimeout)
 * default 30 sec
 **/
extern NSString * const SpeechRecognizerConfigKeyRecgTimeout;

/**
 * @optional
 * NSNumber (Integer)
 * 음성 입력 후에 서버에서 결과를 인식하기까지의 타임아웃 설정 키 (recgTimeout)
 * default 10 sec
 **/
extern NSString * const SpeechRecognizerConfigKeyServerRecgTimeout;

/**
 * @optional
 * NSNumber (BOOL)
 * 음성인식 라이브러리에서 제공하는 view의 결과화면에서 신뢰도가 낮을 때, 서제스트 화면을 보여줄지에 대한 설정 키 (suggestViewOn)
 * suggestViewOn YES일 때 서제스트 화면을 보여준다.
 * default YES
 **/
extern NSString * const SpeechRecognizerConfigKeyShowSuggestView;

/**
 * @optional
 * NSString
 * 앱에서 생성한 strings 파일의 이름 설정을 위한 설정 키 (customStirngs)
 * 음성인식 라이브러리 UI를 사용할 때, UI의 guide나 tip 문구들을 앱에서 생성한 strings로 대체할 수 있다.
 * default KakaoNewtoneSpeechResources.bundle의 SpeechRecognizerDefault.strings.
 **/
extern NSString * const SpeechRecognizerConfigKeyCustomStrings;

/**
 * @optional
 * NSString
 * pingpong Conf Path 을 정의하는 설정 키 (pingpongConfPath)
 **/
extern NSString * const SpeechRecognizerConfigKeyPingpongConfPath;

/**
 * @optional
 * NSString
 * pingpong Conf falg 을 정의하는 설정 키 (pingpongConfFlag)
 **/
extern NSString * const SpeechRecognizerConfigKeyPingpongConfFlag;

/**
 * @optional
 * NSString
 * 사용자 사전을 정의하는 설정 키 (userDictionary)
 * 이 값이 설정되면,인식결과가 사전에서만 결정된다. 구분자는 '\n'(newline).
 * 예) "수지\n태연\n현아"
 **/
extern NSString * const SpeechRecognizerConfigKeyUserDictionary;

/**
 * @optional
 * NSUInteger
 * 음성인식 라이브러리에서 사용하는 카카오 인증 설정
 * (구)다음 인증은 설정할 필요없고 카카오 인증을 사용할때 1 값으로 설정한다.
 * default 0
 **/
extern NSString * const SpeechRecognizerConfigKeyKakaoAuthType;

/**
 * @optional
 * NSUInteger
 * audio sesion Type 을 정의하는 설정 키 (audioType)
 **/
extern NSString * const SpeechRecognizerConfigKeyAudioType;

/**
 * @optional
 * NSString
 * audio sesion Category 을 정의하는 설정 키 (audioCategory)
 **/
extern NSString * const SpeechRecognizerConfigKeyAudioCategory;

/**
 * @optional
 * NSNumber (BOOL)
 * 음성인식 라이브러리안에서 AVAudioSession 설정을 적용 여부에 대한 설정 키 (avAudioSessionConfigOn)
 * NO일 때 AVAudioSession 설정을 하지 않는다.
 * default YES
 **/
extern NSString * const SpeechRecognizerConfigKeyAudioConfigOn;

/**
 * 음성인식 서비스 타입 검색어.
 **/
extern NSString * const SpeechRecognizerServiceTypeWeb;

/**
 * 음성인식 서비스 타입 연속어.
 **/
extern NSString * const SpeechRecognizerServiceTypeDictation;

/**
 * 음성인식 서비스 타입 지역명.
 **/
extern NSString * const SpeechRecognizerServiceTypeLocal;

/**
 * 음성인식 서비스 타입 고립어.
 **/
extern NSString * const SpeechRecognizerServiceTypeWord;

/**
 * 음성인식 서비스 타입 Wakeup.
 **/
extern NSString * const SpeechRecognizerServiceTypeWakeup;

/**
 * SpeechRecognizer error codes.
 **/
typedef NS_ENUM(NSInteger, MTSpeechRecognizerError) {
    /**
     * 초기화 실패.
     **/
	MTSpeechRecognizerErrorInitialize = 1,
    /**
     * 초기화 실패 (No microphone)
     **/
	MTSpeechRecognizerErrorNoMic,
    /**
     * Network 오류.
     **/
	MTSpeechRecognizerErrorNetwork,
    /**
     * Audio 오류.
     **/
	MTSpeechRecognizerErrorAudio,
    /**
     * 전체 인식 시간 timeout.
     **/
	MTSpeechRecognizerErrorGlobalTimeout,
    /**
     * 서버 인식 시간 timeout.
     **/
	MTSpeechRecognizerErrorRecognitionTimeout,
    /**
     * 음성 인식 실패.
     **/
	MTSpeechRecognizerErrorRecognition,
    /**
     * 음성 인식 인증 실패.
     **/
    MTSpeechRecognizerErrorAuthentication,
    /**
     * 음성 인식 요청 허용 횟수 초과.
     **/
    MTSpeechRecognizerServerAllowedRequestsExcess,
    /**
     * 서버 내부 오류.
     **/
    MTSpeechRecognizerServerError,
    /**
     * 음성서버에서 지원하지 않는 서비스 코드.
     **/
    MTSpeechRecognizerUnsupprtService,
    /**
     * 사용자사전이 꼭 필요한 서비스에서 사용자사전이 비어있는 오류.
     **/
    MTSpeechRecognizerUserDictEmpty,
    /**
     * 오디오 데이터 입력 대기 시간 초과 오류.
     **/
    MTSpeechRecognizerAudioDataWaitTimeout,
    /**
     * 더 이상 지원하지 않는 서비스 오류.
     **/
    MTSpeechRecognizerObsoleteService,
};

/**
 * SpeechRecgnizer Delegate.
 *
 **/
@protocol MTSpeechRecognizerDelegate <NSObject>
@required
/**
 * 초기화 과정이 끝났을 때 호출 된다.
 *
 **/
- (void)onReady;

/**
 * 녹음 시작 시 호출 된다.
 *
 **/
- (void)onBeginningOfSpeech;

/**
 * 음성 분석 단계로 상태가 변경 되었을 때 호출 된다.
 *
 **/
- (void)onEndOfSpeech;

/**
 * 에러 상황 시 호출 된다.
 *
 * @param errorCode MTSpeechRecognizerError error 코드.
 * @param message 에러 메시지.
 **/
- (void)onError:(MTSpeechRecognizerError)errorCode message:(NSString *)message;

/**
 * 인식 중 중간 결과가 있을 때 서버에서 전달 되는 중간 결과를 전달한다.
 * 여러번 호출될 수 있다.
 *
 * @param partialResult 중간 결과.
 **/
- (void)onPartialResult:(NSString *)partialResult;

/**
 * 최종 인식 결과 callback.
 *
 * @param results 음성인식 최종 결과 리스트로 신뢰도 순으로 정렬되어있다.
 * @param confidences results의 각각의 결과에 대한 신뢰도 값 리스트.
 * resultTextList의 각 index에 해당하는 결과의 신뢰도 값으로 0번째 data가 음성과 가장 근접한 결과이며 나머지는 후보 결과이다.
 * @param marked results의 신뢰도가 가장 높은 0번째 data가 신뢰할 만한 값인지의 여부를 나타낸다.
 **/
- (void)onResults:(NSArray *)results confidences:(NSArray *)confidences marked:(BOOL)marked;

/**
 * 녹음 중의 audio level 값을 넘겨 준다.
 *
 * @param audioLevel Normalized average dB level (0.0~1.0)
 **/
- (void)onAudioLevel:(float)audioLevel;

/**
 * 음성인식이 성공하여 결과를 전달하는 메소드 {@link #onResults:confidences:marked:}가 호출된 후 종료되었을 때 호출된다.
 * 이 시점을 기준으로 음성인식이 종료되었다고 판단하고,
 * 음성인식 재시도 등의 다른 메소드를 호출해주어야 한다.
 *
 **/
- (void)onFinished;

@end

/**
 * MTSpeechRecognizerClient interface
 * 음성인식 동작과 관련된 클래스.
 **/
@interface MTSpeechRecognizerClient : NSObject

/**
 * MTSpeechRecognizer Delegate.
 **/
@property (nonatomic, assign) id<MTSpeechRecognizerDelegate> delegate;

/**
 * 새로운 MTSpeechRecognizer client instance 를 생성한다.
 * 해당 instance 는 autorelease 되지 않으므로 메모리 관리는 caller 에서 한다.
 * @param config 음성인식 설정파일.
 **/
- (id)initWithConfig:(NSDictionary *)config;

/**
 * 음성인식 동작을 시작한다.
 *
 **/
- (void)startRecording;

/**
 * 음성인식 동작을 정지하고, 현재까지 입력된 음성을 인식한다.
 *
 **/
- (void)stopRecording;

/**
 * 음성인식 동작을 취소한다.
 *
 **/
- (void)cancelRecording;

/**
 * 음성검색 client 가 동작중인지 체크한다.
 *
 **/
- (BOOL)checkIsWorking;

@end

//
//  MTTextToSpeechClient.h
//  KakaNewtoneSpeech
//
//  Created by KimKyungmin on 2014. 6. 11..
//  Copyright (c) 2014 Kakao Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @required
 * NSString
 * 발급받은 API Key의 설정 키 (apiKey)
 **/
extern NSString * const TextToSpeechConfigKeyApiKey;

/**
 * @optional
 * NSNumber (float)
 * 음성합성 속도 설정 키 (SpeechSpeed)
 * 0.5 ~ 4.0으로 숫자가 커질수록 빨라진다.
 * default 1.0
 **/
extern NSString * const TextToSpeechConfigKeySpeechSpeed;

/**
 * @optional
 * NSString
 * 음성합성 서비스 모드 (serviceMode)
 * default #{@link NewtoneTalk_1}
 **/
extern NSString * const TextToSpeechConfigServiceMode;

/**
 * 음성합성 서비스모드 1.
 **/
extern NSString * const NewtoneTalk_1;

/**
 * 음성합성 서비스모드 2.
 **/
extern NSString * const NewtoneTalk_2;

/**
 * @optional
 * NSString
 * 음성합성 목소리 타입 설정 키 (voiceType)
 * default #{@link TextToSpeechVoiceTypeMan}
 **/
extern NSString * const TextToSpeechConfigKeyVoiceType;

/**
 * 음성합성 목소리 타입 남자.
 **/
extern NSString * const TextToSpeechVoiceTypeMan;

/**
 * 음성합성 목소리 타입 여자.
 **/
extern NSString * const TextToSpeechVoiceTypeWoman;


/**
 * 음성합성 목소리 타입 남자 대화체.
 **/
extern NSString * const TextToSpeechVoiceTypeManDialog;

/**
 * 음성합성 목소리 타입 여자 대화체.
 **/
extern NSString * const TextToSpeechVoiceTypeWomanDialog;

/**
 * @optional
 * NSUInteger
 * audio sesion Type 을 정의하는 설정 키 (audioType)
 **/
extern NSString * const TextToSpeechConfigKeyAudioType;

/**
 * @optional
 * NSString
 * audio sesion Category 을 정의하는 설정 키 (audioCategory)
 **/
extern NSString * const TextToSpeechConfigKeyAudioCategory;

/**
 * @optional
 * NSNumber (BOOL)
 * 음성합성 라이브러리안에서 AVAudioSession 설정을 적용 여부에 대한 설정 키 (avAudioSessionConfigOn)
 * NO일 때 AVAudioSession 설정을 하지 않는다.
 * default YES
 **/
extern NSString * const TextToSpeechConfigKeyAudioSessionConfigOn;


/**
 * TextToSpeechError error codes.
 **/
typedef NS_ENUM(NSInteger, MTTextToSpeechError) {
    /**
     * 알 수 없는 에러.
     **/
	MTTextToSpeechErrorUnknown = 1,
    /**
     * 초기화 실패.
     **/
	MTTextToSpeechErrorInitialize,
    /**
     * 초기화 실패 (No microphone)
     **/
	MTTextToSpeechErrorNoMic,
    /**
     * Network 오류.
     **/
	MTTextToSpeechErrorNetwork,
    /**
     * timeout.
     **/
	MTTextToSpeechErrorTimeout,
    /**
     * 음성합성 클라이언트 내부오류.
     **/
    MTTextToSpeechErrorClientInternal,
    /**
     * 음성합성 서버 내부오류.
     **/
    MTTextToSpeechErrorServerInternal,
    /**
     * 음성합성 서버 타임아웃.
     **/
    MTTextToSpeechErrorServerTimeout,
    /**
     * 음성합성 인증 실패.
     **/
    MTTextToSpeechErrorAuthentication,
    /**
     * 음성합성 텍스트 오류.
     **/
    MTTextToSpeechErrorSpeechTextBad,
    /**
     * 음성합성 최대 허용 길이 초과.
     **/
    MTTextToSpeechErrorSpeechTextExcess,
    /**
     * 음성합성 금칙어 오류.
     **/
    MTTextToSpeechErrorSpeechTextForbidden,
    /**
     * 음성합성 요청 허용 횟수 초과.
     **/
    MTTextToSpeechErrorAllowedRequestsExcess,
    /**
     * 음성합성 서비스 모드 아님.
     **/
    MTTextToSpeechErrorUnsupportService,
    /**
     * 더이상 지원하지 않는 서비스.
     **/
    MTTextToSpeechErrorObsoleteService,
};

/**
 * TextToSpeech Delegate.
 *
 **/
@protocol MTTextToSpeechDelegate <NSObject>
@required

/**
 * 음성합성 동작이 종료되었을 때 호출된다.
 **/
- (void) onFinished;

/**
 * 에러 상황 시 호출된다.
 *
 * @param errorCode MTTextToSpeechError errorCode
 * @param message 에러 메시지.
 **/
- (void) onError:(MTTextToSpeechError)errorCode message:(NSString *)message;

@end

/**
 * MTTextToSpeechClient interface
 * 음성합성 동작과 관련된 클래스.
 **/

@interface MTTextToSpeechClient : NSObject

/**
 * MTTextToSpeechDelegate Delegate.
 **/
@property (nonatomic, weak) id<MTTextToSpeechDelegate> delegate;

/**
 * 새로운 MTTextToSpeech client instance 를 생성한다.
 * 해당 instance 는 autorelease 되지 않으므로 메모리 관리는 caller 에서 한다.
 * @param config 음성합성 설정파일.
 **/
- (id)initWithConfig:(NSDictionary *)config;

/**
 * 음성합성 동작을 시작한다.
 *
 **/
- (void)play:(NSString *)targetText;

/**
 * 음성합성 동작을 정지한다.
 *
 **/
- (void)stop;


@end

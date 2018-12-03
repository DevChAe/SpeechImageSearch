# 음성 인식 이미지 검색 (iOS)
### 카카오 음성인식 (뉴톤) SDK와 카카오 Image API를 활용한 음성 인식 이미지 검색  
### 조건
- Swift
- iOS Deployment Target : 10.0
- [Kakao 이미지 검색 API](https://developers.kakao.com/docs/restapi/search#%EC%9D%B4%EB%AF%B8%EC%A7%80-%EA%B2%80%EC%83%89) 이용. (JSON 사용)
- Network : [Alamofire](https://github.com/Alamofire/Alamofire)
- Image Downloader : [Kingfisher](https://github.com/onevcat/Kingfisher)
- [Kakao 음성 (뉴톤) SDK](https://developers.kakao.com/docs/ios/speech) 이용
- 다음 앱 음성 검색 UI 벤치마킹
### 예제
- Kakao REST API 키 등록 필요 (NetworkManager.swift)
- KAKAO_APP_KEY 등록 필요 (Info.plist)
- Kakao 음성 (뉴톤) SDK는 시뮬레이터 아키텍쳐(i386, x86_64)는 포함되지 않아 기기 테스트 필요

# SpeechEffectView
![speecheffectview](https://user-images.githubusercontent.com/45442864/49369776-95010700-f735-11e8-9396-ae7a19f07afb.gif)
### 사용법
- 효과가 표현되고자 하는 크기로 뷰를 설정하고 SpeechEffectView Class 지정
- SpeechEffectViewDelegate 설정
- SpeechEffectView 내 버튼을 누르면 SpeechEffectViewDelegate의 startSpeechEffect() 함수 호출하여 Bool 리턴 받음 (true 시 동작)
- 동작후 SpeechEffectView 객체의 setSpeechLevel(_ level: Float) 함수 호출하여 level 값을 설정
- 원하는 결과를 수신받았으면 SpeechEffectView 객체의 showFindEffect() 함수를 호출하여 검색효과를 표시하고 동작을 자동 멈춤
- 동작후 시간 초과 및 버튼 재선택시 SpeechEffectViewDelegate의 cancelSpeechEffect() 함수가 호출

### 기본 설정
- `idleBackgroundColor` : 기본 상태 버튼 배경 색상
- `speechBackgroundColor` : 말하는 상태 (녹음중) 버튼 배경 색상
- `idleImage` : 기본 상태 버튼 이미지 (기본 "ic_voice" 이미지 로드)
- `speechImage` : 말하는 상태 (녹음중) 버튼 이미지 (기본 "ic_voice_on" 이미지 로드)
- `level1Color` : 녹음 레벨1 색상
- `level2Color` : 녹음 레벨2 색상
- `level3Color` : 녹음 레벨3 색상
- `findEffectColor` : 검색 효과 색상
- `isProgress` : 프로그래스 표시 유무 (기본 false)
- `progressColor` : 프로그래스 색상
- `progressLineWidth` : 프로그래스 라인 두께 (기본 3)
- `progressDuration` : 프로그래스 동작 시간 (기본 5.0초)


### Customizing 참고사항
- 내부 UI는 SpeechEffectView 뷰의 크기를 기준을 비율(퍼센트)로 계산되어 표현되기 때문에 비율 설정시 정확한 룰에 적용
- `buttonSizePercent` : 안쪽 버튼 사이즈(퍼센트) (기본 25%)
- `level3FixPercent` : 레벨3 고정 사이즈(퍼센트) (기본 73%)
- `level1DefaultPercent` : 레벨1 기본 사이즈 [ (레벨3 고정 사이즈 - 버튼 사이즈) / 3 + 버튼 사이즈 ]
- `level2FixPercent` : 레벨2 고정 사이즈 [ ((레벨3 고정 사이즈 - 버튼 사이즈) / 3) * 2  + 버튼 사이즈 ]
- 레벨1의 최대 사이즈는 level3FixPercent에 2%가 추가해서 75% (setSpeechLevel 함수내 adjustScale 연산시 0.02 더함)
- 버튼 이미지는 사용하는 뷰의 크기에 따라 적절히 맞춰서 등록

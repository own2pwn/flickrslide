Flickr Slide
===========


DEVELOPMENT ENVIRONMENT
-----------                                                                                                                                                               
- IDE TOOL : Xcode 8.3.3
- Language : Swift3
- OpenSources : Alamofire, Kinghfisher, SWXMLHash
- Deployment target : 9.0

PROJECT OVERVIEW           
-----------                                                                                                                                                    
- 플리커의 공개피드를 받아 이미지를 슬라이드 쇼 형식으로 보여주는 어플리케이션.
- 슬라이딩 타이머 값(1-10초)를 설정할 수 있다.
- Landscape와 Portrait를 지원한다.
- 아이패드에서 동작하는 Universial 어플리케이션.


PROJECT STRUCTURE                                                                                                                   
-----------                      
- SliderGroup :
  - ViewController - 메인 뷰 컨트롤러 (Initial view controller) 
  - SliderView - 슬라이더를 그리고 구성하는 파일 (View controller의 Extension)
  - Settingview - 설정 뷰(톱니바퀴 아이콘)를 그리고 구성하는 파일 (View controller의 Extension)

- Common :
  - RequestHelper - Request 행동을 모듈로 구성
  - DateHelper - Date관련 행동을 모듈로 구성
  - CustomButton - UIButton 커스터마이징. UI구성을 위해 만들었으며, 주로 네트워크 요청시 버튼을 클릭하면 UIActivityIndicator를 표기하기 위해 사용.

- Resources : 
  - Fonts
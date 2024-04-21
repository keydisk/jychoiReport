#  밀리의 서제 과제

## 아키텍쳐
### MVVM
## 사용 라이브러리 
### Alamofire, RxSwift, Combine, Snapkit
## 사용 언어
### Swift, Objective C (DetailNewsViewController에서만 사용)

## 폴더 구조
### Scens : 뷰들의 집합
- Scens/Main: 초기 뉴스를 표시하는 뷰가 있는 폴더
- Scens/Main/Subviews: 초기 뉴스셀을 표시하는 셀이 있는 폴더 
- Scens/DetailNews: 웹뷰 기반의 뉴스 상세를 표시하는 뷰가 있는 폴더
### ViewModels : 비지니스 로직을 담당하는 뷰 모델
### Common : 공통 모듈을 모아 놓은 폴더
- Common/UIKitLib : UIKit라이브러리모음
- Common/Foundation : 기본 자료형의 익스텐션을 모아 놓은 폴더
- Common/UIKitExtension : UIKit 익스텐션을 모아 놓은 폴더
### APIs : 통신관련 클래스가 있는 폴더
### Resources : 이미지 Asset이나, Storyboard가 존재하는 폴더

## 구현내용

### ViewController 진입시 setupUI를 통해 collectionView를 RxSwift이용해서 MVVM 지원을 위해 데이터 바인딩 진행
- setupView collectionView를 드로잉하고 Rx로 ViewModel에 존재하는 모델과 바인딩 
- dataBiding 뷰 모델의 데이터를 바인딩
- 회전과 관련해 세로모드일땐 1개의 컬럼만 표시, 가로모드일땐 3개의 컬럼 표시
- 한번이라도 진입했던 뉴스일경우 빨간색으로 타이틀을 표시
- 뉴스 상세로 이동하는 부분은 Combine 적용.
- 화면을 당기면 뉴스를 새로고침

### DetailNewsViewController(Objective C 버전). DetailNewsViewController(Swift 버전)
- WKWebView를 올려서 화면에 표시
- 처음 뉴스 제목을 타이틀바에 표시하고, 웹뷰 로딩이 완료되면 웹뷰의 타이틀을 타이틀바에 표시
 
### NewsViewModel 뉴스를 보여주고 뉴스 상세에 대한 이벤트 처리
- 뉴스를 가져오는 통신 결과를 Dictionary 직렬화를 통해서 Model로 변환
- 뉴스를 탭했을때 탭한 뉴스를 CoreData를 통해 로컬 디비에 저장 후 뉴스 상세로 이동하는 이벤트 발생

### UIImageViewExtension 이미지 로직과 관련된 부분 처리
- 이미지를 서버에서 가져오고, 가져온 데이터를 UserDefault에 저장하고, 동일한 URL로 요청을 하는 경우엔 기존에 저장된 이미지 데이터를 가져와서 바로 UIImageView에 표시

### APIClient Alamofire와 URLSession을 사용해서 뉴스 정보를 가져옴
### NewsAPI에서 Alamofire로 뉴스를 가져오는것과 URLSession을 통해 뉴스를 가져오는 모듈을 호출
### CommonParam 추후에 추가적으로 뉴스 가져오는 통신을 할때 공통 부분인 key값을 입력 시켜줌
### NewsApiUrls 뉴스 가져오기 URL을 enum 형태로 가지고 있음

## 테스트 항목
jyChoiReportTests 통신관련 정상 동작 유무와 뉴스 상세보기시 선택한 데이터가 정상적으로 로컬 디비에 저장되는지 저장해주는 모듈 테스트 (테스트 메소드 이름은 카멜 표기법으로 한글로 표기)

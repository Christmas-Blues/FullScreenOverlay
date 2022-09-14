# FullScreenOverlay

[![Build](https://github.com/riiid/FullScreenOverlay/actions/workflows/build.yml/badge.svg)](https://github.com/riiid/FullScreenOverlay/actions/workflows/build.yml)

풀스크린 크기가 아닌 뷰에서 풀스크린 SwiftUI 오버레이를 띄우는 획기적인 방법.

```swift
import SwiftUI
import FullScreenOverlay

content
    .fullScreenOverlay(presentationSpace: .named("RootView")) {
        overlayContent
    }
```

## 목차
- [동기](#동기)
- [사용](#사용)
    - [프레젠테이션 공간 설정하기](#프레젠테이션-공간-설정하기)
    - [오버레이 띄우기](#오버레이-띄우기)
    - [예제](#예제)
    - [텍스트 결합하기](#텍스트-결합하기)
- [요구 사항](#요구-사항)
- [설치](#설치)
    - [Swift Package Manager](#swift-package-manager)
    - [Xcode](#xcode)
- [기여하기](#기여하기)
- [라이선스](#라이선스)

## 동기

SwiftUI에서 [`ZStack`](https://developer.apple.com/documentation/swiftui/zstack)이나  [`overlay(alignment:content:)`](https://developer.apple.com/documentation/swiftui/view/overlay(alignment:content:)) 모디파이어를 사용해 화면 전체를 덮는 커스텀 바텀시트를 띄우려면, 화면과 동일한 크기를 갖는 최상위 뷰에서 오버레이를 띄워야 합니다. 다시 말해, 작은 크기의 컴포넌트 뷰에서는 화면 전체를 덮는 커스텀 바텀시트를 띄울 수 없습니다. iOS 14 이상 버전부터는 전체 화면 크기로 모달 뷰를 띄울 수 있는 [`fullScreenCover(isPresented:onDismiss:content:)`](https://developer.apple.com/documentation/swiftui/view/fullscreencover(ispresented:ondismiss:content:)) 모디파이어가 제공되지만, 이는 단순히 [`sheet(isPresented:onDismiss:content:)`](https://developer.apple.com/documentation/SwiftUI/view/sheet(isPresented:onDismiss:content:)) 모디파이어의 [`modalPresentationStyle`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621355-modalpresentationstyle)을 [`.fullScreen`](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/fullscreen)으로 고정한 것으로, `overlay(alignment:content:)` 모디파이어를 대신하여 화면 전체를 덮는 커스텀 바텀시트를 띄우기에는 부적절합니다.

**FullScreenOverlay는 하위 뷰에서 생성한 오버레이를 최상위 뷰가 대신 띄울 수 있도록 하는 방식을 사용하여, 작은 크기의 컴포넌트 뷰에 화면을 전체를 덮는 오버레이를 손쉽게 붙일 수 있도록 도와줍니다.**

## 사용

### 프레젠테이션 공간 설정하기

FullScreenOverlay를 사용하려면 먼저 오버레이를 띄울 프레젠테이션 공간을 설정해야 합니다. 오버레이가 띄워지길 원하는 뷰(예: 최상위 루트 뷰)에 `fullScreenOverlayPresentationSpace(_:)` 모디파이어를 사용하여 프레젠테이션 공간과 그 이름을 설정합니다.

```swift
RootView()
    .fullScreenOverlayPresentationSpace(.named("RootView"))
```

프레젠테이션 공간으로 사용하려는 뷰가 충분히 크지 않은 경우, [`frame(maxWidth:maxHeight:)`](https://developer.apple.com/documentation/swiftui/view/frame(minwidth:idealwidth:maxwidth:minheight:idealheight:maxheight:alignment:)) 모디파이어를 사용하여 뷰의 크기를 넓혀준 다음 모디파이어를 사용합니다.

```swift
FittingRootView()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .fullScreenOverlayPresentationSpace(.named("FittingRootView"))
```

프레젠테이션 공간은 여러 곳이 될 수 있습니다. [`NavigationView`](https://developer.apple.com/documentation/swiftui/navigationview)를 사용하는 경우, [`NavigationLink`](https://developer.apple.com/documentation/swiftui/navigationlink)의 `destination` 뷰에 별도의 프레젠테이션 공간을 설정하면, 해당 `destination` 뷰 내부에서만 오버레이를 띄울 수 있습니다.

```swift
NavigationView {
    NavigationLink(
        "Detail",
        destination: {
            DetailView()
                .fullScreenOverlayPresentationSpace(.named("DetailView"))
        }
    )
}
.fullScreenOverlayPresentationSpace(.named("NavigationView"))
```

`PresentationSpace.named(_:)`는 SwiftUI의 `CoordinateSpace.named(_:)`와 마찬가지로 `AnyHashable` 타입을 이름으로 받습니다. 따라서 `String`이 아니더라도 `Hashable`을 만족하는 타입이라면 어떤 것이든 이름이 될 수 있습니다.

```swift
extension RootView {
    struct PresentationSpaceName: Hashable {}
}

RootView()
    .fullScreenOverlayPresentationSpace(.named(RootView.PresentationSpaceName()))
```

### 오버레이 띄우기

프레젠테이션 공간을 설정했다면, FullScreenOverlay를 사용할 준비가 된 것입니다.

```swift
SomeView()
    .fullScreenOverlay(presentationSpace: .named("RootView")) {
        SomeOverlay()
    }
```

`overlay(alignment:content:)` 모디파이어와 마찬가지로, `content` 클로저에 하나 이상의 뷰가 들어있을 경우 내부적으로 `ZStack`을 사용하여 뷰를 정렬해 보여줍니다. `ZStack`의 `alignment` 옵션이 필요한 경우, `frame(maxWidth:maxHeight:alignment:)` 모디파이어를 사용할 수 있습니다.

```swift
SomeView()
    .fullScreenOverlay(presentationSpace: .named("RootView")) {
        BackgroundDim()
        BottomSheet().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
```

### 예제

아래는 FullScreenOverlay를 사용하여 간단한 바텀시트 프레젠테이션을 구현한 예제입니다.

https://github.com/riiid/FullScreenOverlay/blob/2b251c2d6da1fd7712ef0723e6d5b2110bbf5aeb/Sources/Previews/Previews.swift#L1-L63

https://user-images.githubusercontent.com/2215080/172043362-8e0c5d6d-712f-4773-863f-50687e961a86.mp4

## 요구 사항

- Swift 5.1+
- Xcode 11.0+
- iOS 13.0+
- Mac Catalyst 13.0+
- macOS 10.15+
- tvOS 13.0+
- watchOS 6.0+

## 설치

### Swift Package Manager

[`Package.swift`](https://developer.apple.com/documentation/swift_packages/package) 파일의 `dependencies`에 아래 라인을 추가합니다.

```swift
.package(url: "https://github.com/riiid/FullScreenOverlay.git", .upToNextMajor(from: "1.0.0"))
```

그 다음, `AttributedFont`를 타겟의 의존성으로 추가합니다.

```swift
.target(name: "MyTarget", dependencies: ["FullScreenOverlay"])
```

완성된 디스크립션은 아래와 같습니다.

```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/riiid/FullScreenOverlay.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(name: "MyTarget", dependencies: ["FullScreenOverlay"])
    ]
)
```

### Xcode

File > Swift Packages > Add Package Dependency를 선택한 다음, 아래의 URL을 입력합니다.

```
https://github.com/riiid/FullScreenOverlay.git
```

자세한 내용은 [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)을 참조하세요.

## 기여하기

저희는 모든 종류의 기여를 환영하며, 기여해 주시는 분들의 모든 의견을 존중합니다. 간단한 기능 추가, 버그 픽스, 오타 수정 등이라도 주저하지 말고 [이슈](https://github.com/riiid/FullScreenOverlay/issues)나 [PR](https://github.com/riiid/FullScreenOverlay/pulls)을 생성하여 의견을 제기해 주세요.

#### 메인테이너

- **김동규** ([**@stleamist**](https://github.com/stleamist))

#### 도움을 주신 분들

- **이건석** ([**@hxperl**](https://github.com/hxperl)): [`PreferenceKey`](https://developer.apple.com/documentation/swiftui/preferencekey)를 사용해 구현된 최초 버전에서 발생하던 스크롤뷰 이슈와, [`EnvironmentObject`](https://developer.apple.com/documentation/swiftui/environmentobject)를 사용해 구현된 두 번째 버전에서 발생하던 CPU 사용량 이슈를 발견해주셨습니다.

## 라이선스

FullScreenOverlay는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](/LICENSE)를 참조하세요.

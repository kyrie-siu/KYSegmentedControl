# KYSegmentedControl


`KYSegmentedControl` is beautiful, light, customizable replacement for `UISegmentedControl` written in Swift

## Preview

![Preview](/preview.gif)

## Requirements


- iOS 11.0+
- Xcode 11+

## Installation


### Swift Package Manager

```
dependencies: [
    .package(url: "https://https://github.com/kyrie-siu/KYSegmentedControl.git", .branch("master"))
]
```

### CocoaPods


**Coming Soon**

### Manually

It's sample, just **drag** `KYSegmentedControl.swift` into your project!

## Usage

---

```swift
let segmentedControl = KYSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 16, height: 44))
segmentedControl.setSegmentItems(["Years", "Months", "Days", "All Photos"])

self.view.addSubview(segmentedControl)

//Done!
```

## Appearance


`height`: the height of the segmented control

`defaultTextColor`: the text color of unhighlighted segment

`highlightTextColor`: the text color of highlighted segment

`backgroundColor`: the background color of the segmented control

`sliderColor`: the background color of the slider

`sliderMargin`: the text margin of the slider

`font`: the font of the unhighlighted segment label

`highlightFont`: the font of the highlighted segment label

`isSliderShadowHidden`: determine to show shadow of the slider

## Support Me!


- **Star** the repo ⭐⭐⭐

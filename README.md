# ZZAnitom

A lightweight, pure-Swift animation framework that delivers stunning animations even on lower-end devices.

一个轻量级、纯 Swift 编写的动画框架，能够在低端设备上也呈现出惊艳的动画效果。


> ZZAnitom is a complete rewrite of my previous animation framework, [Anitom](https://github.com/weirui-kong/Anitom), which was based on SwiftUI and may not be suitable for applications targeting lower iOS versions.  
> By migrating to UIKit, ZZAnitom offers greater compatibility and easier integration across multiple platforms.  
> The migration is expected to be completed by June 2025.

Unlike solutions that hook into system methods, **ZZAnitom** relies solely on standard UIKit transitions and animations to achieve smooth, performant animations and an excellent user experience.

**Note:** Some use cases may require [SnapKit](https://github.com/SnapKit/SnapKit) for layout support.

---

## Example Usage 
### `ZZAImageStackView`

Here's a simple example demonstrating how to use `ZZAImageStackView`:

<img src="./statics/ZZAImageStackView.gif" height="400">


```swift
let stackView = ZZAImageStackView()

override func viewDidLoad() {
    super.viewDidLoad()
    
    stackView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
    stackView.center = view.center
    stackView.imageSize = CGSize(width: 200, height: 300)
    stackView.delegate = self
    stackView.images = [
        UIImage(named: "zzais_1")!,
        UIImage(named: "zzais_2")!,
        UIImage(named: "zzais_3")!,
        UIImage(named: "zzais_4")!
    ]
    view.addSubview(stackView)
}

func imageStackView(_ stackView: ZZAImageStackView, didTapImageAt index: Int) {
    selectedIndexLabel.text = "Selected Index: \(index)"
}
```

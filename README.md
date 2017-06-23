
![](http://ww2.sinaimg.cn/large/006tNbRwgy1feolh3senkj30rs05kaac.jpg)

<p align="center">
    <a href="https://github.com/jingzhilehuakai/WJClipsButton">
        <img src="https://img.shields.io/cocoapods/l/WJClipsButton.svg?style=flat"/>
    </a>
    <a href="https://github.com/jingzhilehuakai/WJClipsButton">
        <img src="https://img.shields.io/cocoapods/p/WJClipsButton.svg?style=flat"/>
    </a>
    <a href="https://developer.apple.com/swift/">
    <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat"/>
    </a>
    <a href="https://gitter.im/WJClipsButton/Lobby?source=orgpage#">
        <img src="https://img.shields.io/gitter/room/nwjs/nw.js.svg"/>
    </a>
    <a href="http://cocoapods.org/pods/WJClipsButton">
        <img src="https://img.shields.io/cocoapods/v/WJClipsButton.svg?style=flat"/>
    </a>
</p>

## Effect

![](http://ww3.sinaimg.cn/large/006tNc79gy1fgv33jprgqg305t01pq5h.gif)

## Requirements 

- Swift 3.0
- iOS 8.0
- Xcode 8.0

## Installation 

WJClipsButton is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WJClipsButton"
```

## Usage 

### Code

#### Import 

```
import WJClipsButton
```

#### Init && Setup

```
let wjButton = WJClipsButton.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 50))
wjButton.center = self.view.center
wjButton.cornerRadius = 10
wjButton.setButtonColor(.blue, status: .normal)
wjButton.setButtonColor(.yellow, status: .highlighted)
wjButton.setButtonColor(.red, status: .selected)
wjButton.setButtonTitle("I gonna start ... en ?", for: .normal)
wjButton.setButtonTitle("Touching ... friction.", for: .highlighted)
wjButton.setButtonTitle("Locked, locked.", for: .selected)
self.view.addSubview(wjButton)
```

### Storyboard

Picture is truth 

@IBInspectable Supported

[](http://ww2.sinaimg.cn/large/006tKfTcgy1fgvn6r38qpj30ds0keq32.jpg)

### Delegate

```
// button tap action
func didTapClipsButton()
    
// button unlock action
func clipsButtonDidUnlock()
    
// button lock action
func clipsButtonDidLock()
```

## Author

jingzhilehuakai, wj_jingzhilehuakai@163.com

## License 

WJClipsButton is available under the MIT license. See the LICENSE file for more info.
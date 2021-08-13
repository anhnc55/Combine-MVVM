# Sample project with Combine + SwiftUI/UIKit and MVVM architecture

| UIKit | SwiftUI |
| ----- | ------- |
|![Simulator Screen Shot - iPhone 12 - 2021-07-11 at 21 13 44](https://user-images.githubusercontent.com/7624652/125202685-cc959f80-e29e-11eb-8ef6-6e0d07187de5.png) | ![Simulator Screen Shot - iPhone 12 - 2021-07-11 at 21 14 01](https://user-images.githubusercontent.com/7624652/125202688-d15a5380-e29e-11eb-8f31-f24f573bd608.png) |


This sample app consist includes basic concepts that are common use cases for using reactive programming, that is implemented with the MVVM pattern, heavy use of Combine with both UIKit and SwiftUI, which makes binding very easy.

![MVVMPattern](https://user-images.githubusercontent.com/7624652/125202722-1b433980-e29f-11eb-9cb0-5ee863461b8a.png)

## ViewModel

* ViewModel is the main point of MVVM application. The primary responsibility of the ViewModel is to provide data to the view, so that view can put that data on the screen.
* It also allows the user to interact with data and change the data.
* The other key responsibility of a ViewModel is to encapsulate the interaction logic for a view, but it does not mean that all of the logic of the application should go into ViewModel.
* It should be able to handle the appropriate sequencing of calls to make the right thing happen based on user or any changes on the view.
* ViewModel should also manage any navigation logic like deciding when it is time to navigate to a different view.
[Source](https://www.tutorialspoint.com/mvvm/mvvm_responsibilities.htm)

ViewModelType is a protocol performs pure transformation of a user Input to the Output:

```swift
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, _ cancelBag: CancelBag) -> Output
}
```

## Setup
* Xcode 12
* Swift 5

## TODO
* Add test
* Add Xcode Template for this Architecture

## Links
* [Clean Architecture with Combine](https://github.com/tuan188/CleanArchitecture)
* [Example of Clean Architecture of iOS app using RxSwift](https://github.com/sergdort/CleanArchitectureRxSwift)


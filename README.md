# Guess The Number
Guess the number is a simple number-guessing game for iOS

### Features:
- Game includes two rounds: in first round computer tries to guess user number in range 1...100, in second round they change their roles
- App consists of 4 screens
- Computer is guessing number by simple binary-search algorythm

### Screenshots:
| Start Screen | Round One First Screen | Round One Second Screen | Round Two Screen |
:---:|:---:|:---:|:---:|
![Simulator Screen Recording - iPhone 14 Pro - 2023-02-13 at 06 46 07](https://user-images.githubusercontent.com/90643294/218352991-d1c68e88-7476-46c3-b5c4-74a2d54a7ca2.gif) | ![Simulator Screen Recording - iPhone 14 Pro - 2023-02-13 at 06 46 36](https://user-images.githubusercontent.com/90643294/218353034-429d3339-68fa-417e-baea-b3cdea1e9817.gif) | ![Simulator Screen Recording - iPhone 14 Pro - 2023-02-13 at 06 47 10](https://user-images.githubusercontent.com/90643294/218353086-66f6ea7b-b2cc-4a99-b4b5-cb9d2122398e.gif) | ![Simulator Screen Recording - iPhone 14 Pro - 2023-02-13 at 06 48 19](https://user-images.githubusercontent.com/90643294/218353104-2e9c2b0a-caec-408f-9980-82d913127542.gif)





## Technologies stack:
- UIKit
- Snapkit
- MVP with Coordinator and Builder
- Unit testing

## Description:
- UI was build programmatically with Snapkit
- UI elements have animations
- Text fields include validation: number should contain only three digits and should be in range of 1...100
- App screens background was made with UIColor pattern which was drawn in UIGraphicsContext
- Used custom buttons and textFields
- Project includes Unit tests for Builder, Coordinator and Game engine itself
- For modularity and testability, the project implements dependency injection (DI)d based on protocols

# km-swift-ble

You can control your Keigan Motor via Bluetooth Low Energy using iOS devices.

## Basic
### Scan
```swift
KMBluetoothManager.sharedInstance.addObserver(self, forKeyPath:"motors", options: .new, context:nil)
KMBluetoothManager.sharedInstance.scan()
```
### Connect
```swift
let motor:KMMotor = KMBluetoothManager.sharedInstance.motors[0]
motor.connect() // Connect to Keigan Motor
```
### Action
```swift
motor.enable() // Power on
     .speed(rpm:10) // Set speed to 10 rpm
     .runForward() // Rotate forward
```

## Examples
### Move by 90 degree per 10 seconds
```swift
for i in 0 ..< 4 {
motor.move(byDegree:90)
     .wait(10000)
}
```

## Requirement

- Swift4
- iOS10+

## Installation

    $ git clone https://github.com/keigan-motor/km-swift-ble
   
***NOTE***
Carthage and CocoaPods will be supported in the future.

## Author

[@tkeigan](https://twitter.com/tkeigan)
Keigan Inc.

## License

[MIT](http://b4b4r07.mit-license.org)

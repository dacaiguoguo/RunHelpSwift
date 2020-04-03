## 一、启动
    xcodebuild test-without-building -xctestrun launch.xctestrun -destination 'platform=iOS,id=<devideuuid>'


## 二、终止
    xcodebuild test-without-building -xctestrun kill.xctestrun -destination 'platform=iOS,id=<devideuuid>'

## 三、判断如果不在前台或者没有启动 就启动
    xcodebuild test-without-building -xctestrun normal.xctestrun -destination 'platform=iOS,id=<devideuuid>'

## 四、说明
#### 1、关键在xctestrun 生成方式通过 build-for-testing 生成在..../Build/Products里
    -xctestrun kill.xctestrun 是个plist里面指定了启动参数 包含了 lv_kill
    -xctestrun launch.xctestrun 是个plist里面指定了启动参数 包含了 lv_launch
    id=<是设备UUID>

#### 2、plist里还指定了app路径
```
<key>DependentProductPaths</key>
<array>
    <string>__TESTROOT__/Debug-iphoneos/RunHelpSwift.app</string>
    <string>__TESTROOT__/Debug-iphoneos/RunHelpSwiftUITests-Runner.app/PlugIns/RunHelpSwiftUITests.xctest</string>
</array>
```

#### 3、实现代码
```
    func testExample() {
        let prinfo = ProcessInfo.init()
        // bundleId=abc.sample.com
        let bundleIdArgument = prinfo.arguments.filter{ $0.hasPrefix("bundleId")}.first!
        let bundleId = bundleIdArgument.suffix(bundleIdArgument.count - "bundleId=".count)
        print(bundleId)

        let app = XCUIApplication(bundleIdentifier: String(bundleId))

        let lvArgument = prinfo.arguments.filter{ $0.hasPrefix("lv_")}.first
        print(lvArgument ?? "no lvArgument")
        if let lvArguItem = lvArgument {
            if lvArguItem == "lv_kill"  {
                app.terminate()
                return
            }
            if lvArguItem == "lv_launch"  {
                app.launch()
                return
            }
        }

        switch app.state {
        case .runningBackground:
            app.activate();
        case .runningBackgroundSuspended:
            app.activate();
        case .unknown:
            app.activate();
        case .notRunning:
            app.launch();
        case .runningForeground:
            return
        @unknown default:
            return
        }
    }
```
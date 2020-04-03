//
//  RunHelpSwiftUITests.swift
//  RunHelpSwiftUITests
//
//  Created by yanguo sun on 2020/4/3.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

import XCTest

class RunHelpSwiftUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let prinfo = ProcessInfo.init()
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
}

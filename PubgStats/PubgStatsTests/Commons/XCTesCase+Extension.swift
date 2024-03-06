//
//  XCTesCase+Extension.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import PubgStats
import XCTest

extension XCTestCase {
    public func XCAssertDeallocation<Object: Coordinator>(given coordinator: () -> Object, timeout: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) {
        XCAssertDeallocation(given: coordinator, action: { $0.start() })
    }
    
    public func XCAssertDeallocation<ViewModel: SceneViewModel>(given viewModel: () -> ViewModel, timeout: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) {
        XCAssertDeallocation(given: viewModel, action: { $0.viewDidLoad() })
    }
    
    public func XCAssertDeallocation<ViewController: UIViewController>(given viewController: () -> ViewController, timeout: TimeInterval = 5.0, file: StaticString = #file, line: UInt = #line) {
        weak var weakReferenceViewController: UIViewController?
        let autoreleasepoolExpectation = expectation(description: "Autoreleasepool should train")
        autoreleasepool {
            let rootViewController = UIViewController()
            let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()

            rootViewController.present(ViewController(), animated: false) {
                weakReferenceViewController = rootViewController.presentedViewController
                XCTAssertNotNil(weakReferenceViewController)
                rootViewController.dismiss(animated: false) {
                    autoreleasepoolExpectation.fulfill()
                }
            }
        }
        wait(for: [autoreleasepoolExpectation], timeout: timeout)
        wait(for: weakReferenceViewController == nil, timeout: timeout, description: "The view controller should be deallocated since no strong reference points to it.", file: file, line: line)
    }
    
    public func XCAssertDeallocation<Object: AnyObject>(given object: () -> Object, action: (Object) -> Void, timeout: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) {
        weak var weakReferenceObject: Object?
        let autoreleasepoolExpectation = expectation(description: "Autoreleasepool should train")
        autoreleasepool {
            let object = object()
            action(object)
            weakReferenceObject = object
            XCTAssertNotNil(weakReferenceObject)
            autoreleasepoolExpectation.fulfill()
        }
        wait(for: [autoreleasepoolExpectation], timeout: timeout)
        wait(for: weakReferenceObject == nil, timeout: timeout, description: "The object \(String(describing: Object.self)) should be deallocated since no strong reference points to it.", file: file, line: line)
    }
    
    public func wait(for condition: @autoclosure @escaping () -> Bool, timeout: TimeInterval, description: String, file: StaticString = #file, line: UInt = #line) {
        let end = Date().addingTimeInterval(timeout)
        var value: Bool = false
        let clousure: () -> Void = {
            value = condition()
        }
        while !value && 0 < end.timeIntervalSinceNow {
            if RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 0.002)) {
                Thread.sleep(forTimeInterval: 0.002)
            }
            clousure()
            XCTAssertTrue(value, "Time out waiting for confition to be true: \(description)", file: file, line: line)
        }
    }
}

public protocol SceneViewModel: AnyObject {
    func viewDidLoad()
}

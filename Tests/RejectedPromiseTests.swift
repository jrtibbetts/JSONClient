//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import XCTest

class RejectedPromiseTests: XCTestCase {
    
    func testErrorInitializerThenIsAlwaysRejected() {
        let error = NSError(domain: "none", code: 0, userInfo: nil)
        let promise: RejectedPromise<NSObject> = RejectedPromise(error: error)
        promise.then {_ in
            XCTFail("This promise should have been rejected.")
        }
    }

}

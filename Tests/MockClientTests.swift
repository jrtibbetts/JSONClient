//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import Stylobate
import XCTest

class MockClientTests: XCTestCase {

    func testInitializerWithNoArgumentsUsesMainBundle() {
        let client = MockClient()
        XCTAssertEqual(client.bundle, Bundle.main)
        XCTAssertFalse(client.errorMode)
    }

    func testInitializerWithBundleInNonErrorMode() {
        let bundle = Bundle(for: type(of: self))
        let client = MockClient(bundle: bundle)
        XCTAssertEqual(client.bundle, bundle, "test bundle")
        XCTAssertFalse(client.errorMode)
    }

    func testInitializerWithErrorDomainIsInErrorModeUsesMainBundle() {
        let errorDomain = "this is an error domain"
        let client = MockClient(errorDomain: errorDomain)
        XCTAssertEqual(client.bundle, Bundle.main)
        XCTAssertTrue(client.errorMode)
    }

    func testInitializerWithErrorDomainAndBundleIsInErrorModeAndHasThatBundle() {
        let errorDomain = "this is an error domain"
        let bundle = Bundle(for: type(of: self))
        let client = MockClient(errorDomain: errorDomain, bundle: bundle)
        XCTAssertEqual(client.bundle, bundle)
        XCTAssertTrue(client.errorMode)
    }

    func testApplyInErrorModeWithNoErrorReturnsErrorWithCustomDomain() {
        let errorDomain = "this is an error domain"
        let client = MockClient(errorDomain: errorDomain)

        let exp = expectation(description: "error mode default error")

        Task {
            do {
                let _: String = try await client.apply(toJsonObjectIn: "SampleFoo")
                XCTFail("This should have thrown a default error.")
            } catch {
                XCTAssertTrue(error.localizedDescription.contains(errorDomain))
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testApplyInErrorModeWithCustomErrorReturnsThatError() {
        let errorDomain = "this is an error domain"
        let customError = NSError(domain: errorDomain, code: 0, userInfo: nil)
        let client = MockClient(errorDomain: "default error domain")

        let exp = expectation(description: "error mode default error")

        Task {
            do {
                let _: String = try await client.apply(toJsonObjectIn: "SampleFoo", error: customError)
                XCTFail("This should have thrown a default error.")
            } catch {
                XCTAssertEqual(error.localizedDescription, customError.localizedDescription)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testApplyWithMissingFileAndCustomErrorReturnsFileLoadingError() {
        let errorDomain = "this is an error domain"
        let customError = NSError(domain: errorDomain, code: 0, userInfo: nil)
        let client = MockClient()

        let exp = expectation(description: "error mode default error")

        Task {
            do {
                let _: String = try await client.apply(toJsonObjectIn: "SampleFoo", error: customError)
                XCTFail("This should have thrown a default error.")
            } catch {
                XCTAssertTrue(type(of: error) == JSONFileLoadingError.self)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
}

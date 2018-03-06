//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import PromiseKit
import XCTest

class JSONClientTests: XCTestCase {

    func testInitializerWithBaseUrlOk() {
        let baseUrl = URL(string: "https://www.knowyourmeme.com")
        let client = JSONClient(baseUrl: baseUrl)
        XCTAssertEqual(client.baseUrl, baseUrl)
    }

    func testInitializerWithNilBaseUrlOk() {
        let client = JSONClient(baseUrl: nil)
        XCTAssertNil(client.baseUrl)
    }

    func testGetWithNilBaseUrlAndAbsolutePathOk() {
        let client = JSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")

        let promise: Promise<DiscogsInfo> = client.get(path: "https://api.discogs.com")

        promise.then { (info) -> Void in
            XCTAssertEqual(info.api_version, "v2")
            XCTAssertEqual(info.documentation_url, URL(string: "http://www.discogs.com/developers/"))
            exp.fulfill()
            }.catch { (error) in
                XCTFail("Failed to get Discogs info: \(error.localizedDescription)")
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testGetWithNilBaseUrlAndRelativePathRejectsPromise() {
        let client = JSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")
        let path = "relative/path/that/does/not/exist"
        let promise: Promise<DiscogsInfo> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a relative path that can't be resolved!")
            }.catch { (error) in
                XCTAssertEqual(error.localizedDescription, "unsupported URL")
                exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithNilBaseUrlAndGarbagePathRejectsPromise() {
        let client = JSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")
        let path = "1(*#%(*DFSLDKU%(*@)"
        let promise: Promise<DiscogsInfo> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
            }.catch { (error) in
                guard let error = error as? JSONClient.JSONError else {
                    XCTFail("get() should have failed with a JSONClient.JSONError.invalidUrl error")
                    return
                }

                switch error {
                case .invalidUrl:
                    exp.fulfill()
                    break
                default:
                    XCTFail("get() should have failed with a JSONClient.JSONError.invalidUrl error")
                }
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithValidBaseUrlAndInvalidPathRejectsPromise() {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com")!)
        let exp = expectation(description: "Discogs info")
        let path = "1(*#%(*DFSLDKU%(*@)"
        let promise: Promise<DiscogsInfo> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
            }.catch { (error) in
                guard let error = error as? JSONClient.JSONError else {
                    XCTFail("get() should have failed with a JSONClient.JSONError.invalidUrl error")
                    return
                }

                switch error {
                case .invalidUrl:
                    exp.fulfill()
                    break
                default:
                    XCTFail("get() should have failed with a JSONClient.JSONError.invalidUrl error")
                }
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithValidBaseUrlAndPathButWrongTypeRejectsPromise() {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com")!)
        let exp = expectation(description: "Discogs info")
        let path = "/"
        let promise: Promise<String> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
            }.catch { (error) in
                guard let error = error as? JSONClient.JSONError else {
                    XCTFail("get() should have failed with a JSONClient.JSONError.invalidUrl error")
                    return
                }

                switch error {
                case .parseFailed:
                    exp.fulfill()
                    break
                default:
                    XCTFail("get() should have failed with a parseFailed error")
                }
        }

        wait(for: [exp], timeout: 500.0)
    }

    struct DiscogsInfo: Codable {
        var documentation_url: URL
        var hello: String
        var api_version: String
        var statistics: Stats

        struct Stats: Codable {
            var labels: Int
            var artists: Int
            var releases: Int
        }
    }

}

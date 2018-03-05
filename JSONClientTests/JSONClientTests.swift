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
            }.catch { error in
                XCTFail("Failed to get Discogs info: \(error.localizedDescription)")
        }

        wait(for: [exp], timeout: 5.0)
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

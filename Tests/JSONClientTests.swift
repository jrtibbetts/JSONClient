//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import XCTest

class JSONClientTests: XCTestCase {

    func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let client = JSONClient(baseUrl: baseUrl, jsonDecoder: jsonDecoder)

        return client
    }

    // MARK: init()

    func testInitializerWithBaseUrlOk() {
        let baseUrl = URL(string: "https://www.knowyourmeme.com")
        let client = validJSONClient(baseUrl: baseUrl)
        XCTAssertEqual(client.baseUrl, baseUrl)
    }

    func testInitializerWithNilBaseUrlOk() {
        let client = validJSONClient(baseUrl: nil)
        XCTAssertNil(client.baseUrl)
    }

    // MARK: get()

    func testGetWithNilBaseUrlAndAbsolutePathOk() async throws {
        let client = validJSONClient(baseUrl: nil)

        let info: DiscogsInfo = try await client.get(path: "https://api.discogs.com")
        XCTAssertEqual(info.apiVersion, "v2")
        XCTAssertEqual(info.documentationUrl, URL(string: "http://www.discogs.com/developers/"))
    }

    func testGetWithNilBaseUrlAndRelativePathFails() async throws {
        let client = validJSONClient(baseUrl: nil)
        let path = "relative/path/that/does/not/exist"
        let exp = expectation(description: "Discogs info")

        do {
            let _: DiscogsInfo = try await client.get(path: path)

            XCTFail("get() should have failed because it has a nil base URL and a relative path that can't be resolved!")
        } catch {
            XCTAssertEqual(error.localizedDescription, "unsupported URL")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithNilBaseUrlAndGarbagePathFails() async throws {
        let client = validJSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")
        let path = "1(*#%(*DFSLDKU%(*@)"

        do {
            let _: DiscogsInfo = try await client.get(path: path)
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
        } catch {
            XCTAssertTrue(error.localizedDescription.contains("unsupported URL"))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithValidBaseUrlAndInvalidPathFails() async throws {
        let client = validJSONClient(baseUrl: URL(string: "https://api.discogs.com")!)
        let path = "1(*#%(*DFSLDKU%(*@)"
        let exp = expectation(description: "Discogs info")

        do {
            let _: DiscogsInfo = try await client.get(path: path)
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
        } catch {
            XCTAssertTrue(error.localizedDescription.contains("unsupported URL"))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithValidBaseUrlAndPathButWrongTypeFails() async throws {
        let client = validJSONClient(baseUrl: URL(string: "https://api.discogs.com")!)
        let path = "/"
        let exp = expectation(description: "Discogs info")

        do {
            let _: String = try await client.get(path: path)
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
        } catch DecodingError.typeMismatch {
            exp.fulfill()
        } catch {
            XCTFail("get() should have failed with a DecodingError.typeMismatch")
        }

        wait(for: [exp], timeout: 5.0)
    }

    // MARK: request()

    func testRequestWithBaseUrlAndPathButNoHeadersOrParamsOk() throws {
        let client = validJSONClient(baseUrl: URL(string: "https://api.discogs.com"))
        let request = try client.request(forPath: "some/path")
        // For some reason, URLComponents always appends a "?", even if there's
        // no query. I can't find this in the documentation anywhere.
        XCTAssertEqual(request.url?.absoluteString, "https://api.discogs.com/some/path?")
        XCTAssertNil(request.allHTTPHeaderFields?.count)
    }

    func testRequestWithBaseUrlAndPathWithHeadersButNoParamsOk() throws {
        let client = validJSONClient(baseUrl: URL(string: "https://api.discogs.com"))
        let headers = ["header1": "foo", "header2": "bar"]
        let request = try client.request(forPath: "some/path", headers: headers)
        XCTAssertEqual(request.url?.absoluteString, "https://api.discogs.com/some/path?")
        XCTAssertEqual(request.allHTTPHeaderFields!.count, 2)
        XCTAssertEqual(request.allHTTPHeaderFields!["header1"], "foo")
        XCTAssertEqual(request.allHTTPHeaderFields!["header2"], "bar")
    }

    func testRequestWithBaseUrlAndPathWithHeadersAndParamsOk() throws {
        let client = validJSONClient(baseUrl: URL(string: "https://api.discogs.com"))
        let headers = ["header1": "foo", "header2": "bar"]
        let parameters = ["bar": "bar2", "foo": "foo1"]
        let request = try client.request(forPath: "some/path", headers: headers, parameters: parameters)
        XCTAssertNotNil(request.url)
        XCTAssertTrue(request.url!.absoluteString.contains("bar=bar2"))
        XCTAssertTrue(request.url!.absoluteString.contains("foo=foo1"))
        XCTAssertEqual(request.allHTTPHeaderFields!.count, 2)
        XCTAssertEqual(request.allHTTPHeaderFields!["header1"], "foo")
        XCTAssertEqual(request.allHTTPHeaderFields!["header2"], "bar")
    }

}

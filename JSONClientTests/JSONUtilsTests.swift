//  Copyright © 2017 nrith. All rights reserved.

@testable import JSONClient
import XCTest

class JSONUtilsTests: XCTestCase {

    func testJsonDataEncodeAndDecode() {
        let foo = Foo(foo: 99, bar: "Huzzah!")

        do {
            let fooData = try JSONUtils.jsonData(forObject: foo)
            let otherFoo: Foo = try JSONUtils.jsonObject(data: fooData)
            XCTAssertEqual(foo, otherFoo)
        } catch {
            XCTFail("Failed to encode or decode the Foo: \(error.localizedDescription)")
        }
    }

    func testUrlForUnknownFilenameThrows() {
        let fileName = "this file can't possibly exist"
        let fileType = "vogonPoetry"

        XCTAssertThrowsError(try JSONUtils.url(forFileNamed: fileName,
                                               ofType: fileType,
                                               inBundle: Bundle(for: type(of: self))))
    }

    func testJsonDataForLocalFile() {
        do {
            let foo: Foo = try JSONUtils.jsonObject(forFileNamed: "SampleFoo",
                                                    ofType: "json",
                                                    inBundle: Bundle(for: type(of: self)))
            XCTAssertEqual(foo.foo, 9)
            XCTAssertEqual(foo.bar, "ninety-nine")
        } catch {
            XCTFail("Failed to parse a Foo from the SampleFoo.json file.")
        }
    }

    struct Foo: Codable, Equatable {

        static func ==(lhs: Foo, rhs: Foo) -> Bool {
            return (lhs.foo == rhs.foo) && (lhs.bar == rhs.bar)
        }

        var foo: Int
        var bar: String?

    }

}

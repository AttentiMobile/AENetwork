/**
 *  https://github.com/tadija/AENetwork
 *  Copyright (c) Marko Tadić 2017-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import XCTest
@testable import AENetwork

class HTTPURLResponseTests: XCTestCase {

    static var allTests : [(String, (HTTPURLResponseTests) -> () throws -> Void)] {
        return [
            ("testCaseInsensitiveSearchOfHeaders", testCaseInsensitiveSearchOfHeaders)
        ]
    }

    // MARK: Tests

    func testCaseInsensitiveSearchOfHeaders() {
        let headers = [
            "x-custom-header" : "x-custom-value",
            "X-Another-Header" : "X-Another-Value"
        ]
        let response = HTTPURLResponse(url: "https://tadija.net", statusCode: 200,
                                       httpVersion: nil, headerFields: headers)!

        let message = "Should be able to find header with case insensitive search"
        XCTAssertEqual(response.headerValue(forKey: "X-Custom-Header") as! String, "x-custom-value", message)
        XCTAssertEqual(response.headerValue(forKey: "x-another-header") as! String, "X-Another-Value", message)
    }

}

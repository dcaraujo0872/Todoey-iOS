//
//  StringExtensionsTests.swift
//  TodoeyTests
//
//  Created by Christopher Araujo on 2020/08/19.
//  Copyright © 2020 Christopher Araujo. All rights reserved.
//

import XCTest

class StringExtensionsTests: XCTestCase {

    func testStringHasValue() {
        XCTAssertTrue("Hello".hasValue)
    }
    
    func testStringDoesNotHaveAValue() {
        XCTAssertFalse("".hasValue)
    }
}

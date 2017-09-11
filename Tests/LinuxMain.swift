#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    testCase(RouteTests.allTests)
])

#endif

//
//  LoginViewTests.swift
//  SourceryTestsTests
//
//  Created by Vladyslav Zavalykhatko on 16/06/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import XCTest
@testable import SourceryTests

class LoginViewTests: XCTestCase {
    var sut: LoginView!
    
    override func setUp() {
        super.setUp()

        guard let loginView = R.nib.loginView.firstView(owner: nil) else {
            fatalError("View doesn't exist")
        }
        sut = loginView
    }
    
    func test_outletsAttached_onLoading() {
        // Assert
        XCTAssertNotNil(sut.loginBtn)
        XCTAssertNotNil(sut.name)
        XCTAssertNotNil(sut.password)
    }
}

//
//  UsersController.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 18/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import Foundation
import PromiseKit

protocol UsersControllerProtocol {
    func get() -> Promise<[UserGeneralInfo]>
}

class UsersController: UsersControllerProtocol {
    let session: URLSessionProtocol

    // sourcery: injected_constructor
    init(session: URLSessionProtocol) {
        self.session = session
    }

    func get() -> Promise<[UserGeneralInfo]> {
        return session.get(url: URL(string: "https://api.github.com/users")!)
            .then { data -> Promise<[UserGeneralInfo]> in
                return try .value(JSONDecoder().decode([UserGeneralInfo].self, from: data))
            }
    }
}

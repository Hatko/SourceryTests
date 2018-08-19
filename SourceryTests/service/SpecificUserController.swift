//
//  SpecificUserController.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 19/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserDetailsControllerProtocol {
    func get(_ login: String) -> Promise<User>
}

class UserDetailsController: UserDetailsControllerProtocol {
    let session: URLSessionProtocol

    // sourcery: injected_constructor
    init(session: URLSessionProtocol) {
        self.session = session
    }

    func get(_ login: String) -> Promise<User> {
        return session.get(url: URL(string: "https://api.github.com/users/\(login)")!)
            .then { data -> Promise<User> in
                return try .value(JSONDecoder().decode(User.self, from: data))
            }
    }
}

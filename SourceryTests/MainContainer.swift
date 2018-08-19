//
//  MainContainer.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 18/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension Container {
    static var `default`: Container {
        let container = Container()
        container.registerViewControllers()
        container.registerServices()
        return container
    }

    private func registerViewControllers() {
        storyboardInitCompleted(UserListViewController.self, initCompleted: Container.defaultRegistration)
        storyboardInitCompleted(UserDetailsViewController.self) { _, _ in }
        storyboardInitCompleted(UINavigationController.self) { _, _ in }
    }

    private func registerServices() {
        register(URLSessionProtocol.self) { _ in
            return URLSession(configuration: .default)
        }

        register(UsersControllerProtocol.self, factory: Container.registerConstructor)
        register(UserDetailsControllerProtocol.self, factory: Container.registerConstructor)
    }
}

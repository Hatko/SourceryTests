//
//  UserListViewController.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 18/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import UIKit
import PromiseKit

class UserListViewController: UIViewController {
    // sourcery:begin: injected
    var usersController: UsersControllerProtocol!
    // sourcery:end
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.userTableViewCell)
        }
    }

    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = usersController
            .get()
            .done { users in
                self.users = users
                self.tableView.reloadData()
            }
    }
}

extension UserListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = R.reuseIdentifier.userTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) else {
            fatalError("Can't dequeue cell \(id)")
        }
        cell.fill(withSource: users[indexPath.row])
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {

}

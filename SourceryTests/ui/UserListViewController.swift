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
    var userDetailsControllerProtocol: UserDetailsControllerProtocol!
    // sourcery:end

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.userTableViewCell)
        }
    }

    var users = [UserGeneralInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        usersController
            .get()
            .done { users in
                self.users = users
                self.tableView.reloadData()
            }
            .catch { error in
                print(error)
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let segue = R.segue.userListViewController.userDetailsViewController(segue: segue) {
            guard let user = sender as? User else {
                fatalError("Unexpected")
            }
            segue.destination.user = user
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
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        userDetailsControllerProtocol
            .get(user.login)
            .done { user in
                self.performSegue(
                    withIdentifier: R.segue.userListViewController.userDetailsViewController,
                    sender: user
                )
            }
            .catch { error in
                print(error)
            }
    }
}

//
//  UserDetailsViewController.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 19/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import UIKit
import SnapKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var userCardContainer: UIView! {
        didSet {
            guard let userCardView = R.nib.userCardView.firstView(owner: nil) else {
                fatalError("Unexpected storyboard state")
            }
            self.userCardView = userCardView
            userCardView.translatesAutoresizingMaskIntoConstraints = false
            userCardContainer.addSubview(userCardView)
            userCardView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    weak var userCardView: UserCardView!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        userCardView.fill(withSource: user)
    }
}

//
//  UserCardView.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 19/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import UIKit
import WebKit

protocol UserCardViewSource {
    var photoUrl: URL { get }
    var name: String { get }
    var company: String? { get }
    var reposCount: Int { get }
    var followers: Int { get }
    var following: Int { get }
}

extension User: UserCardViewSource {
    var photoUrl: URL {
        return URL(string: avatar_url)!
    }
    var reposCount: Int {
        return public_repos
    }
}

class UserCardView: UIView {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    func fill(withSource source: UserCardViewSource) {
        webView.load(URLRequest(url: source.photoUrl))
        nameLabel.text = source.name
        companyLabel.text = source.company
        reposLabel.text = "Repos\n\(source.reposCount)"
        followersLabel.text = "Followers\n\(source.followers)"
        followingLabel.text = "Following\n\(source.following)"
    }
}

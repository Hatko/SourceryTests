//
//  UserTableViewCell.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 18/08/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import UIKit
import WebKit

protocol UserTableViewCellSource {
    var photoUrl: URL { get }
    var name: String { get }
}

extension UserGeneralInfo: UserTableViewCellSource {
    var photoUrl: URL {
        return URL(string: avatar_url)!
    }
    var name: String {
        return login
    }
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var label: UILabel!

    func fill(withSource source: UserTableViewCellSource) {
        webView.load(URLRequest(url: source.photoUrl))
        label.text = source.name
    }
}

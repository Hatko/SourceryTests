//
//  LoginView.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 16/06/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import UIKit

class LoginView: UIView {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        print(name.text!)
    }
}

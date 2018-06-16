//
//  ViewController.swift
//  SourceryTests
//
//  Created by Vladyslav Zavalykhatko on 16/06/2018.
//  Copyright © 2018 Vladyslav Zavalykhatko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let loginView = R.nib.loginView.firstView(owner: nil) else {
            fatalError("View doesn't exist")
        }
        
        view.addSubview(loginView)
        // ... or whatever you need to do with it
    }
}


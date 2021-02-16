//
//  AuthorizationViewController.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit

class AuthorizationViewController: UIViewController, Instantiatable {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signin() {
        self.dismiss(animated: true, completion: nil)
    }
}

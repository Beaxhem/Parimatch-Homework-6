//
//  UIResponder.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import UIKit

extension UIResponder {

    class var reuseIdentifier: String {
        String(describing: self)
    }
}

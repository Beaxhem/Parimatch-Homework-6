//
//  Storyboarded.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import UIKit

protocol Instantiatable {
    static func instantiate() -> Self?
}

extension Instantiatable where Self: UIViewController {
    static func instantiate() -> Self? {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        return storyboard.instantiateViewController(withIdentifier: className) as? Self
    }
}

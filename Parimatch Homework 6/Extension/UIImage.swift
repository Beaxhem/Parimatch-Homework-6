//
//  UIImage.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 19.02.2021.
//

import UIKit

extension UIImage {

    func resized(to preferredSize: CGSize) -> UIImage? {

        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: preferredSize)

        UIGraphicsBeginImageContext(preferredSize)
        self.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        return img
    }
}

//
//  ImageCollectionViewCell.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView?

    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
}

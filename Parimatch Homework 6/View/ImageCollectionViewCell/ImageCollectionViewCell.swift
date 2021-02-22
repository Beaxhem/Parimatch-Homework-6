//
//  ImageCollectionViewCell.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 18.02.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }

    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }

    override func prepareForReuse() {
        imageView?.image = nil
        titleLabel?.text = nil
    }
}

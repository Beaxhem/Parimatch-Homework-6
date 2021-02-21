//
//  FullScreenImageViewController.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 21.02.2021.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint?

    var imageData: Data?

    override func viewDidLoad() {
        if let imageData = imageData {
            imageView?.image = UIImage(data: imageData)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
}

extension FullScreenImageViewController {

    func updateMinZoomScaleForSize(_ size: CGSize) {

        guard let imageView = imageView, let scrollView = scrollView else {
            return
        }
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = minScale * 3
        scrollView.zoomScale = minScale
    }

    func updateConstraintsForSize(_ size: CGSize) {

        guard let imageView = imageView,
              let imageViewTopConstraint = imageViewTopConstraint,
              let imageViewBottomConstraint = imageViewBottomConstraint,
              let imageViewLeadingConstraint = imageViewLeadingConstraint,
              let imageViewTrailingConstraint = imageViewTrailingConstraint else {
            return
        }

        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenImageViewController: UIScrollViewDelegate {

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

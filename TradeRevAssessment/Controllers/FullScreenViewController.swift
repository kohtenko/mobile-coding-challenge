//
//  FullScreenViewController.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 22/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import Nuke

class FullScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var image: Image? {
        didSet {
            imageView?.hero.id = image?.id
            guard let image = image else { return }
            Nuke.loadImage(
                with: image.regularURL,
                options: ImageLoadingOptions(
                    placeholder: ImageCache.shared[ImageRequest(url: image.thumbURL)]
                ),
                into: imageView)

            scrollView?.zoomScale = 1
        }
    }
}

extension FullScreenViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

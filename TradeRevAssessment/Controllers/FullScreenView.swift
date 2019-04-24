//
//  FullScreenView.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import Nuke

class FullScreenView: UIImageView {

    var imageToDisplay: Image? {
        didSet {
            guard let imageToDisplay = imageToDisplay else { return }
            hero.id = imageToDisplay.id
            Nuke.loadImage(
                with: imageToDisplay.regularURL,
                options: ImageLoadingOptions(
                    placeholder: ImageCache.shared[ImageRequest(url: imageToDisplay.thumbURL)]
                ),
                into: self)
        }
    }

}

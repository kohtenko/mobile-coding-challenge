//
//  PhotoCollectionViewCell.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import Nuke

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!

    var image: Image? {
        didSet {
            guard let thumbURL = image?.thumbURL else {
                imageView.image = nil
                return
            }
            Nuke.loadImage(with: thumbURL, into: imageView)
        }
    }

}

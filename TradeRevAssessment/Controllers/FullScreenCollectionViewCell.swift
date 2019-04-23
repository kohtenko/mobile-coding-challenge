//
//  FullScreenCollectionViewCell.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit

class FullScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: FullScreenView!
}

extension FullScreenCollectionViewCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

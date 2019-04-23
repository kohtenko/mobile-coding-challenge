//
//  FullScreenViewController.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 22/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit

protocol TransitionDelegate: AnyObject {
    var currentIndex: Int { get set }
}

class FullScreenViewController: UIViewController, TransitionDelegate {
    var photos: [Image]?
    var currentIndex = 0
    var image: Image?
    weak var transitionDelegate: TransitionDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()

        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()

        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                    at: .centeredHorizontally,
                                    animated: false)
    }

    @IBAction func dismissPressed() {
        transitionDelegate?.currentIndex = Int(collectionView.contentOffset.x / collectionView.frame.width)
        dismiss(animated: true)
    }

}

extension FullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenImageCell", for: indexPath) as? FullScreenCollectionViewCell else {
            fatalError("No reusable cell")
        }
        guard let image = photos?[indexPath.row] else { return cell }

        cell.imageView.imageToDisplay = image
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

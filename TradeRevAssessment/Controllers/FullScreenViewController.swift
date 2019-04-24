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

class FullScreenViewController: UIViewController {
    var photos: [Image]?
    var startIndex = 0
    weak var transitionDelegate: TransitionDelegate?
    private var isFirstLayout = true
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageDescriptionLabel: UILabel!

    private var currentIndex: Int {
        return Int(collectionView.contentOffset.x / collectionView.frame.width)
    }

    private func setupCollectionView() {
        collectionView.reloadData()
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(row: startIndex, section: 0),
                                    at: .centeredHorizontally,
                                    animated: false)
        didEndScrolling()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            setupCollectionView()
        }
    }

    @IBAction func dismissPressed() {
        transitionDelegate?.currentIndex = currentIndex
        dismiss(animated: true)
    }

    @IBAction func tapGestureRecognized() {
        let hidden = topView.isHidden
        if hidden {
            topView.alpha = 0
            topView.isHidden = false
            bottomView.alpha = 0
            bottomView.isHidden = false
        }
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.topView.alpha = hidden ? 1 : 0
                        self.bottomView.alpha = hidden ? 1 : 0
        }) { (_) in
            self.topView.isHidden = !hidden
            self.bottomView.isHidden = !hidden
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let index = currentIndex
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionView.collectionViewLayout.invalidateLayout()
            let width: CGFloat
            if newCollection.verticalSizeClass == .regular {
                width = self.view.frame.width
            } else {
                width = self.view.frame.width - self.view.safeAreaInsets.right - self.view.safeAreaInsets.left
            }
            self.collectionView.contentOffset.x = width * CGFloat(index)
        }, completion: nil)
    }

}

extension FullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenImageCell",
                                                            for: indexPath) as? FullScreenCollectionViewCell else {
            fatalError("No reusable cell")
        }
        cell.image = photos?[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }

}

extension FullScreenViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndScrolling()
    }

    private func didEndScrolling() {
        imageDescriptionLabel.text = photos?[currentIndex].imageDescription
    }
}

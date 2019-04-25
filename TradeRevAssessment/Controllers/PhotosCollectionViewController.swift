//
//  ViewController.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 22/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import RxSwift
import Hero
import Nuke

class PhotosCollectionViewController: UIViewController, TransitionDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var currentIndex = 0
    private var photos = [Image]()
    private let model = PhotosCollectionViewModel()
    private var currentPage = 1
    private let disposeBag = DisposeBag()
    private let appSchedulers = AppSchedulers()
    private var isLoading = false
    private let preheater = ImagePreheater()
    private var isFirstLayoutAfterAppearance = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNextPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFirstLayoutAfterAppearance = true

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayoutAfterAppearance {
            isFirstLayoutAfterAppearance = false
            collectionView.reloadData()
            collectionView.setNeedsLayout()
            collectionView.layoutIfNeeded()
            if currentIndex < photos.count {
                collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                            at: .centeredVertically,
                                            animated: true)
            }
        }
    }

    func loadNextPage() {
        isLoading = true
        model.images(for: currentPage)
            .subscribeOn(appSchedulers.background)
            .observeOn(appSchedulers.main)
            .subscribe(onSuccess: { [weak self] (images) in
                self?.photos.append(contentsOf: images)
                self?.collectionView.reloadData()
                self?.isLoading = false
            }) { [weak self] (error) in
                print(error)
                self?.isLoading = false
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)

        currentPage += 1
    }

    private func urls(from indexPaths: [IndexPath]) -> [URL] {
        return indexPaths.compactMap({ (indexPath) -> URL in
            return photos[indexPath.row].thumbURL
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

}

extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("No reusable cell")
        }
        let image = photos[indexPath.row]
        cell.hero.id = image.id
        cell.image = image

        if indexPath.row == photos.count - 1 {
            loadNextPage()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FullScreen", sender: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        preheater.startPreheating(with: urls(from: indexPaths))
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        preheater.stopPreheating(with: urls(from: indexPaths))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3
        return CGSize(width: size, height: size)
    }
}

extension PhotosCollectionViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PageViewController,
            let index = sender as? Int {
            controller.photos = photos
            controller.startIndex = index
            controller.transitionDelegate = self
        }
    }

}

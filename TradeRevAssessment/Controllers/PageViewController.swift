//
//  PageViewController.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 24/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit

protocol TransitionDelegate: AnyObject {
    var currentIndex: Int { get set }
}

class PageViewController: UIPageViewController {
    var photos: [Image]?
    var startIndex = 0

    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var tapGestureRecogniser: UIGestureRecognizer!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    weak var transitionDelegate: TransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if let controller = controller(for: startIndex) {
            setViewControllers([controller],
                               direction: UIPageViewController.NavigationDirection.forward,
                               animated: false,
                               completion: nil)
        }
        setupViews()
    }

    private func setupViews() {
        imageDescriptionLabel.text = photos?[startIndex].imageDescription
        view.addGestureRecognizer(tapGestureRecogniser)

        view.addSubview(topView)
        view.addSubview(bottomView)

        topView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 0).isActive = true

        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0).isActive = true
    }

    @IBAction func dismissPressed() {
        guard let controller = viewControllers?.first,
            let index = index(for: controller) else {
                return
        }
        transitionDelegate?.currentIndex = index
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

    private func index(for controller: UIViewController) -> Int? {
        guard let controller = controller as? FullScreenViewController,
            let image = controller.image else {
                return nil
        }
        return photos?.firstIndex { $0.id == image.id }
    }

    private func controller(for index: Int) -> UIViewController? {
        guard let photos = photos, index >= 0, index < photos.count else { return nil }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenViewController") as? FullScreenViewController
        _ = controller?.view
        controller?.image = photos[index]
        return controller
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = index(for: viewController) else { return nil }
        return controller(for: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = index(for: viewController) else { return nil }
        return controller(for: index + 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
            let controller = viewControllers?.first,
            let index = index(for: controller),
            let image = photos?[index] else {
                return
        }

        imageDescriptionLabel.text = image.imageDescription
    }

}

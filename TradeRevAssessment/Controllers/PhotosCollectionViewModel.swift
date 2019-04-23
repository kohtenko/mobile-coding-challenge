//
//  PhotosCollectionViewModel.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import RxSwift

class PhotosCollectionViewModel {

    private let webService: WebService

    init(with webService: WebService = WebService()) {
        self.webService = webService
    }

    func images(for page: Int) -> Single<[Image]> {
        return  webService.request(PhotosEndpoint.photos(page: page))
    }

}

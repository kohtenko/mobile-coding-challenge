//
//  PhotosEndpoint.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit

private struct Constants {

    struct Path {
        static let photos = "photos"
    }

    struct Parameters {
        static let defaultPerPage = 30
        static let perPage = "per_page"
        static let page = "page"
    }

}

enum PhotosEndpoint: Endpoint {

    case photos(page: Int)

    func parameters() -> [WebParameter] {
        switch self {
        case .photos(let page):
            return [WebParameter(key: Constants.Parameters.page, value: "\(page)"),
                    WebParameter(key: Constants.Parameters.perPage, value: "\(Constants.Parameters.defaultPerPage)")]
        }
    }

    func path() -> String {
        return Constants.Path.photos
    }

}

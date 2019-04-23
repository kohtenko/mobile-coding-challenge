//
//  Image.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit

struct Image: Decodable {
    struct URLS: Decodable {
        let regular: URL
        let thumb: URL
    }

    let id: String
    var regularURL: URL { return urls.regular }
    var thumbURL: URL { return urls.thumb }
    private let urls: URLS

}

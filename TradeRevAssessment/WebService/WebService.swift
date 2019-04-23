//
//  WebService.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift

class WebService {

    struct Constants {
        static let acceptVersion = "Accept-Version"
        static let acceptVersionValue = "v1"
        static let authorization = "Authorization"
        static let authorizationValue = "Client-ID a2c7d24bc5ee3ba1c4157b3bcc61b5ca48a4d25ebbf54f9638429a627407836a"
    }

    private let sessionManager: SessionManager

    init(sessionManager: SessionManager = SessionManager.default) {
        self.sessionManager = sessionManager
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
        return data(from: endpoint)
            .mapResponseToDTO()
            .asSingle()
    }

    func data(from endpoint: Endpoint) -> Observable<Data> {
        return sessionManager
            .rx
            .request(endpoint.method(),
                     endpoint.urlString(),
                     headers: [Constants.acceptVersion: Constants.acceptVersionValue,
                               Constants.authorization: Constants.authorizationValue])
            .data()
    }

}

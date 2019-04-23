//
//  Endpoint.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import UIKit
import Alamofire

private let baseURL = URL(string: "https://api.unsplash.com/")!

protocol Endpoint {
    func method() -> HTTPMethod
    func urlString() -> String

    func parameters() -> [WebParameter]
    func path() -> String

}

extension Endpoint {

    func method() -> HTTPMethod {
        return .get
    }

    func urlString() -> String {
        return addQueryParameters(parameters(),
                                  to: baseURL.appendingPathComponent(path()).absoluteString)

    }

    private func addQueryParameters(_ parameters: [WebParameter]?, to url: String) -> String {
        var result = url

        if let parameters = parameters {
            var firstParameter = true

            for parameter in parameters {
                if firstParameter {
                    result.append("?")
                    firstParameter = false
                } else {
                    result.append("&")
                }
                guard let encodedKey = parameter.key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                    preconditionFailure("cannot encode the key")
                }
                guard let encodedValue = parameter.value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                    preconditionFailure("cannot encode the value")
                }
                result.append("\(encodedKey)=\(encodedValue)")
            }
        }
        return result
    }

}

struct WebParameter {
    let key: String
    let value: String
}

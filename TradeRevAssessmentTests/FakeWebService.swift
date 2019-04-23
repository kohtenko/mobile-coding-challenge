//
//  FakeWebService.swift
//  TradeRevAssessmentTests
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

@testable import TradeRevAssessment
import RxSwift

extension String: Error {}

class FakeWebService: WebService {

    var endpointCalled: Endpoint?
    var resultJSONString: String?

    override func data(from endpoint: Endpoint) -> Observable<Data> {
        endpointCalled = endpoint
        let data = resultJSONString?.data(using: String.Encoding.utf8) ?? Data()
        return Observable.just(data)
    }

}

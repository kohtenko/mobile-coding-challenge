//
//  ResponseHandler.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import RxSwift

extension ObservableType where E == Data {

    public func mapResponseToDTO<T: Decodable>() -> Observable<T> {
        return self.map({ (data) -> T in
            return try JSONDecoder().decode(T.self, from: data)
        })
    }

}

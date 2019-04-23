//
//  AppSchedulers.swift
//  TradeRevAssessment
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//
import RxSwift

struct AppSchedulers {

    let main: ImmediateSchedulerType
    let background: ImmediateSchedulerType

    init(main: ImmediateSchedulerType = MainScheduler.instance,
         background: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.main = main
        self.background = background
    }

}

//
//  PhotosCollectionViewModelTests.swift
//  TradeRevAssessmentTests
//
//  Created by Oleg Kokhtenko on 23/04/2019.
//  Copyright © 2019 Kohtenko. All rights reserved.
//

import XCTest
import RxBlocking
@testable import TradeRevAssessment

class PhotosCollectionViewModelTests: XCTestCase {

    private var model: PhotosCollectionViewModel!
    private var fakeWebService: FakeWebService!

    override func setUp() {
        super.setUp()
        fakeWebService = FakeWebService()
        model = PhotosCollectionViewModel(with: fakeWebService)
    }

    override func tearDown() {
        super.tearDown()
        model = nil
        fakeWebService = nil
    }

    func testPhotosRequestSuccess() {
        fakeWebService.resultJSONString = try! String(contentsOfFile: Bundle(for: self.classForCoder).path(forResource: "Photos_Success", ofType: "json")!)
        let result = try! model.images(for: 3).toBlocking().single()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "hGgd46qq3ww")
        XCTAssertEqual(result.first?.thumbURL.absoluteString, "https://images.unsplash.com/photo-1555999003-3f2bc447570e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjY4MDU4fQ")
        XCTAssertEqual(result.first?.regularURL.absoluteString, "https://images.unsplash.com/photo-1555999003-3f2bc447570e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjY4MDU4fQ")
        XCTAssertEqual(result.first?.imageDescription, "Follow me on instagram @mischievous_penguins or at least credit me if you post one of my images....and if you enjoy my images and feel generous, any donations will be graciously accepted.\r\nPayPal.me/CaseyHorner      \r\n\r\n")
    }

}

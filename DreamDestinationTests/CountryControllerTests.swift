//
//  DreamDestinationTests.swift
//  DreamDestinationTests
//
//  Created by kuroro on 07/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import XCTest
@testable import DreamDestination

class CountryControllerTests: XCTestCase {
    var countryController: CountryController!
    
    override func setUp() {
        super.setUp()
        countryController = CountryController()
    }

    func testGetCountryShouldFailedIfNoCountryNameOrInvalid() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        countryController.getCountry(countryName: "sdf") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let country):
                XCTAssertNil(country)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetCountryShouldSucceedIfCountryNameValid() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        countryController.getCountry(countryName: "Californie") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let country):
                XCTAssertNotNil(country)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetListShouldFailedIfInvalidDocumentName() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        countryController.getList(listOf: "fgd") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let list):
                XCTAssertNil(list)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}

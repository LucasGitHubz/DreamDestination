//
//  ImageController.swift
//  DreamDestinationTests
//
//  Created by kuroro on 27/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import XCTest
@testable import DreamDestination

class ImageControllerTests: XCTestCase {
    // ---------------------------------------------
    // MARK: Read me before running test !!
    // Sign In with the test account :
    // Email: test@gmail.com
    // Password: test1234@
    // ---------------------------------------------

    var imageController: ImageController!
    
    override func setUp() {
        super.setUp()
        imageController = ImageController()
    }

    // MARK: Uploading image tests
    func testUploadImageShouldSucceedIfInternetIsActive() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        let image = #imageLiteral(resourceName: "loginScreen")

        imageController.uploadImage(image, childReference: "images/homepage.png") { (success) in
            XCTAssertTrue(success)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }

    // MARK: Get Image tests
    func testGetImageShouldFailedIfWrongReference() {
        let expectation = XCTestExpectation(description: "wait for queue change.")

        imageController.getImage(childReference: "fgh") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let image):
                XCTAssertNil(image)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }

    func testGetImageShouldSucceedIfRightReference() {
        let expectation = XCTestExpectation(description: "wait for queue change.")

        imageController.getImage(childReference: "images/homepage.png") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let image):
                XCTAssertNotNil(image)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }

    func testGetAnImagesTabShouldFailedIfWrongReference() {
        let expectation = XCTestExpectation(description: "wait for queue change.")

        imageController.getAnImagesTab(childReference: "gh", arrayToFetch: ["test"], to: 5) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let tab):
                XCTAssertNil(tab)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }

    func testGatAnImagesTabShouldSucceedIfRightReference() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        let exempleArray = ["Californie", "Chine", "Espagne", "Floride", "France", "Italie"]

        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/", arrayToFetch: exempleArray, to: 6) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let tab):
                XCTAssertNotNil(tab)
                XCTAssertEqual(exempleArray.count, tab.count)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }
}

//
//  UserControllerTests.swift
//  DreamDestinationTests
//
//  Created by kuroro on 26/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import XCTest
@testable import DreamDestination

class UserControllerTests: XCTestCase {
    // ---------------------------------------------
    // MARK: Read me before running test !!
    // Sign In with the test account :
    // Email: test@gmail.com
    // Password: test1234@
    // ---------------------------------------------

    var userController: UserController!
    
    override func setUp() {
        super.setUp()
        userController = UserController()
    }

    // MARK: GetUser tests
    func testGetUserShouldFailedIfInvalidUserId() {
        userController.userId = "dfgh"
        let expectation = XCTestExpectation(description: "wait for queue change.")

        userController.getUser { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let user):
                XCTAssertNil(user)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetUserShouldSucceedIfValidUserId() {
        let expectation = XCTestExpectation(description: "wait for queue change.")

        userController.getUser { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let user):
                XCTAssertNotNil(user)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    // MARK: Authentification tests
    func testSignOutShouldSucceedIfInternetIsActive() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.signOut { (success) in
            XCTAssertTrue(success)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignInShouldFailedIfInvalidEmail() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.connexion(email: "azerty", password: "test") { (error)  in
            let invalidEmailMessage = "Email incorrect !"
            XCTAssertEqual(invalidEmailMessage, error!.errorDescription())

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignInShouldFailedIfInvalidPassword() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.connexion(email: "test@gmail.com", password: "test") { (error)  in
            let passwordInvalidMessage = "Mot de passe incorrect !"
            XCTAssertEqual(passwordInvalidMessage, error!.errorDescription())

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignInShouldFailedIfCoherentEmailAndPasswordButNoUserSignUpWithIt() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.connexion(email: "dsfgcr@gmail.com", password: "dfgh12345@") { (error) in
            let UserNotFoundMessage = "Aucun compte n'existe avec ces identifiants."
            XCTAssertEqual(UserNotFoundMessage, error!.errorDescription())

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignInShouldSucceedIfRightEmailAndPassword() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.connexion(email: "test@gmail.com", password: "test1234@") { (error) in
            XCTAssertNil(error)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignUpShouldFailedIfInvalidEmail() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.inscription(email: "sfg", password: "test1234@") { (result) in
            switch result {
            case .failure(let error):
                let invalidEmailMessage = "Email incorrect !"
                XCTAssertEqual(invalidEmailMessage, error.errorDescription())
            case .success(let result):
                XCTAssertNil(result)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignUpShouldFailedIfEmailAlreadyUsed() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.inscription(email: "test@gmail.com", password: "test1234fdgf@") { (result) in
            switch result {
            case .failure(let error):
                let emailAlreadyUsedMessage = "Cette email est déjà utilisé !"
                XCTAssertEqual(emailAlreadyUsedMessage, error.errorDescription())
            case .success(let result):
                XCTAssertNil(result)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testSignUpShouldSucceedIfRightInformations() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        // add "test" to the following email, to create a new user
        userController.inscription(email: "testtest@gmail.com", password: "test12345@") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let result):
                XCTAssertNotNil(result)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testResetPasswordShouldFailedIfWrongEmail() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.resetPassword(email: "fdg") { (success) in
            XCTAssertFalse(success)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testResetPasswordShouldSucceedIfRightEmail() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.resetPassword(email: "test@gmail.com") { (success) in
            XCTAssertTrue(success)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    // MARK: Database interactions
    func testAddNewUserToDatabaseShouldSucceedIfInternetIsActive() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.addNewUserToDB(lastName: "test1", firstName: "test2", uid: "nameOfDocument", email: "test1@gmail.com") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetSpecificDataShouldFailedIfWrongDocumentName() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.getSpecificData(collection: "users", document: "nameOdDocuments", field: "mail") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let emailData):
                XCTAssertNil(emailData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetSpecificDataShouldSucceedIfRightDocumentName() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.getSpecificData(collection: "users", document: "nameOfDocument", field: "mail") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let emailData):
                let email = "test1@gmail.com"
                XCTAssertEqual(email, emailData as? String ?? "")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testUpdateSpecificDataShouldFailedIfWrongDocumentName() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.updateSpecificData(collection: "users", document: "nameOdDocuments", field: "mail", newValue: "") { (success) in
            XCTAssertFalse(success)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testUpdateSpecificDataShouldSucceedIfRightInformations() {
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        userController.updateSpecificData(collection: "users", document: "nameOfDocument", field: "mail", newValue: "test2@gmail.com") { (success) in
            XCTAssertTrue(success)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}

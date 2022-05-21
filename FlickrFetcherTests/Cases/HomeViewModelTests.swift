//
//  HomeViewModelTests.swift
//  FlickrFetcherTests
//
//  Created by Mohsen Khosravinia on 5/21/22.
//

@testable import FlickrFetcher
import XCTest
import Combine

class HomeViewModelTests: XCTestCase {

    func testDataOnInstantiation_isNil() {
        let interactor = MockSuccessHomeInteractor()
        let sut = DefaultHomeViewModel(interactor: interactor)
        
        XCTAssertNil(sut.data)
    }
    
    func testDataCountAfterSuccessfulFetch() {
        let interactor = MockSuccessHomeInteractor()
        let sut = DefaultHomeViewModel(interactor: interactor)
        
        sut.fetchPhotos()
        
        XCTAssertEqual(sut.data?.items?.count, 5)
    }
    
    func testErrorAfterFailedFetch() {
        let interactor = MockFailHomeInteractor()
        let sut = DefaultHomeViewModel(interactor: interactor)
        
        let expectation = expectation(description: "error publisher")
        var expectedError: String = ""
        let cancellable = sut.errorPublisher
            .sink { message in
                expectedError = message
                expectation.fulfill()
            }
        
        sut.fetchPhotos()

        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        XCTAssertEqual(expectedError, "Something went wrong! Try again later.")
    }
}

private extension HomeViewModelTests {
    
    final class MockSuccessHomeInteractor: HomeInteractor {
        func fetchRecentPhotos(of page: Int, completion: @escaping (Result<FlickrModel, APIError>) -> Void) {
            let mock = FlickrModel.mockData
            completion(.success(mock))
        }
    }
    
    final class MockFailHomeInteractor: HomeInteractor {
        func fetchRecentPhotos(of page: Int, completion: @escaping (Result<FlickrModel, APIError>) -> Void) {
            completion(.failure(APIError.responseFailure))
        }
    }
}

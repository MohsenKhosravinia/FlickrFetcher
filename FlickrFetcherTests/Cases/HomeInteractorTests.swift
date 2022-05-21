//
//  HomeInteractorTests.swift
//  FlickrFetcherTests
//
//  Created by Mohsen Khosravinia on 5/21/22.
//

@testable import FlickrFetcher
import XCTest
import Combine
import Alamofire

class HomeInteractorTests: XCTestCase {

    func testFetchRecentPhotos_isSuccessfull() {
        let mockWebRepository = MockSuccessHomeWebRepository()
        let sut = DefaultHomeInteractor(webRepository: mockWebRepository)
        let expectedModel = FlickrModel.mockData
        
        let expectation = expectation(description: "")
        var responseModel: FlickrModel!
        
        sut.fetchRecentPhotos(of: 1) { result in
            switch result {
            case .success(let model):
                responseModel = model
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(expectedModel, responseModel)
    }
    
    func testFetchRecentPhotos_fails() {
        let mockWebRepository = MockFailureHomeWebRepository()
        let sut = DefaultHomeInteractor(webRepository: mockWebRepository)
        let expectedError = APIError.responseFailure
        
        let expectation = expectation(description: "")
        var responseError: APIError!
        
        sut.fetchRecentPhotos(of: 1) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                responseError = error
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(expectedError, responseError)
    }

}

// MARK: - Mock

private extension HomeInteractorTests {
    
    final class MockSuccessHomeWebRepository: HomeWebRepository {
        var networkController: NetworkControllerProtocol = MockNetworkController()
        
        func fetchPhotos(of page: Int) -> AnyPublisher<FlickrModel, APIError> {
            Just(FlickrModel.mockData)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
    
    final class MockFailureHomeWebRepository: HomeWebRepository {
        var networkController: NetworkControllerProtocol = MockNetworkController()
        
        func fetchPhotos(of page: Int) -> AnyPublisher<FlickrModel, APIError> {
            Fail(error: APIError.responseFailure)
                .eraseToAnyPublisher()
        }
    }
    
    final class MockNetworkController: NetworkControllerProtocol {
        func get<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Just(T.self as! T)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        func post<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Just(T.self as! T)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        func put<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Just(T.self as! T)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        func delete<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Just(T.self as! T)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
}

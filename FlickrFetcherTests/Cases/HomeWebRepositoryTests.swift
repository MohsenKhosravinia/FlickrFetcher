//
//  FlickrFetcherTests.swift
//  FlickrFetcherTests
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

@testable import FlickrFetcher
import XCTest
import Combine

class HomeWebRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        
        super.tearDown()
    }
    
    func test_fetchPhotos_responses() {
        var receivedPhotos: FlickrModel?
        let expectedPhotos = FlickrModel.mockData
        var receivedError: APIError?
        var finishedNormally: Bool = false
        let sut = DefaultHomeWebRepository(networkController: MockNetworkController())
        
        let expectation = expectation(description: "")
        sut.fetchPhotos(of: 1)
            .sink { completion in
                switch completion {
                case .finished:
                    finishedNormally = true
                case .failure(let error):
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { model in
                receivedPhotos = model
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(receivedPhotos, expectedPhotos)
        XCTAssertEqual(receivedPhotos?.photos?.items?.count, 5)
        XCTAssertTrue(finishedNormally)
        XCTAssertNil(receivedError)
    }
}

// MARK: - Mock

private extension HomeWebRepositoryTests {
    
    final class MockNetworkController: NetworkControllerProtocol {
        private var isSuccessfullResponse: Bool
        
        init(isSuccessfullResponse: Bool = true) {
            self.isSuccessfullResponse = isSuccessfullResponse
        }
        
        func get<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            guard let url = route.url else {
                return Fail(error: APIError.responseFailure).eraseToAnyPublisher()
            }
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            
            guard isSuccessfullResponse else {
                let response: AnyPublisher<T, APIError> =
                Result<T, APIError>
                    .Publisher(.failure(APIError.responseFailure))
                    .eraseToAnyPublisher()
                return response
            }
            
            let data = try! Data.fromJSON(fileName: "Fetch_Recent_Photos_Success_Response")

            let publisher: AnyPublisher<T, APIError> = Just((data: data, response: response))
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { _ in APIError.responseFailure }
                .eraseToAnyPublisher()
            
            return publisher
        }
        
        func post<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Fail(error: APIError.responseFailure).eraseToAnyPublisher()
        }
        
        func put<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Fail(error: APIError.responseFailure).eraseToAnyPublisher()
        }
        
        func delete<T>(type: T.Type, route: Routable) -> AnyPublisher<T, APIError> where T : Decodable {
            Fail(error: APIError.responseFailure).eraseToAnyPublisher()
        }
    }
}

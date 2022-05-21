//
//  HomeInteractor.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import Foundation
import Combine

protocol HomeInteractor {
    func fetchRecentPhotos(of page: Int, completion: @escaping (Result<FlickrModel, APIError>) -> Void)
}

final class DefaultHomeInteractor: HomeInteractor {
    private let webRepository: HomeWebRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(webRepository: HomeWebRepository) {
        self.webRepository = webRepository
    }
    
    func fetchRecentPhotos(of page: Int, completion: @escaping (Result<FlickrModel, APIError>) -> Void) {
        webRepository
            .fetchPhotos(of: page)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .failure(let error):
                    return completion(.failure(error))
                case .finished:
                    print("Finished")
                }
            } receiveValue: { result in
                completion(.success(result))
            }
            .store(in: &cancellables)
    }
}

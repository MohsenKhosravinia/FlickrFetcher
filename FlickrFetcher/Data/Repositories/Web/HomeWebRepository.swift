//
//  HomeWebRepository.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import Foundation
import Combine
import Alamofire

protocol HomeWebRepository: ServiceProtocol {
    func fetchPhotos(of page: Int) -> AnyPublisher<FlickrModel, APIError>
}

final class DefaultHomeWebRepository: HomeWebRepository {
    let networkController: NetworkControllerProtocol
    
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }
    
    func fetchPhotos(of page: Int) -> AnyPublisher<FlickrModel, APIError> {
        networkController.get(type: FlickrModel.self,
                              route: FlickrRoute(page: page))
    }
}

//
//  HomeViewModel.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import Foundation
import Combine

protocol HomeViewModel {
    var reloadPublisher: PassthroughSubject<Void, Never> { get }
    var errorPublisher: PassthroughSubject<String, Never> { get }
    var data: PageModel<PhotoModel>? { get }
    
    func fetchPhotos(ofPage page: Int)
}

final class DefaultHomeViewModel: HomeViewModel {
    
    public var reloadPublisher = PassthroughSubject<Void, Never>()
    public var errorPublisher = PassthroughSubject<String, Never>()
    public var data: PageModel<PhotoModel>?
    private let interactor: HomeInteractor
    
    init(interactor: HomeInteractor) {
        self.interactor = interactor
    }
    
    func fetchPhotos(ofPage page: Int = 1) {
        interactor.fetchRecentPhotos(of: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                guard let photos = model.photos,
                      let page = model.photos?.page,
                      let pages = model.photos?.pages else { return }
                
                if page == 1 {
                    self.data = photos
                } else {
                    self.data?.page = page
                    self.data?.pages = pages
                    self.data?.items?.append(contentsOf: photos.items ?? [])
                }
                
                self.reloadPublisher.send()
                
            case .failure(let error):
                switch error {
                case .responseFailure:
                    self.errorPublisher.send("Something went wrong! Try again later.")
                }
            }
        }
            
    }
}

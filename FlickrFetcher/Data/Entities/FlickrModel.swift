//
//  FlickrModel.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import Foundation

struct FlickrModel: Codable {
    var photos: PageModel<PhotoModel>?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case photos
        case status = "stat"
    }
}

// MARK: - Equatable

extension FlickrModel: Equatable {
    static func == (lhs: FlickrModel, rhs: FlickrModel) -> Bool {
        lhs.photos?.items == rhs.photos?.items
    }
}

// MARK: - Mock

extension FlickrModel {
    static var mockData: FlickrModel {
        let photos: [PhotoModel] = [.init(id: "1"),
                                    .init(id: "2"),
                                    .init(id: "3"),
                                    .init(id: "4"),
                                    .init(id: "5")]
        let page = PageModel<PhotoModel>(items: photos,
                                         page: 1,
                                         pages: 10,
                                         perPage: 100,
                                         total: 1000)
        return FlickrModel(photos: page, status: "ok")
    }
}

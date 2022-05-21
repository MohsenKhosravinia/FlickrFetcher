//
//  FlickrFetcherTests.swift
//  FlickrFetcherTests
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

@testable import FlickrFetcher
import XCTest
import Combine

class HomeVCTests: XCTestCase {

    func testViewModel_isInjected() {
        let sut = makeHomeVC()
        
        sut.fill(viewModel: MockHomeViewModel())
        
        XCTAssertNotNil(sut.viewModel)
    }
    
    func testCollectionView_initiated() {
        let sut = makeHomeVC()
        
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testCollectionViewDelegateAndDataSource_isDeclared() {
        let sut = makeHomeVC()
        
        XCTAssertNotNil(sut.collectionView.delegate)
        XCTAssertNotNil(sut.collectionView.dataSource)
    }
    
    func testCollectionViewDataCount_isCorrect() {
        let sut = makeHomeVC()
        sut.fill(viewModel: MockHomeViewModel())
        
        sut.collectionView.reloadData()
        
        XCTAssertEqual(sut.collectionView.numberOfItems(), 6)
    }
    
    func testCollectionViewImageCell_renders() {
        let sut = makeHomeVC()
        sut.fill(viewModel: MockHomeViewModel())
        
        sut.collectionView.reloadData()
        
        XCTAssertTrue((sut.collectionView.imageCell() as Any) is ImageCell)
    }
    
    func testImageCell_flips() {
        let sut = makeHomeVC()
        sut.fill(viewModel: MockHomeViewModel())
        
        let expectation = expectation(description: "cell flipping")
        
        sut.collectionView.reloadData()
        
        let cell = sut.collectionView.imageCell()
        cell.flip()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(cell.imageView.isHidden)
        XCTAssertFalse(cell.infoView.isHidden)
    }
    
    // MARK: Factory
    
    private func makeHomeVC() -> HomeVC {
        let sut = UIStoryboard.home.instantiate(viewController: HomeVC.self)
        sut.loadViewIfNeeded()
        return sut
    }
    
}

// MARK: - CollectionView

private extension UICollectionView {
    
    func numberOfItems() -> Int {
        dataSource?.collectionView(self, numberOfItemsInSection: 0) ?? 0
    }
    
    func imageCell() -> ImageCell {
        dataSource?.collectionView(self, cellForItemAt: .init(row: 0, section: 0)) as! ImageCell
    }
}

// MARK: - Mock

private extension HomeVCTests {
    
    final class MockHomeViewModel: HomeViewModel {
        var reloadPublisher = PassthroughSubject<Void, Never>()
        var errorPublisher = PassthroughSubject<String, Never>()
        var data: PageModel<PhotoModel>? =
            .init(items: [.init(id: "1", title: "Item 1"),
                          .init(id: "2", title: "Item 2"),
                          .init(id: "3", title: "Item 3"),
                          .init(id: "4", title: "Item 4"),
                          .init(id: "5", title: "Item 5"),
                          .init(id: "6", title: "Item 6")],
                  page: 1,
                  pages: 10,
                  perPage: 100,
                  total: 1000)
        
        func fetchPhotos(ofPage page: Int) {}
    }
}

//
//  ViewController.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HomeViewModel?
    
    private var collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.bottom = 10
        section.orthogonalScrollingBehavior = .none
        
        let layout = UICollectionViewCompositionalLayout { _, _ in section }
        return layout

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupBindigs()
        
        viewModel?.fetchPhotos(ofPage: 1)
    }
    
    public func fill(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(ImageCell.self)
    }
    
    private func setupBindigs() {
        viewModel?.reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.collectionView.reloadData()
            })
            .store(in: &cancellables)
        
        viewModel?.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                self?.presentAlert(message: message)
            })
            .store(in: &cancellables)
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.data?.items?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImageCell.self, indexPath: indexPath)
        cell.fill(photo: viewModel?.data?.items?[indexPath.item] ?? .init())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        cell.flip()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let items = viewModel?.data?.items,
           indexPath.row == items.count - 1,
           let pages = viewModel?.data?.pages,
           let page = viewModel?.data?.page,
           page < pages {
            viewModel?.fetchPhotos(ofPage: page + 1)
        }
    }
}

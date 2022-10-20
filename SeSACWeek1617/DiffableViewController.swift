//
//  DiffableViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/19.
//

import UIKit
import Kingfisher

class DiffableViewController: UIViewController {
    
    var viewModel = DiffableViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    // Int: Section
    // String: list의 값
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        APIService.searchPhoto(query: "apple")
        
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        
        searchBar.delegate = self
        
        viewModel.photoList.bind { [weak self] photo in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.results)
            self.dataSource.apply(snapshot)

        }
    }
    
}

extension DiffableViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            DispatchQueue.global(qos: .default).async {
                guard let url = URL(string: itemIdentifier.urls.thumb) else { return }
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
            }
            
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .blue
            cell.backgroundConfiguration = background
            
        })
        
        // cellForItemAt && numberOfItemsInSection
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in

            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)

            return cell

        })
//
//        // Inital
    }
    
}

extension DiffableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.reqesutSearchPhoto(query: searchBar.text!)
    }
}

extension DiffableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//
//        let alert = UIAlertController(title: item, message: "클릭!!", preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "확인", style: .cancel)
//
//        alert.addAction(ok)
//        present(alert, animated: true)
        
    }
    
}

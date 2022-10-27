//
//  DiffableViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/19.
//

import UIKit

import RxSwift
import RxCocoa

private class DiffableViewController: UIViewController {
    
    var viewModel = DiffableViewModel()
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    // Int: Section
    // String: list의 값
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        
//        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        
        
//        viewModel.photoList.bind { [weak self] photo in
//            guard let self else { return }
//            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
//            snapshot.appendSections([0])
//            snapshot.appendItems(photo.results)
//            self.dataSource.apply(snapshot)
//
//        }
    }
    
    func bindData() {
        
        viewModel.photoList
            .withUnretained(self) // 구독하기 직전에
            .subscribe { vc, value in
                var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
                snapshot.appendSections([0])
                snapshot.appendItems(value.results)
                vc.dataSource.apply(snapshot)
            } onError: { error in
                print("=====error: \(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { vc, value in
                vc.viewModel.reqesutSearchPhoto(query: value)
            }
            .disposed(by: disposeBag)
        
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

    }
    
}

//extension DiffableViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        viewModel.reqesutSearchPhoto(query: searchBar.text!)
//    }
//}

//extension DiffableViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//
//        let alert = UIAlertController(title: item, message: "클릭!!", preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "확인", style: .cancel)
//
//        alert.addAction(ok)
//        present(alert, animated: true)
//
//    }
//
//}

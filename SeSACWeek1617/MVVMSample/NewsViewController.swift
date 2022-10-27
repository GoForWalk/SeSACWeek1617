//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

class NewsViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var viewModel = NewsViewModel()
    var datasource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierachy()
        configureDataSource()
        
        bindData()
    }
    
}

// MARK: - BindData
extension NewsViewController {
    
    func bindData() {
        
        viewModel.newsSample
            .withUnretained(self)
            .bind { vc, item in
                var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
                snapshot.appendSections([0])
                snapshot.appendItems(item)
                vc.datasource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.pageNumber
            .bind(to: numberTextField.rx.value)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
        
        loadButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
        
        viewModel.pageNumber
            .withUnretained(self)
            .bind { vc , value in
                vc.numberTextField.text = value
            }
            .disposed(by: disposeBag)
        
        numberTextField.rx.text
            .withUnretained(self)
            .bind { vc, value in
                guard let value else { return }
                vc.viewModel.changePageNumberFormat(text: value)
            }
            .disposed(by: disposeBag)
    }
}

extension NewsViewController {
    
    func configureHierachy() { // addSubView, init, snapkit
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
}

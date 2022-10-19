//
//  SimpleCollectionView.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/18.
//

import UIKit

struct User: Hashable {
    
    let id = UUID().uuidString
    let name: String
    let age: Int
    
    
}


class SimpleCollectionViewController: UICollectionViewController {
    
//    let list = ["슈비버거", "프랭크", "와퍼", "고래밥", "콘소메 치킨"]
    
    var list = [
        User(name: "JACK", age: 22),
        User(name: "HUE", age: 23),
        User(name: "JACK", age: 22),
        User(name: "HUE", age: 23),
        User(name: "Owen", age: 30),
        User(name: "Harry", age: 18)
    ]
    
    // CellRegistration 타입 선언.
    // cellForItemAt 함수 생성전에 이 타입에 대한 선언을 해야한다. -> 보통 별도의 property로 선언하여 만들기를 권유
    // => Register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.collectionViewLayout = createLayout()
        
//        UICollectionView.CellRegistration(handler: <#T##UICollectionView.CellRegistration<Cell, Item>.Handler##UICollectionView.CellRegistration<Cell, Item>.Handler##(_ cell: Cell, _ indexPath: IndexPath, _ itemIdentifier: Item) -> Void#>) 사용
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            print("setUp")
            // cell: CollectionViewCell 타입
            // indexPath: 해당 CollectionViewCell의 indexPath
            // itemIdentifier: cell에 들어올 데이터
            
//            var content = cell.defaultContentConfiguration()
            // 다양한 listConfigure에서 cell 선택 가능
            var content = UIListContentConfiguration.subtitleCell()
            
            content.text = itemIdentifier.name
            content.image = UIImage(systemName: "person.fill")
            
            // cell내부 content를 설정할 수 있다.
            content.textProperties.color = .blue
            content.imageProperties.tintColor = .darkGray
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 8
//            content.text = "ㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇㅇㅂㅇㅇㅅㅇ"
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .cyan
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .gray
            cell.backgroundConfiguration = backgroundConfig
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)

            return cell
            
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
        
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let item = list[indexPath.item]
//
//        // CellRegistration에 대해서
//        // CellRegisteration의 Generic
//        // 1. Cell의 종류
//        // 2. item data type
//        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//
//        return cell
//    }
    
}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration)
        // 다양한 설정 가능
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .green
        
        
        // collecitonView를 List처럼 사용하는 방법
        // UICollectionViewCompositionalLayout에서 List를 사용하여 configuration 설정
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        return layout
    }
    
}

//
//  ViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {

    let list = ["슈비버거", "프랭크", "와퍼", "고래밥"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 기존의 collectionView 구현
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        cell.textLabel?.text = list[indexPath.row]
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration() // @MainActor func defaultContentConfiguration() -> UIListContentConfiguration
        content.text = list[indexPath.row] // textLabel을 대체
        content.secondaryText = "햄버거 먹고싶다" // DetailTextLabel
        
        cell.contentConfiguration = content // cell에 UIListContentConfiguration 등록
        return cell
    }

}


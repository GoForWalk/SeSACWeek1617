//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {
    
    @IBOutlet weak var simpleSwitch: UISwitch!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleTableView: UITableView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signName: UITextField!
    
    var disposeBag = DisposeBag()
    
    var nickName = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
        }
        
        setSwitch()
        setTableView()
        setPickerView()
        setSign()
        setOperator()
    }
    
    // viewController deinit되면, 알아서 dispose 해준다.
    // 또는 DisposeBag() 객체를 새롭게 넣어주거나, nil 할당 => 예외케이스! (rootvc에 interval이 있다면?)
    deinit {
        print("❌❌❌❌❌❌❌❌❌❌❌ RxCocoaExampleViewController ❌❌❌❌❌❌❌❌❌❌❌")
    }
    
    func setOperator() {
        
        let itemsA = [2.0, 2.3, 2.6, 8.0, 8.1]
//        let itemsB = [5.0, 5.3, 5.6]
        
        Observable.repeatElement("Jack") // infinite Observable Sequence
            .take(5) // Finite Observable Sequence
            .subscribe { values in
                print("just - \(values)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just - onCompleted")
            } onDisposed: {
                print("just - disposed")
            }
            .disposed(by: disposeBag)
        
        
        Observable.just(itemsA)
            .subscribe { values in
                print("just - \(values)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just - completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA)
            .subscribe { values in
                print("of - \(values)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of - completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)

        Observable.from(itemsA)
            .subscribe { values in
                print("from - \(values)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from - completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)

        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { values in
                print("interval -\(values)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval - completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)

        // DisposeBag: 리소스 해제 관리 -
            // 1. 시퀀스 끝날 때 but bind
            // 2. class deinit 자동 해제 (bind)
            // 3. dispose 직접 호출 -> dispose() 구독하는 것마다 별도로 처리
            // 4. DisposeBag을 새롭게 할당하거나, nil 전달
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.disposeBag = DisposeBag() // DisposeBag이 deinit되면서 Dispose를 실행시킨다.
        }
    }
    
    func setSign() {
        
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            "name은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 10 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        signButton.rx.tap
//            .subscribe {[weak self] _ in
//                self?.showAlert()
//            }
//            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self) //순환참조를 해결해주는 operator [weak self]
            .subscribe { vc, _ in
                vc.showAlert()
            }
            .disposed(by: disposeBag)
        
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)

        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

        
    }
    
    func setPickerView() {
        
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map {
                $0.first
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func setSwitch() {
        
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
    }

    func showAlert() {
        let alert = UIAlertController(title: "rxrxrx", message: "재미따!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ㅇㅅㅇ", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}

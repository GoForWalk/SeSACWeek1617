//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/25.
//

import UIKit

import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var newContectButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) // 초기값이 있다. (초기값 필수)
    let replay = ReplaySubject<Int>.create(bufferSize: 10)
        // bufferSize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한번에 이벤트 전달
    let async = AsyncSubject<Int>()
    
    // variable 은 이제 안쓰는 서브젝트
    override func viewDidLoad() {
        super.viewDidLoad()

//        publishSubject()
//        behaviorSubject()
//        replaySubject()
//        asyncSubject()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) {
                (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.phoneNumber))"
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.fetchData()
            }
//            .subscribe { vc, _ in
//                vc.viewModel.fetchData()
//            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newContectButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
//            .distinctUntilChanged() // 같은 값을 받지 않는 오퍼레이터
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait (다음 반응 1초 대기)
            .subscribe { vc, value in
                print("====\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
    }
    
    func publishSubject() {
        // 초기값이 없는 빈 상태
        // subscribe 전/ error/completed notification 이후 이벤트 무시
        // subscribe 후에 대한 이벤트 처리는 다 처리
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish - onCompleted")
            } onDisposed: {
                print("publish - onDisposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        
        publish.onCompleted()
        
        publish.onNext(6)
        publish.onNext(7)
        
    }
    
    func behaviorSubject() {
        // 구독 전에 가장 최근 값을 emit
        behavior.onNext(1)
        behavior.onNext(200)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior - onCompleted")
            } onDisposed: {
                print("behavior - onDisposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        behavior.onNext(6)
        behavior.onNext(7)

        
    }

    func replaySubject() {
        // buffersize 메모리, array, 이미지 => 메모리 부하를 조심해야 한다.
        
        replay.onNext(1)
        replay.onNext(2)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay - onCompleted")
            } onDisposed: {
                print("replay - onDisposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(5))
        
        replay.onCompleted()
        
        replay.onNext(6)
        replay.onNext(7)

        
    }
    
    func asyncSubject() {
        
        async.onNext(1)
        async.onNext(2)
        async.onNext(200)
        async.onNext(300)
        async.onNext(400)
        async.onNext(500)
        
        async
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async - onCompleted")
            } onDisposed: {
                print("async - onDisposed")
            }
            .disposed(by: disposeBag)
        
        async.onNext(3)
        async.onNext(4)
        async.on(.next(5))
        async.onCompleted()
        async.onNext(6)
        async.onNext(7)

        
    }

}

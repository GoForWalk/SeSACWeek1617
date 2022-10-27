//
//  SubScribeViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/26.
//

import UIKit

import RxCocoa
import RxSwift

class SubScribeViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 3. 네트워크 동신이나 파일 다운로드 등 백그라운드 작업 -> Main에서 화면 띄워주게...
        button.rx.tap
            .observe(on: MainScheduler.instance) // Main 쓰레드도 바꿔줘!! (observe: 쓰레드 변경하는 오퍼레이터)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕반가워"
            }
            .disposed(by: disposeBag)

        // 4. bind -> Main 쓰레드에서 동작한다.
        // 런타임 에러 발생 가능성 있다. (Error 처리 안됨)
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.label.text = "안녕반가워"
            }
            .disposed(by: disposeBag)

        // 5. operator로 데이터의 Stream을 조작
        button.rx.tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 6. driver traits: bind + stream 공유 ( 리소스 낭비 방지, Share() )
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    
}

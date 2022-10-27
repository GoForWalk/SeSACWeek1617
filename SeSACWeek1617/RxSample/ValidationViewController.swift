//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/27.
//

import UIKit

import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
//        observableVsSubject()
    }
    
    func bind() {
        
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
            .share()

        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        validation
            .withUnretained(self)
            .bind { vc, value in
                let color: UIColor = value ? .cyan : .systemPink
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap
            .bind { _ in
                print("show Alert")
            }
            .disposed(by: disposeBag)
        
    }

    func observableVsSubject() {
        
        let testA = stepButton.rx.tap
            .map {"안녕하세요"}
            .asDriver(onErrorJustReturn: "")
            
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
        
        // Obserable : observer = 1:1 관계
        // 구독되는 횟수만큼 stream이 만들어진다.
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe{ value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe{ value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe{ value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        // Stream을 공유한다.
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
    }
    
    
    
}

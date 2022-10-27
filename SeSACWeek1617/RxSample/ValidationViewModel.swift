//
//  ValidationViewModel.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/27.
//

import Foundation

import RxSwift
import RxRelay

final class ValidationViewModel {
    
    // validation 문구
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요.")
    
}

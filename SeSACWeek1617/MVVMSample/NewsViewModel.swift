//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/20.
//

import Foundation

import RxSwift
import RxCocoa

class NewsViewModel {
    
//    var pageNumber: CObservable<String> = CObservable("3000")
//    var newsSample: CObservable<[News.NewsItem]> = CObservable(News.items)
    
    var pageNumber = BehaviorSubject(value: "3000")
//    var newsSample = BehaviorSubject(value: News.items)
    var newsSample = BehaviorRelay(value: News.items)
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        
        let result = numberFormatter.string(from: number as NSNumber)!
        pageNumber.onNext(result)
    }
    
    func resetSample() {
//        newsSample.onNext([])
        newsSample.accept([])
    }
    
    func loadSample() {
//        newsSample.onNext(News.items)
        newsSample.accept(News.items)
    }
    
    
}

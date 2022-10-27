//
//  DiffableViewModel.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/20.
//

import Foundation

import RxSwift

enum SearchError: Error {
    case nonPhoto
    case serverError
}

struct DiffableViewModel {
    
//    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    var photoList = PublishSubject<SearchPhoto>()
    
    func reqesutSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { photo, statusCode, error in
            
            guard let statusCode, statusCode == 200 else {
                self.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo else {
                self.photoList.onError(SearchError.nonPhoto)
                return
            }
//            self.photoList.value = photo
            self.photoList.onNext(photo)
        }
    }
    
}

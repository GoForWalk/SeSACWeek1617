//
//  DiffableViewModel.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/20.
//

import Foundation

struct DiffableViewModel {
    
    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    func reqesutSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { photo, statusCode, error in
            
            guard let photo else { return }
            self.photoList.value = photo
            
            
            
        }
    }
    
}

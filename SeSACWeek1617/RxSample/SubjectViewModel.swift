//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/25.
//

import Foundation

import RxSwift

struct Contact {
    let name: String
    let age: Int
    var phoneNumber: String
}


class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Jack", age: 21, phoneNumber: "01023456789"),
        Contact(name: "Metaverse Jack", age: 23, phoneNumber: "01023456789"),
        Contact(name: "Real Jack", age: 19, phoneNumber: "01012341234")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...30), phoneNumber: "")
        
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        
        let temp = query != "" ? contactData.filter {
            $0.name.contains(query)
        } : contactData
                
        list.onNext(temp)
    }
    
    
}

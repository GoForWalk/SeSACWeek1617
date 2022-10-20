//
//  APIService.swift
//  SeSACWeek1617
//
//  Created by sae hun chung on 2022/10/20.
//

import Foundation
import Alamofire

class APIService {
    
    // Result Type 써보기
    static func searchPhoto(query: String, completionHandler: @escaping (SearchPhoto?, Int?, Error?) -> Void) {
        let url = "\(APIKey.searchURL)\(query)"
        let header: HTTPHeaders = ["Authorization" : APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            
            let statusCode = response.response?.statusCode // 상태코드
            
            switch response.result {
            case .success(let value): print(value); completionHandler(value, statusCode, nil)
            case .failure(let error): print(error); completionHandler(nil, statusCode, error) // 아예 안되는 상황
            }
        }
    }
    
    private init() { }
    
}

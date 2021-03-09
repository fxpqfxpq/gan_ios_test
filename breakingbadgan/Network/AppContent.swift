//
//  AppContent.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 16.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Alamofire

enum ErrorMessage: Error {
    case invalidData(error: String)
    case networkFailure(error: String)
}

class AppContent {
    
    static let shared = AppContent()
    
    var apiService = MoyaProvider<DataApiService>(
        session: Session(interceptor: nil),
        plugins: [NetworkLoggerPlugin(configuration: .init(
            formatter: .init(responseData: Utils.JSONResponseDataFormatter),
            logOptions: .verbose))])
    
    func fetch(service : DataApiService) -> Observable<Any?> {
        return Observable.create { (observable) -> Disposable in
            self.apiService.rx.request(service).subscribe(onSuccess: {  (response) in
                let decoder = JSONDecoder.init()
                
                if response.statusCode != 200 {
                    print("AppContent.fetch failed with response statusCode: \(response.statusCode)")
                    observable.onError(ErrorMessage.networkFailure(error: response.description))
                    return
                }
                
                do {
                    switch(service) {
                    case .getCharacters(_):
                        let parsed = try decoder.decode([Character].self, from: response.data)
                        observable.onNext(parsed)
                    }
                } catch let err {
                    observable.onError(err)
                }
            }) { (err) in
                observable.onError(err)
            }
        }
    }
}

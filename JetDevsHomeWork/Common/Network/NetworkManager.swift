//
//  NetworkManager.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 11/01/24.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class NetworkManager {

    // MARK: - Singleton
    static let shared = NetworkManager()

    private init() {}

    // MARK: - Public Methods

    func fetchData<T: Codable>(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> Observable<T> {
        return Observable.create { observer in
            let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { response in
                 
                    switch response.result {
                    case .success(let data):
                        do {
                            if let headers = response.response?.allHeaderFields as? [String: String],
                                     let xAccHeaderValue = headers["X-Acc"] {
                                    UserSessionManager.shared.saveUserAccToken(xAccHeaderValue)
                                  } else {
                                      print("X-Acc header not found in the response")
                                  }
                            
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(decodedData)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

}

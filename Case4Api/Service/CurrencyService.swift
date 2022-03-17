//
//  USAUniversiteService.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 17.03.2022.
//

import Foundation

public protocol CurrencyServiceProtocol {
    func fetchResults(completion: @escaping (MyResult<CurencyResponse>)->Void)
}

public final class CurrencyService:CurrencyServiceProtocol{
    public init() { }
    public func fetchResults(completion: @escaping (MyResult<CurencyResponse>) -> Void) {
        
         let urlString = "https://api.binance.com/api/v3/exchangeInfo"
        let urlComponents = URLComponents(string: urlString)
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
            }else{
                guard let data = data else {completion(.failure(NetworkError.emptyData)); return }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CurencyResponse.self, from: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

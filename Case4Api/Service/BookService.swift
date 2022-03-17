//
//  AmazonProductService.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 17.03.2022.
//

import Foundation


public protocol BookApiServiceProtocol {
    func fetchResults(completion: @escaping (MyResult<BookResponses>)->Void)
}

public final class BookApiService:BookApiServiceProtocol{
    public init() { }
    public func fetchResults(completion: @escaping (MyResult<BookResponses>) -> Void) {
        
        if let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/albums.json"){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                completion(.failure(error))
            } else {
                guard let data = data else {completion(.failure(NetworkError.emptyData)); return }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(BookResponses.self, from: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(error))
                }
            }
        })

        dataTask.resume()
        }else{
            
        }
}
}

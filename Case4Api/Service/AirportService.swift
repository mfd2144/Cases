//
//  AirportService.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 17.03.2022.
//

import Foundation

public protocol AirportServiceProtocol{
    func fetchAirportInformation(completion: @escaping (MyResult<AirportResponses>)->Void)
}
public final class AirportService:AirportServiceProtocol{
   public init() { }
    public func fetchAirportInformation(completion: @escaping (MyResult<AirportResponses>) -> Void) {
        let urlString = "https://api.checkwx.com/station/lat/37.32689395/lon/-122.02685541/radius/10"

        if let url = URL(string: urlString) {
            var request = URLRequest.init(url: url)
            request.setValue("1882e823346a4d8a99f81b5ced", forHTTPHeaderField: "x-api-key")
            let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
        } else {
            guard let data = data else {completion(.failure(NetworkError.emptyData)); return }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(AirportResponses.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
            task.resume()
        }else{
            completion(.failure(NetworkError.urlError))
        }
        
    }
}


//
//  File.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

public protocol TopAlbumsServiceProtocol {
    func fetchResults(completion: @escaping (MyResult<TopAlbumResponses>)->Void)
}

public final class TopAlbumsService:TopAlbumsServiceProtocol{
    public init() { }
    public func fetchResults(completion: @escaping (MyResult<TopAlbumResponses>) -> Void) {
         let urlString = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json"
           if let url = URL.init(string: urlString){
           let urlRequest = URLRequest.init(url: url)
           URLSession.shared.dataTask(with: urlRequest) { data, response, error in
               if let httpResponse = response as? HTTPURLResponse{
                   print("Http status: \(httpResponse.statusCode) This print is in network layer")
               }
               if let error = error {
                   completion(.failure(error))
               }else{
                   let dateDecoder = Decoders.plainDateDecoder
                   guard let data = data else {completion(.failure(NetworkError.emptyData)); return }
                   do{
                   let albums = try dateDecoder.decode(TopAlbumResponses.self, from: data)
                       completion(.success(albums))
                   }catch let error{
                       completion(.failure(error))
                   }
               }
           }.resume()
           }else{
               completion(.failure(NetworkError.urlError))
           }
    }
}



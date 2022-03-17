//
//  AlbumPresentation.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation

public struct Album: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case artistName
        case releaseDate
        case artistUrl
        case genres
       case imageURL = "artworkUrl100"
    }
    
   public let artistName: String
    public let releaseDate: Date
    public  let artistUrl: URL
    public let imageURL: URL
    public let genres: [Genre]
}

public struct Genre: Decodable {
    public let name: String
}

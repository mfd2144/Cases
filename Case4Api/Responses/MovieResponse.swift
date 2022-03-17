//
//  Movieresponder.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation

public struct TopAlbumResponses:Decodable{
    public init(){ }
    public var result:[Album] = []
    private enum RootCodingKey:String,CodingKey{
        case feed
    }
    
    private enum ResultCodingKey:String,CodingKey{
        case results
    }
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKey.self)
        let resultContainer = try rootContainer.nestedContainer(keyedBy: ResultCodingKey.self, forKey: .feed)
        result = try resultContainer.decode([Album].self, forKey: .results)
        
    }
}

//
//  AmazonResponses.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 17.03.2022.
//

import Foundation



public struct BookResponses:Decodable {
    public var result = [Book]()
    public init(){ }
    private enum RootCodingKey:String,CodingKey{
        case feed
    }
    private enum ResultCodingKey:String,CodingKey{
        case results
    }
public init(from decoder: Decoder) throws {
    let rootDecoder = try decoder.container(keyedBy: RootCodingKey.self)
    let nestedDecoder = try rootDecoder.nestedContainer(keyedBy: ResultCodingKey.self, forKey: .feed)
    result = try nestedDecoder.decode([Book].self, forKey: .results)
}
}

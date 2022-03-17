//
//  File.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 17.03.2022.
//

import Foundation



public struct AirportResponses:Decodable{
    public var results : [Airport]
    public init(results:[Airport]){
        self.results = results
    }
    enum RootCodingKey:String, CodingKey{
        case data
    }
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKey.self)
        results = try rootContainer.decode([Airport].self, forKey: .data)
       
    }
}

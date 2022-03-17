//
//  CurrencyResponse.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 17.03.2022.
//


public struct CurencyResponse:Decodable{
    public var result = [Currency]()
enum RootCodingKeys:String,CodingKey{
    case symbols
}

public  init(from decoder: Decoder) throws {
    let resultDecoder = try decoder.container(keyedBy: RootCodingKeys.self)
    result = try resultDecoder.decode([Currency].self, forKey: .symbols)
}
}

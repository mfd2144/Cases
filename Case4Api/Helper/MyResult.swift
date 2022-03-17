//
//  Result.swift
//  Case4Api
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation

public enum MyResult<Value>{
    case failure(Error)
    case success(Value)
}



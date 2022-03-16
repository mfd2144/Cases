//
//  Log.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation
import UIKit.UIColor

struct Log {
    enum ContentType {
        case info, warning, error, print
        var color: UIColor {
            switch self {
            case .info:     return .orange
            case .warning:  return .darkGray
            case .error:    return .red
            case .print: return .systemTeal
            }
        }
    }
    var type: ContentType
    var content: String
}

//
//  ViewModel.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation
import Case4Api

enum ViewModelOutputs{
    case logPrintCaution(String)
    case respondToRequest([ShortAlbum])
    case mockError
    case anyError(String)
}

protocol ViewModelDelegate:AnyObject{
    func handleOutput(_ output:ViewModelOutputs)
}

protocol ViewModelProtocol:AnyObject{
    var delegate:ViewModelDelegate? {get set}
    func httpsRequest()
    func mockHttpsRequest()
}

final class ViewModel:ViewModelProtocol{
    weak var delegate:ViewModelDelegate?
    var logger:Logger!
    var service:TopAlbumsService!
    init() {
        logger = Logger()
        logger.delegate = self
    }
    
    func httpsRequest() {
        service = TopAlbumsService()
        service.fetchResults { [unowned self] result in
            switch result{
            case.failure(let error):
                delegate?.handleOutput(.anyError(error.localizedDescription))
            case.success(let albums):
               let shortAlbums = albums.result.map({ShortAlbum(album: $0)})
                delegate?.handleOutput(.respondToRequest(shortAlbums))
            }
        }
    }
    
    func mockHttpsRequest() {
        print("Mock request started")
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [unowned self] in
            delegate?.handleOutput(.mockError)
        }
    }
}

extension ViewModel:LoggerDelegate{
    func logText(text: String) {
        delegate?.handleOutput(.logPrintCaution(text))
    }
}

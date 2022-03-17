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
    case anyInfo(String)
}

protocol ViewModelDelegate:AnyObject{
    func handleOutput(_ output:ViewModelOutputs)
}

protocol ViewModelProtocol:AnyObject{
    var delegate:ViewModelDelegate? {get set}
    func asynchronousHttpsRequest()
    func synchronousHttpsRequest()
    func mockHttpsRequest()
}

final class ViewModel:ViewModelProtocol{
    weak var delegate:ViewModelDelegate?
    var logger:Logger!
    var service:TopAlbumsServiceProtocol!
    var currencyService:CurrencyServiceProtocol!
    var bookService:BookApiServiceProtocol!
    var airportService: AirportServiceProtocol!
    init() {
        logger = Logger()
        logger.delegate = self
        service = TopAlbumsService()
        currencyService = CurrencyService()
        bookService = BookApiService()
        airportService = AirportService()
    }
    func synchronousHttpsRequest() {
        albumServiceRequest { [unowned self] in
            delegate?.handleOutput(.anyInfo("Album request finished "))
            currencyRequest { [unowned self] in
                delegate?.handleOutput(.anyInfo("Currenct request finished "))
                bookServiceRequest { [unowned self] in
                    delegate?.handleOutput(.anyInfo("Book request finished "))
                    airportServiceRequest {
                        [unowned self] in
                        delegate?.handleOutput(.anyInfo("Airport request finished "))
                    }
                    
                }
                
            }
        }
        
    }
    
    
    //MARK: - Case 5 answer
    //    func synchronousHttpsRequest() {
    //        print("Synchronous Https Request started ")
    //        let semaphore = DispatchSemaphore(value: 0)
    //        albumServiceRequest { [unowned self] in
    //            delegate?.handleOutput(.anyInfo("Album request finished "))
    //            semaphore.signal()
    //        }
    //        semaphore.wait()
    //        currencyRequest { [unowned self] in
    //            delegate?.handleOutput(.anyInfo("Currenct request finished "))
    //            semaphore.signal()
    //        }
    //        semaphore.wait()
    //        bookServiceRequest { [unowned self] in
    //            delegate?.handleOutput(.anyInfo("Book request finished "))
    //            semaphore.signal()
    //        }
    //        semaphore.wait()
    //    }
    
    
    func asynchronousHttpsRequest() {
        albumServiceRequest{}
        currencyRequest{}
        bookServiceRequest{}
        airportServiceRequest {}
    }
    
    func mockHttpsRequest() {
        print("Mock request started")
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [unowned self] in
            delegate?.handleOutput(.mockError)
        }
    }
    
    fileprivate func albumServiceRequest(completion:@escaping()->()) {
        service.fetchResults { [unowned self] result in
            switch result{
            case.failure(let error):
                delegate?.handleOutput(.anyError(error.localizedDescription))
            case.success(let albums):
                let shortAlbums = albums.result.map({ShortAlbum(album: $0)})
                delegate?.handleOutput(.respondToRequest(shortAlbums))
            }
            completion()
        }
    }
    fileprivate func currencyRequest(completion:@escaping()->()) {
        currencyService.fetchResults { [unowned self] result in
            switch result {
            case.failure(let error):
                delegate?.handleOutput(.anyError(error.localizedDescription))
            case.success(let currency):
                guard let currencyName = currency.result.first?.baseAsset else {return}
                print("first currency name:\(currencyName)")
                break
            }
            completion()
        }
    }
    
    fileprivate func bookServiceRequest(completion:@escaping()->()) {
        bookService.fetchResults { [unowned self] result in
            switch result {
            case.failure(let error):
                delegate?.handleOutput(.anyError(error.localizedDescription))
            case.success(let books):
                guard  let book = books.result.first?.name else {return}
                print("first book name:\(book)")
            }
        }
        completion()
    }
    
    fileprivate func airportServiceRequest(completion:@escaping()->()) {
        airportService.fetchAirportInformation { [unowned self] result in
            switch result {
            case.failure(let error):
                delegate?.handleOutput(.anyError(error.localizedDescription))
            case.success(let airports):
                guard let airportName = airports.results.first?.name else {
                    return
                }
                print(airportName)
            }
        }
        completion()
    }
}

extension ViewModel:LoggerDelegate{
    func logText(text: String) {
        delegate?.handleOutput(.logPrintCaution(text))
    }
}

//MARK: Asynchronous communication is when there can be multiple requests and responses can be returned in random order. An asynchronous request does not block the client. Meanwhile, the user can perform other operations. Thus, the application can use the topics more efficiently. In addition, asynchronous request applications save time. By making multiple requests asynchronously and receiving answers at different times, the waiting time of the user is minimized.

//MARK: In synchronous communication we send the request and the thread freezes until the response is returned. It is easy to read and debug. But the biggest problem here is that the UI will wait until all the answers come. We never know how long we need the server to get a response, so the user gets stuck on the same page doing nothing. Concurrent requests prevent code from executing, causing "freeze" on the screen and an unresponsive user experience. But if the data called with APIs needs to be used for another next operation, this time it is necessary to make http requests synchronously.


//MARK: - I add asynchronous and synchronous button to case 4.You can see them in view model file. I add two different method for synchronous http request. But just one of them is active. To prevent freezing, I decide to set up nested structure. I add codes here also.


//I didn't prefer using this method because it caused to freezing.
//func synchronousHttpsRequest() {
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



// the other way is we can use nested completions
//       func synchronousHttpsRequest() {
//           albumServiceRequest { [unowned self] in
//               delegate?.handleOutput(.anyInfo("Album request finished "))
//               currencyRequest { [unowned self] in
//                   delegate?.handleOutput(.anyInfo("Currenct request finished "))
//                   bookServiceRequest { [unowned self] in
//                       delegate?.handleOutput(.anyInfo("Book request finished "))
//                       airportServiceRequest {
//                           [unowned self] in
//                               delegate?.handleOutput(.anyInfo("Airport request finished "))
//                       }
//
//                   }
//
//               }
//           }
//
//       }

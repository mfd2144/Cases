//
//  Logger.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation

protocol LoggerDelegate:AnyObject {
    func logText(text:String)
}
// Logger catch print output and send to user as caution
class Logger{
    weak var delegate:LoggerDelegate?
    init(){
        captureStdout()
    }
func captureStdout() {
    let outputPipe = Pipe()
    // Intercept STDOUT with outputPipe
    dup2(outputPipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)

    outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()

    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
      notification in
      let output = outputPipe.fileHandleForReading.availableData
      let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
          self.delegate?.logText(text: outputString)
   outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
    }
  }


}

//: [Previous](@previous)
//Firstly I created a dice object
//Then I added two methods(calculator(), throwDice())
//The throwDice method uses the actual nanosecond to return a dice value with the help of the calculator method
//Both of them return an integer
//For unit test ,I evaluated dice value and calculator return value.
//Dice value must be greater than 0 and less than 7
//Also calculator must return expected value for a specific number
import Foundation
import XCTest

struct Dice{
    func throwDice()->Int {
        let date = Date()
        let calender = Calendar.current
        let nanosecond = calender.component(.nanosecond,from:date)
        return calculator(number: nanosecond)
    }
    func calculator(number:Int)->Int {
        return (number%6)+1
    }
}

class DiceManagerTests: XCTestCase {
    var dice: Dice!
     override func setUp() {
         super.setUp()
         dice = Dice()
     }
    func testDice() throws{
        let diceResult = dice.throwDice()
        let number = dice.calculator(number:15)
        print(diceResult)
        XCTAssertLessThan(diceResult,7)
        XCTAssertGreaterThan(diceResult,0)
        XCTAssertEqual(4, number)
    }
}
DiceManagerTests.defaultTestSuite.run()


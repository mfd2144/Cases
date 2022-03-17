
/*I found two ways to calculate square root of any given number(Except float number).
 The easy way is to define a variable equal to 1, multiply it with itself, and compare it
 to the user-supplied number in a while loop. If the multiplication value is not equal to
 the given number, a number is added to the value in the while loop.And go on until variable
 is equal or greater than given number.I used the second variable because I don't want the
 multiplication to be repeated.
 */

import Cocoa
struct RootSquare1 {
    static func calculateRootSquare(_ number:Int)->Int {
        guard number != 0 else{ return 0 }
        var sqr:Int = 1
        var container:Int = 1

    while container < number{
       sqr += 1
        container = sqr*sqr
    }
        return sqr
}
}

let squareRoot = RootSquare1.calculateRootSquare(67600)
print(squareRoot)

/*Second way is the better option, because it decrease number of calculation significantly
 especially for big numbers. To understand this, we must examine the following function:
    (x/√x+√x)/2 = √x
 To implement this function we must use two variables and of course a while loop. When
 the method starts, the first variable equals half of the given number and the second
 equals 0. Then the application starts checking these variables in a while loop until
 the two are equal. In the loop, firstly our second variable is set to the first variable.
 Then the method uses the function I mentioned above and equates it to the first variable.
 The loop continues until both variables are equal.
 */


struct RootSquare2 {
        static func calculateRootSquare(_ number:Int)->Int {
        guard number != 0 else{ return 0 }
        guard number != 1 else{ return 1 }
        guard number != 3 else {return 3}
        var sqr:Int = number/2
        var container:Int = 0
        while sqr != container{
            container = sqr
            sqr = (number/container + container)/2
        }
    return sqr
    }
}

let squareRoot2 = RootSquare2.calculateRootSquare(67600)
print(squareRoot2)



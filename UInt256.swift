//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.

// Avoid using NSNumber:
func raiseByPositivePower(radix: Int, power: Int) -> Int {
    var res = 1;
    for _ in 1...power {
        res *= radix;
    }
    return res;
}

operator infix ^^ { precedence 160 associativity left }
@infix func ^^ (radix: Int, power: Int) -> Int {
    assert(power >= 0, "Power must be 0 or more")
    return raiseByPositivePower(radix, power)
}

struct UInt256 : Comparable, Printable {
    // We should support the following protocols before honoring ourselves with the
    // UnsignedInteger protocol:
    
    // Hashable
    // IntegerLiteralConvertible
    // _BuiltinIntegerLiteralConvertible
    // ArrayBound
    // _UnsignedInteger
    // _IntegerArithmetic
    // ForwardIndex  (_Incrementable, etc)
    // IntegerArithmetic
    // BitwiseOperations
    
    let part1: UInt32 // Most significant
    let part2: UInt32
    let part3: UInt32
    let part4: UInt32
    let part5: UInt32
    let part6: UInt32
    let part7: UInt32
    let part8: UInt32 // Least significant

    var description: String { return "0x" + self.toHexString}
    
    var toDecimalString: String {
        // start with self.toHexString
    
        // Concatenate and reverse:
            
            
        // Convert to array of integers between 0-15
    
        // Initialize empty array for decimal digits (78 is max length)
            
        // Convert hex array to decimal array:
            
        // Concatenate decimal digits into string:
    
        return ""

    }
    
    var toHexString: String {
        var paddedHexString8 = BaseConverter.decToHex(self.part8.description)
        
        for _ in 1...(8 - countElements(paddedHexString8)) {
            paddedHexString8 = "0" + paddedHexString8;
        }
            
        var paddedHexString7 = BaseConverter.decToHex(self.part7.description)
        
        for _ in 1...(8 - countElements(paddedHexString7)) {
            paddedHexString7 = "0" + paddedHexString7;
        }
        
        var paddedHexString6 = BaseConverter.decToHex(self.part6.description)
        
        for _ in 1...(8 - countElements(paddedHexString6)) {
            paddedHexString6 = "0" + paddedHexString6;
        }
            
        return "..." + paddedHexString6 + paddedHexString7 + paddedHexString8
    }

    init(decimalStringValue: String) {
        // First we perform some sanity checks on the string. Then we convert it to a hex string.
        
        assert(countElements(decimalStringValue) > 0, "Can't be empty");
        
        // Assert if string longer than 78 characters
        assert(countElements(decimalStringValue) <= 78, "Too large");
        
        // Assert if string has any characters that are not 0-9
        for character in decimalStringValue {
            switch character {
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                assert(true)
            default:
                assert(false, "Invalid character")
            }
            
        }
        
        // Pad zeros
        var paddedDecimalString = decimalStringValue
        
        for _ in 1...(78 - countElements(decimalStringValue)) {
            paddedDecimalString = "0" + paddedDecimalString;
        }

        
        assert(paddedDecimalString <= "115792089237316195423570985008687907853269984665640564039457584007913129639935", "Too large")
        
        var hexStringValue: String = BaseConverter.decToHex(decimalStringValue)
        
        if hexStringValue == "" {
            hexStringValue = "0"
        }
        
        self.init(hexStringValue: hexStringValue )
    }
    
    init(var hexStringValue: String) {
        // First we perform some sanity checks on the string. Then we chop it in 8 pieces and convert each to a UInt32.
        
        assert(countElements(hexStringValue) > 0, "Can't be empty");
        
        // Assert if string isn't too long
        assert(countElements(hexStringValue) <= 64, "Too large");
        
        
        hexStringValue = hexStringValue.uppercaseString;
        
        // Assert if string has any characters that are not 0-9 or A-F
        for character in hexStringValue {
            switch character {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F":
                assert(true)
            default:
                println("Invalid character: \( character)")
                assert(false, "Invalid character")
            }
            
        }
        
        // Pad zeros
        for _ in 1...(64 - countElements(hexStringValue)) {
            hexStringValue = "0" + hexStringValue;
        }
        
        var int1: UInt32 = 0
        var int2: UInt32 = 0
        var int3: UInt32 = 0
        var int4: UInt32 = 0
        var int5: UInt32 = 0
        var int6: UInt32 = 0
        var int7: UInt32 = 0
        var int8: UInt32 = 0
        
        var i = 0
        
        for char in hexStringValue {
            var increment: UInt32 = 0
            
            switch char {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                let stringChar: String = char + "";
                increment = UInt32(stringChar.toInt()!)
            case "A":
                increment = 10
            case "B":
                increment = 11
            case "C":
                increment = 12
            case "D":
                increment = 13
            case "E":
                increment = 14
            case "F":
                increment = 15
            default:
                assert(false, "Unexpected digit");
            }
            
            let incrementor: Int = 16^^(7 - (i % 8))
            increment = increment * UInt32(incrementor);
            
            switch i {
            case 0..8:
                int1 += UInt32(increment)
            case 8..16:
                int2 += increment
            case 16..24:
                int3 += increment
            case 24..32:
                int4 += increment
            case 32..40:
                int5 += increment
            case 40..48:
                int6 += increment
            case 48..56:
                int7 += increment
            case 56..64:
                int8 += increment
            default:
                break;
            }
            
            i++
        }
        
        self.init(mostSignificantOf8UInt32First: [int1, int2, int3, int4, int5, int6, int7, int8])
        

    }
    
    init (mostSignificantOf8UInt32First: UInt32[]) {
        assert(mostSignificantOf8UInt32First.count == 8, "8 UInt32's needed")
    
        self.part1 = mostSignificantOf8UInt32First[0]
        self.part2 = mostSignificantOf8UInt32First[1]
        self.part3 = mostSignificantOf8UInt32First[2]
        self.part4 = mostSignificantOf8UInt32First[3]
        self.part5 = mostSignificantOf8UInt32First[4]
        self.part6 = mostSignificantOf8UInt32First[5]
        self.part7 = mostSignificantOf8UInt32First[6]
        self.part8 = mostSignificantOf8UInt32First[7]

    }

}

func < (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.part1 < rhs.part1 || lhs.part2 < rhs.part2 || lhs.part3 < rhs.part3 || lhs.part4 < rhs.part4 || lhs.part5 < rhs.part5 || lhs.part6 < rhs.part6 || lhs.part7 < rhs.part7 || lhs.part8 < rhs.part8;
}

func == (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.part1 == rhs.part1 && lhs.part2 == rhs.part2 && lhs.part3 == rhs.part3 && lhs.part4 == rhs.part4 && lhs.part5 == rhs.part5 && lhs.part6 == rhs.part6 && lhs.part7 == rhs.part7 && lhs.part8 == rhs.part8;
}

func + (lhs: UInt256, rhs: UInt256) -> UInt256 {

    let sum8 = lhs.part8 &+ rhs.part8
    let sum7 = lhs.part7 &+ rhs.part7 + (sum8 < lhs.part8 ? 1 : 0) // Overflow
    let sum6 = lhs.part6 &+ rhs.part6 + (sum7 < lhs.part7 ? 1 : 0)
    let sum5 = lhs.part5 &+ rhs.part5 + (sum6 < lhs.part6 ? 1 : 0)
    let sum4 = lhs.part4 &+ rhs.part4 + (sum5 < lhs.part5 ? 1 : 0)
    let sum3 = lhs.part3 &+ rhs.part3 + (sum4 < lhs.part4 ? 1 : 0)
    let sum2 = lhs.part2 &+ rhs.part2 + (sum3 < lhs.part3 ? 1 : 0)
    let sum1 = lhs.part1  + rhs.part1 + (sum2 < lhs.part2 ? 1 : 0)

    
    return UInt256(mostSignificantOf8UInt32First: [sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8])
}

func - (lhs: UInt256, rhs: UInt256) -> UInt256 {
    
    let diff8 = lhs.part8 &- rhs.part8
    let diff7 = lhs.part7 &- rhs.part7 &- (diff8 > lhs.part8 ? 1 : 0) // Overflow
    let diff6 = lhs.part6 &- rhs.part6 &- (diff7 > lhs.part7 ? 1 : 0)
    let diff5 = lhs.part5 &- rhs.part5 &- (diff6 > lhs.part6 ? 1 : 0)
    let diff4 = lhs.part4 &- rhs.part4 &- (diff5 > lhs.part5 ? 1 : 0)
    let diff3 = lhs.part3 &- rhs.part3 &- (diff4 > lhs.part4 ? 1 : 0)
    let diff2 = lhs.part2 &- rhs.part2 &- (diff3 > lhs.part3 ? 1 : 0)
    let diff1 = lhs.part1  - rhs.part1 &- (diff2 > lhs.part2 ? 1 : 0)
    
    
    return UInt256(mostSignificantOf8UInt32First: [diff1, diff2, diff3, diff4, diff5, diff6, diff7, diff8])
}

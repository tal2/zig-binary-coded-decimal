const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const DecimalParsingErrors = Decimal128.DecimalParsingErrors;
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - representation adjustments - 1.0E+1" {
    var decimal128 = try Decimal128.fromNumericString("1.0E+1");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "10");
}

test "Decimal128 - representation adjustments - 1.0E1 (exponent with implicit sign)" {
    var decimal128 = try Decimal128.fromNumericString("1.0E1");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "10");
}

test "Decimal128 - representation adjustments - 1.0e1" {
    var decimal128 = try Decimal128.fromNumericString("1.0e1");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "10");
}

test "Decimal128 - representation adjustments - 1.0E-1" {
    var decimal128 = try Decimal128.fromNumericString("1.0E-1");
    const expected_encoded_bits: u128 = 0b0011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.10");
}

test "Decimal128 - representation adjustments - 1.0E-000000000000000000000000000000000000000001" {
    var decimal128 = try Decimal128.fromNumericString("1.0E-000000000000000000000000000000000000000001");
    const expected_encoded_bits: u128 = 0b0011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.10");
}

test "Decimal128 - representation adjustments - 10000000000000000000000000000000000 (35 digits)" {
    var decimal128 = try Decimal128.fromNumericString("10000000000000000000000000000000000");
    const expected_encoded_bits: u128 = 0b0011000001000010_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000E+34");
}

test "Decimal128 - representation adjustments - 1.0E+0" {
    var decimal128 = try Decimal128.fromNumericString("1.0E+0");
    const expected_encoded_bits: u128 = 0b0011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.0");
}

test "Decimal128 - representation adjustments - 11. (missing decimal after radix)" {
    var decimal128 = try Decimal128.fromNumericString("11.");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001011;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "11");
}

test "Decimal128 - representation adjustments - .1 (missing integer before radix)" {
    var decimal128 = try Decimal128.fromNumericString(".1");
    const expected_encoded_bits: u128 = 0b0011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.1");
}

test "Decimal128 - representation adjustments - .1E-1 (missing integer before radix)" {
    var decimal128 = try Decimal128.fromNumericString(".1E-1");
    const expected_encoded_bits: u128 = 0b0011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.01");
}

test "Decimal128 - representation adjustments - .1E-6 (missing integer before radix)" {
    var decimal128 = try Decimal128.fromNumericString(".1E-6");
    const expected_encoded_bits: u128 = 0b0011000000110010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1E-7");
}

test "Decimal128 - representation adjustments - .11E-6 (missing integer before radix)" {
    var decimal128 = try Decimal128.fromNumericString(".11E-6");
    const expected_encoded_bits: u128 = 0b0011000000110000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001011;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.1E-7");
}

test "Decimal128 - representation adjustments -  0.000000011111E+1 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("0.000000011111E+2");
    const expected_encoded_bits: u128 = 0b0011000000101100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0010101101100111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.0000011111");
}

test "Decimal128 - representation adjustments -  0.0000000011111E+2 (with exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("0.0000000011111E+2");
    const expected_encoded_bits: u128 = 0b0011000000101010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0010101101100111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.1111E-7");
}

test "Decimal128 - representation adjustments - 0.111 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("0.111");
    const expected_encoded_bits: u128 = 0b0011000000111010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001101111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.111");
}

test "Decimal128 - representation adjustments - 1.11E+2 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("1.11E+2");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001101111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "111");
}

test "Decimal128 - representation adjustments - 1.11E+3 (with exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("1.11E+3");
    const expected_encoded_bits: u128 = 0b0011000001000010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001101111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.11E+3");
}

test "Decimal128 - representation adjustments - 1.111E+4 (with exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("1.111E+4");
    const expected_encoded_bits: u128 = 0b0011000001000010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000010001010111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.111E+4");
}

test "Decimal128 - representation adjustments - 111.11 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("111.11");
    const expected_encoded_bits: u128 = 0b0011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0010101101100111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "111.11");
}

test "Decimal128 - representation adjustments - 111.111 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("111.111");
    const expected_encoded_bits: u128 = 0b0011000000111010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001_1011001000000111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "111.111");
}

test "Decimal128 - representation adjustments - 111.1111 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("111.1111");
    const expected_encoded_bits: u128 = 0b0011000000111000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000010000_1111010001000111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "111.1111");
}

test "Decimal128 - representation adjustments - 1111.11E-1 (without exponent notation)" {
    var decimal128 = try Decimal128.fromNumericString("1111.11E-1");
    const expected_encoded_bits: u128 = 0b0011000000111010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001_1011001000000111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "111.111");
}

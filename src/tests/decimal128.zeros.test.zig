const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const DecimalParsingErrors = Decimal128.DecimalParsingErrors;
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - zeros - 0" {
    var decimal128 = try Decimal128.fromNumericString("0");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0");
}

test "Decimal128 - zeros - -0" {
    var decimal128 = try Decimal128.fromNumericString("-0");
    const expected_encoded_bits: u128 = 0b1011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-0");
}

test "Decimal128 - zeros - +0" {
    var decimal128 = try Decimal128.fromNumericString("+0");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0");
}

test "Decimal128 - zeros - -0.0" {
    var decimal128 = try Decimal128.fromNumericString("-0.0");
    const expected_encoded_bits: u128 = 0b1011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-0.0");
}

test "Decimal128 - zeros - +0.0" {
    var decimal128 = try Decimal128.fromNumericString("+0.0");
    const expected_encoded_bits: u128 = 0b0011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.0");
}

test "Decimal128 - zeros - 0.00" {
    var decimal128 = try Decimal128.fromNumericString("0.00");
    const expected_encoded_bits: u128 = 0b0011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.00");
}

test "Decimal128 - zeros - 0001" {
    var decimal128 = try Decimal128.fromNumericString("0001");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1");
}

test "Decimal128 - zeros - +0001" {
    var decimal128 = try Decimal128.fromNumericString("+0001");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1");
}

test "Decimal128 - zeros - -0001" {
    var decimal128 = try Decimal128.fromNumericString("-0001");
    const expected_encoded_bits: u128 = 0b1011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-1");
}

test "Decimal128 - zeros - 0000000000000000000000000000000000001 (leading zeros, more than max digits)" {
    var decimal128 = try Decimal128.fromNumericString("0000000000000000000000000000000000001");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1");
}

test "Decimal128 - zeros - 1000000000000000000000000000000000 (34 digits)" {
    var decimal128 = try Decimal128.fromNumericString("1000000000000000000000000000000000");
    const expected_encoded_bits: u128 = 0b0011000001000000_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1000000000000000000000000000000000");
}

test "Decimal128 - zeros - 1.0000000000000000000000000000000000000000 (trailing zeros)" {
    var decimal128 = try Decimal128.fromNumericString("1.0000000000000000000000000000000000000000");
    const expected_encoded_bits: u128 = 0b0010111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000");
}

test "Decimal128 - zeros - 0.00000000001000000000000000000000000 (trailing zeros)" {
    var decimal128 = try Decimal128.fromNumericString("0.00000000001000000000000000000000000");
    const expected_encoded_bits: u128 = 0b0010111111111010_0000000000000000_0000000000000000_1101001111000010_0001101111001110_1100110011101101_1010000100000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000E-11");
}

test "Decimal128 - zeros - 1000000000000000000000000000000000000000000000000000000000000000000000000000000000" {
    var decimal128 = try Decimal128.fromNumericString("1000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    const expected_encoded_bits: u128 = 0b0011000010100000_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000E+81");
}

test "Decimal128 - zeros - -1.10 (keep representation)" {
    var decimal128 = try Decimal128.fromNumericString("-1.10");
    const expected_encoded_bits: u128 = 0b1011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001101110;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-1.10");
}

test "Decimal128 - zeros - -11.0 (keep representation)" {
    var decimal128 = try Decimal128.fromNumericString("-11.0");
    const expected_encoded_bits: u128 = 0b1011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001101110;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-11.0");
}

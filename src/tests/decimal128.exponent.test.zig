const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const DecimalParsingErrors = Decimal128.DecimalParsingErrors;
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - exponent - 1E+10" {
    var decimal128 = try Decimal128.fromNumericString("1E+10");
    const expected_encoded_bits: u128 = 0b0011000001010100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1E+10");
}

test "Decimal128 - exponent - 0.11e-1" {
    var decimal128 = try Decimal128.fromNumericString("0.11e-1");
    const expected_encoded_bits: u128 = 0b0011000000111010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001011;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.011");
}

test "Decimal128 - exponent - 0.11e-5" {
    var decimal128 = try Decimal128.fromNumericString("0.11e-5");
    const expected_encoded_bits: u128 = 0b0011000000110010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001011;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.0000011");
}

test "Decimal128 - exponent - 0.11e-6" {
    var decimal128 = try Decimal128.fromNumericString("0.11e-6");
    const expected_encoded_bits: u128 = 0b0011000000110000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001011;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.1E-7");
}

test "Decimal128 - exponent - 0E+100" {
    var decimal128 = try Decimal128.fromNumericString("0E+100");
    const expected_encoded_bits: u128 = 0b0011000100001000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0E+100");
}

test "Decimal128 - exponent - 0E-100" {
    var decimal128 = try Decimal128.fromNumericString("0E-100");
    const expected_encoded_bits: u128 = 0b0010111101111000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0E-100");
}

test "Decimal128 1E-6176" {
    var decimal128 = try Decimal128.fromNumericString("1E-6176");
    const expected_encoded_bits: u128 = 0b0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1E-6176");
}

test "Decimal128 -1E-6176" {
    var decimal128 = try Decimal128.fromNumericString("-1E-6176");
    const expected_encoded_bits: u128 = 0b1000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "-1E-6176");
}

test "Decimal128 1.0E-6176" {
    var decimal128 = try Decimal128.fromNumericString("1.0E-6176");
    const expected_encoded_bits: u128 = 0b0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1E-6176");
}

test "Decimal128 1.00E-6176" {
    var decimal128 = try Decimal128.fromNumericString("1.00E-6176");
    const expected_encoded_bits: u128 = 0b0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1E-6176");
}

test "Decimal128 1.0E-6177" {
    var decimal128 = try Decimal128.fromNumericString("1.0E-6177");
    const expected_encoded_bits: u128 = 0b0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0E-6176");
}

test "Decimal128 1.0E+6112 (max exponent)" {
    var decimal128 = try Decimal128.fromNumericString("1.0E+6112");
    const expected_encoded_bits: u128 = 0b0101111111111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.0E+6112");
    try std.testing.expect(!decimal128.signal.clamped);
}

test "Decimal128 1.0E+6113 (clamping)" {
    var decimal128 = try Decimal128.fromNumericString("1.0E+6113");
    const expected_encoded_bits: u128 = 0b0101111111111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001100100;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.00E+6113");
    try std.testing.expect(decimal128.signal.clamped);
}

test "Decimal128 1.0E+6145 (clamping)" {
    var decimal128 = try Decimal128.fromNumericString("1.0E+6145");
    const expected_encoded_bits: u128 = 0b0101111111111111_1110110100001001_1011111010101101_1000011111000000_0011011110001101_1000111001100100_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.0000000000000000000000000000000000E+6145");
    try std.testing.expect(decimal128.signal.clamped);
}

test "Decimal128 1.0E+6146 (overflow)" {
    const decimal128_error_union = Decimal128.fromNumericString("1.0E+6146");

    try std.testing.expectError(DecimalParsingErrors.Overflow, decimal128_error_union);
}

test "Decimal128 1.00E+6143 (clamping, almost max exponent)" {
    var decimal128 = try Decimal128.fromNumericString("1.00E+6143");
    const expected_encoded_bits: u128 = 0b0101111111111110_0000010011101110_0010110101101101_0100000101011011_1000010110101100_1110111110000001_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.00000000000000000000000000000000E+6143");
    try std.testing.expect(decimal128.signal.clamped);
}

test "Decimal128 1.0E+6144 (clamping, max exponent)" {
    var decimal128 = try Decimal128.fromNumericString("1.0E+6144");
    const expected_encoded_bits: u128 = 0b0101111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000E+6144");
    try std.testing.expect(decimal128.signal.clamped);
}

test "Decimal128 1.0E-6143" {
    var decimal128 = try Decimal128.fromNumericString("1.0E-6143");
    const expected_encoded_bits: u128 = 0b0000000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.0E-6143");
}

test "Decimal128 1E-6143" {
    var decimal128 = try Decimal128.fromNumericString("1E-6143");
    const expected_encoded_bits: u128 = 0b0000000001000010_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1E-6143");
}

test "Decimal128 10000000000000000000000000000000000E+6111 (overflow)" {
    const decimal128_error_union = Decimal128.fromNumericString("10000000000000000000000000000000000E+6111");

    try std.testing.expectError(DecimalParsingErrors.Overflow, decimal128_error_union);
}

test "Decimal128 1000000000000000000000000000000000E-6143 (min exponent)" {
    var decimal128 = try Decimal128.fromNumericString("1000000000000000000000000000000000E-6143");
    const expected_encoded_bits: u128 = 0b0000000001000010_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000E-6110");
}

test "Decimal128 1000000000000000000000000000000000E-6144 (subnormal)" {
    var decimal128 = try Decimal128.fromNumericString("1000000000000000000000000000000000E-6144");
    const expected_encoded_bits: u128 = 0b0000000001000000_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000E-6111");
}

test "Decimal128 1.00000000000000000000000000000000E+6143" {
    var decimal128 = try Decimal128.fromNumericString("1.00000000000000000000000000000000E+6143");
    const expected_encoded_bits: u128 = 0b0101111111111110_0000010011101110_0010110101101101_0100000101011011_1000010110101100_1110111110000001_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.00000000000000000000000000000000E+6143");
}

test "Decimal128 9.999999999999999999999999999999999E-6143" {
    var decimal128 = try Decimal128.fromNumericString("9.999999999999999999999999999999999E-6143");
    const expected_encoded_bits: u128 = 0b0000000000000001_1110110100001001_1011111010101101_1000011111000000_0011011110001101_1000111001100011_1111111111111111_1111111111111111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "9.999999999999999999999999999999999E-6143");
}

test "Decimal128 0.000001111111111111111111111111111111111" {
    var decimal128 = try Decimal128.fromNumericString("0.000001111111111111111111111111111111111");
    const expected_encoded_bits: u128 = 0b0010111111110010_0011011011001000_0011000110100001_1000000011011100_0111011111110011_0100100010110101_1100011100011100_0111000111000111;

    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.000001111111111111111111111111111111111");
}

test "Decimal128 0.000001111111111111111111111111111111111E-6137 (adjusted exponent limit)" {
    var decimal128 = try Decimal128.fromNumericString("0.000001111111111111111111111111111111111E-6137");
    const expected_encoded_bits: u128 = 0b0000000000000000_0011011011001000_0011000110100001_1000000011011100_0111011111110011_0100100010110101_1100011100011100_0111000111000111;

    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.111111111111111111111111111111111E-6143");
}

test "Decimal128 0.000001111111111111111111111111111111111E-6138 (adjusted exponent limit)" {
    var decimal128 = try Decimal128.fromNumericString("0.000001111111111111111111111111111111111E-6138");
    const expected_encoded_bits: u128 = 0b0000000000000000_0000010101111010_0110101101011100_1111001101001001_0011111100110001_1110110110101011_1100011100011100_0111000111000111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.11111111111111111111111111111111E-6144");
}

test "Decimal128 0.000001111111111111111111111111111111111E-613800 (adjusted exponent limit)" {
    var decimal128 = try Decimal128.fromNumericString("0.000001111111111111111111111111111111111E-613800");
    const expected_encoded_bits: u128 = 0b0000000000000000_0011011011001000_0011000110100001_1000000011011100_0111011111110011_0100100010110101_1100011100011100_0111000111000111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.111111111111111111111111111111111E-6143");
}

test "Decimal128 1.1111111111111111111111111111111112E-6 (adjusted exponent)" {
    var decimal128 = try Decimal128.fromNumericString("1.1111111111111111111111111111111112E-6");
    const expected_encoded_bits: u128 = 0b0010111111110010_0011011011001000_0011000110100001_1000000011011100_0111011111110011_0100100010110101_1100011100011100_0111000111000111;

    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.000001111111111111111111111111111111111");
}

test "Decimal128 1.111111111111111111111111111111112E-6 (adjusted exponent)" {
    var decimal128 = try Decimal128.fromNumericString("1.111111111111111111111111111111112E-6");
    const expected_encoded_bits: u128 = 0b0010111111110010_0011011011001000_0011000110100001_1000000011011100_0111011111110011_0100100010110101_1100011100011100_0111000111001000;

    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "0.000001111111111111111111111111111111112");
}

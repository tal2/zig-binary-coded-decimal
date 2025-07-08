const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - basic - 1" {
    var decimal128 = try Decimal128.fromNumericString("1");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
}

test "Decimal128 - basic - -1" {
    var decimal128 = try Decimal128.fromNumericString("-1");
    const expected_encoded_bits: u128 = 0b1011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "-1");
}

test "Decimal128 - basic - 1.0" {
    var decimal128 = try Decimal128.fromNumericString("1.0");
    const expected_encoded_bits: u128 = 0b0011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.0");
}

test "Decimal128 - basic - -1.0" {
    var decimal128 = try Decimal128.fromNumericString("-1.0");
    const expected_encoded_bits: u128 = 0b1011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000001010;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-1.0");
}

test "Decimal128 - basic - 1.00" {
    var decimal128 = try Decimal128.fromNumericString("1.00");
    const expected_encoded_bits: u128 = 0b0011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001100100;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.00");
}

test "Decimal128 - basic - -1.00" {
    var decimal128 = try Decimal128.fromNumericString("-1.00");
    const expected_encoded_bits: u128 = 0b1011000000111100_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000001100100;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-1.00");
}

test "Decimal128 - basic - 2.0" {
    var decimal128 = try Decimal128.fromNumericString("2.0");
    const expected_encoded_bits: u128 = 0b0011000000111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000010100;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "2.0");
}

test "Decimal128 - basic - 20" {
    var decimal128 = try Decimal128.fromNumericString("20");
    const expected_encoded_bits: u128 = 0b0011000001000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000010100;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "20");
}

test "Decimal128 - basic - 9999999999999999999999999999999999" {
    var decimal128 = try Decimal128.fromNumericString("9999999999999999999999999999999999");
    const expected_encoded_bits: u128 = 0b0011000001000001_1110110100001001_1011111010101101_1000011111000000_0011011110001101_1000111001100011_1111111111111111_1111111111111111;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "9999999999999999999999999999999999");
}

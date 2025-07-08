const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const DecimalParsingErrors = Decimal128.DecimalParsingErrors;
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - rounding - 1.000000000000000000000000000000005" {
    var decimal128 = try Decimal128.fromNumericString("1.000000000000000000000000000000005");
    const expected_encoded_bits: u128 = 0b0010111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000101;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000005");
}

test "Decimal128 - rounding - -1.000000000000000000000000000000005" {
    var decimal128 = try Decimal128.fromNumericString("-1.000000000000000000000000000000005");
    const expected_encoded_bits: u128 = 0b1010111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000101;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try expectDecimal128ToStringEqual(&decimal128, "-1.000000000000000000000000000000005");
}

test "Decimal128 - rounding - 1.0000000000000000000000000000000050" {
    var decimal128 = try Decimal128.fromNumericString("1.0000000000000000000000000000000050");
    const expected_encoded_bits: u128 = 0b0010111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000101;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000005");
}

test "Decimal128 - rounding - 1.0000000000000000000000000000000009" {
    var decimal128 = try Decimal128.fromNumericString("1.0000000000000000000000000000000009");
    const expected_encoded_bits: u128 = 0b0010111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(decimal128.signal.rounded);
    try std.testing.expect(decimal128.signal.inexact);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000");
}

test "Decimal128 - rounding - 1.000000000000000000000000000000009" {
    var decimal128 = try Decimal128.fromNumericString("1.000000000000000000000000000000009");
    const expected_encoded_bits: u128 = 0b0010111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000001001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.rounded);
    try std.testing.expect(!decimal128.signal.inexact);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000009");
}

test "Decimal128 - rounding - 10000000000000000000000000000000000E+6110" {
    var decimal128 = try Decimal128.fromNumericString("10000000000000000000000000000000000E+6110");
    const expected_encoded_bits: u128 = 0b0101111111111110_0011000101001101_1100011001000100_1000110110010011_0011100011000001_0101101100001010_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1.000000000000000000000000000000000E+6144");
}

test "Decimal128 - rounding - -1E-6177" {
    var decimal128 = try Decimal128.fromNumericString("-1E-6177");
    const expected_encoded_bits: u128 = 0b1000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, false, false);
    try std.testing.expect(decimal128.signal.underflow);
    try std.testing.expect(decimal128.signal.inexact);
    try std.testing.expect(decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "-1E-6176");
}

test "Decimal128 - rounding - 1E-6177" {
    var decimal128 = try Decimal128.fromNumericString("1E-6177");
    const expected_encoded_bits: u128 = 0b0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, false, false);
    try std.testing.expect(decimal128.signal.underflow);
    try std.testing.expect(decimal128.signal.inexact);
    try std.testing.expect(decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(decimal128.signal.rounded);
    try expectDecimal128ToStringEqual(&decimal128, "1E-6176");
}

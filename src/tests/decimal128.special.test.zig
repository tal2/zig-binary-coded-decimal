const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const DecimalParsingErrors = Decimal128.DecimalParsingErrors;
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - special - NaN from string" {
    var decimal128 = try Decimal128.fromNumericString("NaN");

    try std.testing.expect(decimal128.isNaN());
    try expectDecimal128ToStringEqual(&decimal128, "NaN");
}

test "Decimal128 - special - sNaN from string" {
    var decimal128 = try Decimal128.fromNumericString("sNaN");

    try std.testing.expect(decimal128.isNaN());
    try expectDecimal128ToStringEqual(&decimal128, "NaN");
}

test "Decimal128 - special - Inf (positive infinity)" {
    var decimal128 = try Decimal128.fromNumericString("Inf");
    const expected_encoded_bits: u128 = 0b0111100000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, true, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);

    try expectDecimal128ToStringEqual(&decimal128, "Infinity");
}

test "Decimal128 - special - Infinity (positive infinity)" {
    var decimal128 = try Decimal128.fromNumericString("Infinity");
    const expected_encoded_bits: u128 = 0b0111100000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, false, true, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);

    try expectDecimal128ToStringEqual(&decimal128, "Infinity");
}

test "Decimal128 - special - iNf (inf case-insensitive)" {
    var decimal128 = try Decimal128.fromNumericString("iNf");

    try std.testing.expect(!decimal128.isNegative());
    try std.testing.expect(decimal128.isInfinite());
    try std.testing.expect(!decimal128.isNaN());

    try expectDecimal128ToStringEqual(&decimal128, "Infinity");
}

test "Decimal128 - special - -iNf (negative inf case-insensitive)" {
    var decimal128 = try Decimal128.fromNumericString("-iNf");

    try std.testing.expect(decimal128.isNegative());
    try std.testing.expect(decimal128.isInfinite());
    try std.testing.expect(!decimal128.isNaN());

    try expectDecimal128ToStringEqual(&decimal128, "-Infinity");
}

test "Decimal128 - special - iNFiniTy (infinity case-insensitive)" {
    var decimal128 = try Decimal128.fromNumericString("iNFiniTy");

    try std.testing.expect(!decimal128.isNegative());
    try std.testing.expect(decimal128.isInfinite());
    try std.testing.expect(!decimal128.isNaN());

    try expectDecimal128ToStringEqual(&decimal128, "Infinity");
}

test "Decimal128 - special - -iNFiniTy (negative infinity case-insensitive)" {
    var decimal128 = try Decimal128.fromNumericString("-iNFiniTy");

    try std.testing.expect(decimal128.isNegative());
    try std.testing.expect(decimal128.isInfinite());
    try std.testing.expect(!decimal128.isNaN());

    try expectDecimal128ToStringEqual(&decimal128, "-Infinity");
}

test "Decimal128 - special - -Inf (negative infinite)" {
    var decimal128 = try Decimal128.fromNumericString("-Inf");
    const expected_encoded_bits: u128 = 0b1111100000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, true, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);

    try expectDecimal128ToStringEqual(&decimal128, "-Infinity");
}

test "Decimal128 - special - -Infinity (negative infinity)" {
    var decimal128 = try Decimal128.fromNumericString("-Infinity");
    const expected_encoded_bits: u128 = 0b1111100000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;

    try expectDecimal128(&decimal128, expected_encoded_bits, true, true, false);
    try std.testing.expect(!decimal128.signal.underflow);
    try std.testing.expect(!decimal128.signal.inexact);
    try std.testing.expect(!decimal128.signal.subnormal);
    try std.testing.expect(!decimal128.signal.clamped);
    try std.testing.expect(!decimal128.signal.division_by_zero);
    try std.testing.expect(!decimal128.signal.invalid_operation);
    try std.testing.expect(!decimal128.signal.overflow);
    try std.testing.expect(!decimal128.signal.rounded);

    try expectDecimal128ToStringEqual(&decimal128, "-Infinity");
}

test "Decimal128 - special - invalid strings - 'i' (not infinity)" {
    const decimal128_or_error = Decimal128.fromNumericString("i");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'I' (not infinity)" {
    const decimal128_or_error = Decimal128.fromNumericString("I");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - '-i' (not infinity)" {
    const decimal128_or_error = Decimal128.fromNumericString("-i");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'n' (not NaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("n");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'N' (not NaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("N");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - '-N' (not NaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("-N");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 's' (not sNaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("S");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'S' (not sNaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("S");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - '-s' (not sNaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("-s");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'Inf123' (not inf)" {
    const decimal128_or_error = Decimal128.fromNumericString("Inf123");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'Infinity123' (not infinity)" {
    const decimal128_or_error = Decimal128.fromNumericString("Infinity123");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'nan1' (not NaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("nan1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - special - invalid strings - 'snan1' (not sNaN)" {
    const decimal128_or_error = Decimal128.fromNumericString("snan1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

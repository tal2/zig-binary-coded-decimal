const std = @import("std");
const Decimal128 = @import("../decimal128.zig");
const DecimalParsingErrors = Decimal128.DecimalParsingErrors;
const test_utils = @import("test-util.zig");
const expectDecimal128 = test_utils.expectDecimal128;
const expectDecimal128ToStringEqual = test_utils.expectDecimal128ToStringEqual;

test "Decimal128 - invalid strings - '' (empty string)" {
    const decimal128_or_error = Decimal128.fromNumericString("");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericStringLength, decimal128_or_error);
}

test "Decimal128 - invalid strings - 'asdf'" {
    const decimal128_or_error = Decimal128.fromNumericString("asdf");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - 'a'" {
    const decimal128_or_error = Decimal128.fromNumericString("a");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - ' ' (empty space)" {
    const decimal128_or_error = Decimal128.fromNumericString(" ");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - ' 1'" {
    const decimal128_or_error = Decimal128.fromNumericString(" 1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - ' -1'" {
    const decimal128_or_error = Decimal128.fromNumericString(" -1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1 '" {
    const decimal128_or_error = Decimal128.fromNumericString("1 ");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '+ 1'" {
    const decimal128_or_error = Decimal128.fromNumericString("+ 1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '- 1'" {
    const decimal128_or_error = Decimal128.fromNumericString("- 1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1 1'" {
    const decimal128_or_error = Decimal128.fromNumericString("1 1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - 1e" {
    const decimal128_or_error = Decimal128.fromNumericString("1e");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - 1E" {
    const decimal128_or_error = Decimal128.fromNumericString("1E");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - E01" {
    const decimal128_or_error = Decimal128.fromNumericString("E01");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - E+1" {
    const decimal128_or_error = Decimal128.fromNumericString("E+1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - +E1" {
    const decimal128_or_error = Decimal128.fromNumericString("+E1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - E-1" {
    const decimal128_or_error = Decimal128.fromNumericString("E-1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - -E1" {
    const decimal128_or_error = Decimal128.fromNumericString("-E1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - 'E'" {
    const decimal128_or_error = Decimal128.fromNumericString("E");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '+E'" {
    const decimal128_or_error = Decimal128.fromNumericString("+E");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '-E'" {
    const decimal128_or_error = Decimal128.fromNumericString("-E");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '.E'" {
    const decimal128_or_error = Decimal128.fromNumericString(".E");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '.'" {
    const decimal128_or_error = Decimal128.fromNumericString(".");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '+.'" {
    const decimal128_or_error = Decimal128.fromNumericString("+.");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '-.'" {
    const decimal128_or_error = Decimal128.fromNumericString("-.");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - 1.." {
    const decimal128_or_error = Decimal128.fromNumericString("1..");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - ..1" {
    const decimal128_or_error = Decimal128.fromNumericString("..1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1..1'" {
    const decimal128_or_error = Decimal128.fromNumericString("1..1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1.1'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1.1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1.'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1.");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '+-1'" {
    const decimal128_or_error = Decimal128.fromNumericString("+-1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '-+1'" {
    const decimal128_or_error = Decimal128.fromNumericString("-+1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '--1'" {
    const decimal128_or_error = Decimal128.fromNumericString("--1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1-'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1-");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1+'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1+");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1E+-1'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1E+-1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1E--1'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1E--1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1E++1'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1E++1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - 'a1.1'" {
    const decimal128_or_error = Decimal128.fromNumericString("a1.1");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1a'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1a");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1E+a'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1E+a");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

test "Decimal128 - invalid strings - '1.1E+0a0'" {
    const decimal128_or_error = Decimal128.fromNumericString("1.1E+0a0");

    try std.testing.expectError(DecimalParsingErrors.InvalidNumericString, decimal128_or_error);
}

const std = @import("std");
const Decimal128 = @import("../decimal128.zig");

pub fn expectDecimal128(decimal128: *Decimal128, expected_encoded_bits: u128, comptime is_negative: bool, comptime is_infinite: bool, comptime is_nan: bool) !void {
    if (decimal128.encoded_bits != expected_encoded_bits) {
        std.debug.print("decimal128.encoded_bits: {b:0>128}\n", .{decimal128.encoded_bits});
        std.debug.print("expected_encoded_bits:   {b:0>128}\n", .{expected_encoded_bits});
    }
    try std.testing.expect(decimal128.encoded_bits == expected_encoded_bits);
    try std.testing.expect(decimal128.isNegative() == is_negative);
    try std.testing.expect(decimal128.isInfinite() == is_infinite);
    try std.testing.expect(decimal128.isNaN() == is_nan);
}

pub fn expectDecimal128ToStringEqual(decimal128: *Decimal128, comptime expected_string: []const u8) !void {
    var buffer: [42]u8 = undefined;
    const result = try decimal128.toString(buffer[0..]);
    try std.testing.expectEqualStrings(expected_string, result[0..]);

    try std.testing.expectEqual(expected_string.len, result.len);
}

const std = @import("std");
const math = std.math;
const clamp = math.clamp;

pub const Decimal128 = @This();

signal: ContextSignal = .{},
encoded_bits: u128 = undefined,

pub const size_in_bytes = format_bits_length / 8;

const format_bits_length = 128;
const coefficient_max_digits_count = 34;
const exponent_total_bits_length = 14;
const exponent_continuation_bits_length = 12;

const precision = coefficient_max_digits_count;
const exponent_limit: comptime_int = 3 * math.pow(u16, 2, exponent_continuation_bits_length) - 1;
const exponent_maximum: comptime_int = exponent_limit / 2 + 1;
const exponent_minimum: comptime_int = -exponent_limit / 2;
const exponent_tiny: comptime_int = exponent_minimum - (precision - 1); // Appendix A  https://speleotrove.com/decimal/dbcalc.html#calc
const exponent_bias = -exponent_tiny;
const exponent_bias_bit_shift: comptime_int = (format_bits_length - exponent_total_bits_length - 1);

const exponent_bit_mask: u128 = 0b0111111111111110_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
const coefficient_bit_mask: u128 = 0b0000000000000001_1111111111111111_1111111111111111_1111111111111111_1111111111111111_1111111111111111_1111111111111111_1111111111111111;

const special_value_bits: u128 = 0b0111000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
const special_value_bits_nan: u128 = 0b0111110000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
const special_value_bits_negative_nan: u128 = 0b1111110000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
const special_value_bits_infinite: u128 = 0b0111100000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
const special_value_bits_negative_infinite: u128 = 0b1111100000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
const tiny: u128 = 0b0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000001;
const sign_bit: u128 = 0b1 << (format_bits_length - 1);
const biased_exponent_zero: u128 = exponent_bias << exponent_bias_bit_shift;

const max_valid_numeric_string_length = exponent_maximum + coefficient_max_digits_count + 4; // 4 is for the sign, radix, and exponent sign & indicator

const ContextSignal = packed struct {
    clamped: bool = false,
    division_by_zero: bool = false,
    inexact: bool = false,
    invalid_operation: bool = false,
    overflow: bool = false,
    rounded: bool = false,
    subnormal: bool = false,
    underflow: bool = false,
};

pub const Context = struct {
    precision: u16 = 34,
    signal: ContextSignal = undefined,
};

pub const DecimalParsingErrors = error{
    InvalidNumericString,
    InvalidNumericStringLength,
    Overflow,
    Underflow,
};

pub fn fromNumericString(numeric_string: []const u8) DecimalParsingErrors!Decimal128 {
    return fromNumericStringWithRadix(numeric_string, '.');
}

pub fn fromNumericStringWithRadix(numeric_string: []const u8, comptime radix: u8) DecimalParsingErrors!Decimal128 {
    const len: usize = numeric_string.len;

    if (len == 0 or len > max_valid_numeric_string_length) {
        return DecimalParsingErrors.InvalidNumericStringLength;
    }

    var pos: usize = 0;

    const is_negative: bool = numeric_string[0] == '-';

    if (is_negative or numeric_string[0] == '+') {
        pos += 1;
    }

    switch (numeric_string[pos]) {
        's', 'S' => {
            const snan_length: comptime_int = "sNaN".len;
            if (numeric_string.len == pos + snan_length and std.ascii.eqlIgnoreCase(numeric_string[pos .. pos + snan_length], "sNaN")) {
                return createNaN(is_negative);
            }

            return DecimalParsingErrors.InvalidNumericString;
        },
        'N', 'n' => {
            const nan_length: comptime_int = "NaN".len;
            if (numeric_string.len == pos + nan_length and std.ascii.eqlIgnoreCase(numeric_string[pos .. pos + nan_length], "NaN")) {
                return createNaN(is_negative);
            }

            return DecimalParsingErrors.InvalidNumericString;
        },
        'I', 'i' => {
            const inf_length: comptime_int = "inf".len;
            if (numeric_string.len == pos + inf_length and std.ascii.eqlIgnoreCase(numeric_string[pos .. pos + inf_length], "inf"))
                return createInfinite(is_negative);
            const infinity_length: comptime_int = "infinity".len;
            if (numeric_string.len == pos + infinity_length and std.ascii.eqlIgnoreCase(numeric_string[pos .. pos + infinity_length], "infinity"))
                return createInfinite(is_negative);
            return DecimalParsingErrors.InvalidNumericString;
        },
        else => {
            // continue
        },
    }

    var integer_start_position: usize = 0;
    var integer_end_position: usize = 0;
    var decimal_start_position: usize = 0;
    var decimal_end_position: usize = 0;
    var exponent_unsigned: u128 = 0;
    var has_exponent = false;
    var has_radix = false;

    const has_leading_zeros = numeric_string[pos] == '0';

    while (pos < len and numeric_string[pos] == '0') : (pos += 1) {
        // skip leading zeros
    }

    if (pos == len) {
        const encoded_zero = sign_bit * @intFromBool(is_negative) | biased_exponent_zero;
        return Decimal128{
            .encoded_bits = encoded_zero,
        };
    }

    var is_integer_bigger_than_zero = false;
    if (numeric_string[pos] == '.') {
        has_radix = true;
        pos += 1;
        if (pos == len) {
            if (has_leading_zeros) {
                const encoded_zero = sign_bit * @intFromBool(is_negative) | biased_exponent_zero;
                return Decimal128{
                    .encoded_bits = encoded_zero,
                };
            } else {
                return DecimalParsingErrors.InvalidNumericString;
            }
        }
    } else {
        integer_start_position = pos;

        while (pos < len) : (pos += 1) {
            const c = numeric_string[pos];

            switch (c) {
                '0' => {},
                '1'...'9' => {
                    is_integer_bigger_than_zero = true;
                },
                'e', 'E' => {
                    integer_end_position = pos;
                    has_exponent = true;
                    pos += 1;

                    if (pos == len or (!has_leading_zeros and pos == integer_start_position + 1)) return DecimalParsingErrors.InvalidNumericString;
                    break;
                },
                else => {
                    if (c == radix) {
                        integer_end_position = pos;
                        has_radix = true;
                        pos += 1;
                        break;
                    }

                    return DecimalParsingErrors.InvalidNumericString;
                },
            }
        }
    }

    var is_exponent_positive: u1 = 1;
    var trailing_zeros_count: usize = 0;
    var decimal_leading_zeros_count: u128 = 0;
    if (pos != len) {
        if (has_radix) {
            if (is_integer_bigger_than_zero == false) {
                while (pos < len) : (pos += 1) {
                    const c = numeric_string[pos];
                    if (c != '0') break;
                    decimal_leading_zeros_count += 1;
                }
            }
            decimal_start_position = pos;

            while (pos < len) : (pos += 1) {
                const c = numeric_string[pos];
                switch (c) {
                    '0' => {
                        trailing_zeros_count += 1;
                    },
                    '1'...'9' => {
                        trailing_zeros_count = 0;
                    },
                    'e', 'E' => {
                        has_exponent = true;
                        pos += 1;
                        break;
                    },
                    else => {
                        return DecimalParsingErrors.InvalidNumericString;
                    },
                }
            }
            decimal_end_position = pos - 1;
        }

        if (has_exponent) {
            if (pos == len) return DecimalParsingErrors.InvalidNumericString;

            if (numeric_string[pos] == '+') {
                pos += 1;
            } else {
                if (numeric_string[pos] == '-') {
                    pos += 1;
                    is_exponent_positive = 0;
                }
            }

            if (pos == len) return DecimalParsingErrors.InvalidNumericString;

            while (pos < len) : (pos += 1) {
                const c: u8 = numeric_string[pos];

                switch (c) {
                    '0' => {
                        exponent_unsigned = exponent_unsigned * 10;
                    },
                    '1'...'9' => {
                        const exponent_digit: u8 = c - '0';
                        exponent_unsigned = exponent_unsigned * 10 + exponent_digit;
                    },
                    else => {
                        return DecimalParsingErrors.InvalidNumericString;
                    },
                }
            }
        } else {
            decimal_end_position = len;
        }
    } else {
        if (integer_end_position == 0) integer_end_position = len;
    }

    const integer_string_number_of_digits = integer_end_position - integer_start_position;
    const extra_integer_digits_diff, const has_no_extra_integer_digits = @subWithOverflow(integer_string_number_of_digits, coefficient_max_digits_count);
    const least_significant_digits_count: usize = ~has_no_extra_integer_digits * extra_integer_digits_diff;

    const decimal_string_length = decimal_end_position - decimal_start_position;
    const decimal_places_adjusted = clamp(decimal_end_position - decimal_start_position, 0, coefficient_max_digits_count - @as(u8, @intFromBool(is_integer_bigger_than_zero)));

    if (is_exponent_positive != 0 and exponent_unsigned > exponent_maximum + decimal_places_adjusted) {
        return DecimalParsingErrors.Overflow;
    }

    var exponent_over_max_to_coefficient: u128 = 0;
    const decimal_start_position_adjusted = decimal_start_position;
    var underflow_bit: u1 = 0;
    var exponent_biased: u128 = 0;

    if (is_exponent_positive != 0) {
        exponent_unsigned += least_significant_digits_count;

        exponent_unsigned, const exponent_overflow = @subWithOverflow(exponent_unsigned, decimal_places_adjusted + decimal_leading_zeros_count);
        if (exponent_overflow != 0) {
            exponent_unsigned = ~exponent_unsigned + exponent_overflow;
            is_exponent_positive = 0;
            exponent_biased = (exponent_bias - exponent_unsigned) << exponent_bias_bit_shift;
        } else {
            if (exponent_unsigned <= (exponent_limit - exponent_bias)) {
                exponent_biased = (exponent_bias + exponent_unsigned) << exponent_bias_bit_shift;
            } else {
                exponent_over_max_to_coefficient = (exponent_unsigned + exponent_bias) - exponent_limit;
                if (exponent_over_max_to_coefficient + integer_string_number_of_digits + decimal_places_adjusted > coefficient_max_digits_count + 1) {
                    return DecimalParsingErrors.Overflow;
                }
                exponent_biased = (exponent_limit) << exponent_bias_bit_shift;
            }
        }
    } else {
        if (exponent_unsigned > -exponent_tiny and is_negative == false) {
            if (exponent_unsigned < 0x3fff) {
                return Decimal128{
                    .signal = .{ .subnormal = true, .underflow = true, .inexact = true, .rounded = true },
                    .encoded_bits = if (decimal_places_adjusted > 0) 0 else tiny,
                };
            }

            exponent_unsigned = -exponent_tiny;
            underflow_bit = 1;
            exponent_biased = 0;
        } else {
            exponent_unsigned += decimal_leading_zeros_count + decimal_places_adjusted;
            exponent_unsigned -= least_significant_digits_count;
            exponent_biased, underflow_bit = @subWithOverflow(exponent_bias, exponent_unsigned);
            exponent_biased = if (underflow_bit != 0) 0 else exponent_biased << exponent_bias_bit_shift;
        }
    }

    var signal: ContextSignal = .{
        .underflow = underflow_bit != 0,
    };

    const decimal_places_to_trim: usize = @min(coefficient_max_digits_count, @as(usize, @intCast(exponent_unsigned -| exponent_bias)));

    var significand: u128 = 0;

    var integer_part_adjusted_length: usize = 0;
    if (is_integer_bigger_than_zero) {
        const integer_part_adjusted_end_position = clamp(integer_end_position, integer_start_position, integer_start_position + coefficient_max_digits_count);
        integer_part_adjusted_length = integer_part_adjusted_end_position - integer_start_position;

        for (integer_start_position..integer_part_adjusted_end_position) |c| {
            significand = significand * 10 + numeric_string[c] - '0';
        }
    }

    const coefficient_length = @min(coefficient_max_digits_count, integer_part_adjusted_length + decimal_end_position - decimal_start_position_adjusted - decimal_places_to_trim);
    const max_decimal_end_position = decimal_start_position_adjusted + coefficient_length -| @intFromBool(is_integer_bigger_than_zero);

    const decimal_end_position_adjusted: usize = clamp(decimal_end_position, decimal_start_position_adjusted, max_decimal_end_position);

    for (decimal_start_position_adjusted..decimal_end_position_adjusted) |c| {
        significand = significand * 10 + numeric_string[c] - '0';
    }

    // clamping
    if (coefficient_length < coefficient_max_digits_count and exponent_over_max_to_coefficient > 0) {
        signal.clamped = true;
        significand = significand * math.pow(u128, 10, exponent_over_max_to_coefficient);
    }

    // rounding
    if (decimal_end_position > decimal_end_position_adjusted and decimal_end_position_adjusted > decimal_start_position_adjusted) {
        signal.rounded = true;
        signal.inexact = decimal_end_position - decimal_end_position_adjusted > trailing_zeros_count;
        const last_digit = numeric_string[decimal_end_position_adjusted - 1] - '0';
        const next_digit = numeric_string[decimal_end_position_adjusted] - '0';
        if (last_digit >= 5 and next_digit >= 5) {
            significand += 1;
        }
    }

    signal.subnormal = is_exponent_positive == 0 and exponent_unsigned > -exponent_minimum;
    signal.inexact = signal.inexact or signal.underflow;
    signal.rounded = signal.rounded or signal.underflow or (integer_string_number_of_digits + decimal_string_length) > coefficient_max_digits_count;

    return Decimal128{
        .signal = signal,
        .encoded_bits = sign_bit * @intFromBool(is_negative) | significand | exponent_biased,
    };
}

pub fn readAndEncode(reader: anytype, writer: anytype) !void {
    var encoded_bits: u128 = 0;
    var i: u7 = 0;
    while (i < 16) : (i += 1) {
        const b = try reader.readByte();
        encoded_bits |= @as(u128, @intCast(b)) << i * 8;
    }

    try writeEncodedDecimal128AsString(encoded_bits, writer);
}

pub fn read(reader: anytype) !Decimal128 {
    var encoded_bits: u128 = 0;
    var i: u7 = 0;
    while (i < 16) : (i += 1) {
        const b = try reader.readByte();
        encoded_bits |= @as(u128, @intCast(b)) << i * 8;
    }

    return Decimal128{
        .encoded_bits = encoded_bits,
    };
}

pub fn fromBytes(bytes: []const u8) !Decimal128 {
    if (bytes.len != 16) {
        return error.InvalidBytesLength;
    }

    var encoded_bits: u128 = 0;
    for (bytes, 0..16) |b, i| {
        encoded_bits |= @as(u128, @intCast(b)) << i * 8;
    }

    return Decimal128{
        .encoded_bits = encoded_bits,
    };
}

pub fn writeAsBytes(self: *Decimal128, writer: anytype) !void {
    const bytes = std.mem.toBytes(self.encoded_bits);
    try writer.appendSlice(&bytes);
}

pub fn toString(self: *Decimal128, buffer: []u8) ![]const u8 {
    std.debug.assert(buffer.len >= 42);

    var fbs = std.io.fixedBufferStream(buffer[0..]);
    const writer = fbs.writer();
    try self.writeAsString(writer);
    return buffer[0..fbs.pos];
}

pub fn writeAsString(self: *Decimal128, writer: anytype) std.io.AnyWriter.Error!void {
    return writeEncodedDecimal128AsString(self.encoded_bits, writer);
}

pub fn writeEncodedDecimal128AsString(encoded_bits: u128, writer: anytype) std.io.AnyWriter.Error!void {
    if (equalsNegative(encoded_bits)) {
        try writer.writeByte('-');
    }

    if (equalsSpecialValue(encoded_bits)) {
        if (equalsInfinite(encoded_bits)) {
            try writer.writeAll("Infinity");
        } else {
            try writer.writeAll("NaN");
        }
        return;
    }

    const coefficient: u128 = @intCast(encoded_bits & coefficient_bit_mask);

    const exponent_biased: i16 = @intCast((encoded_bits & exponent_bit_mask) >> exponent_bias_bit_shift);
    const exponent = -1 * (exponent_bias - exponent_biased) + 1;
    const exponent_abs = @abs(exponent);

    if (exponent == 1) {
        try writer.print("{d}", .{coefficient});
        return;
    }
    if (coefficient == 0 or (coefficient < 10 and ((exponent < exponent_minimum + coefficient_max_digits_count) or (exponent > 0 and exponent < 6)))) {
        if (exponent > 0) {
            try writer.print("{d}E+{d}", .{ coefficient, exponent_abs - @intFromBool(coefficient == 0 or (exponent > 0 and exponent < 6)) });
        } else {
            if (exponent > -6) {
                try writer.print("{d}.0", .{coefficient});
                try writer.writeByteNTimes('0', exponent_abs);
            } else {
                try writer.print("{d}E-{d}", .{ coefficient, exponent_abs + 1 });
            }
        }
        return;
    }

    const coefficient_scale: u16 = math.log10_int(coefficient);
    var num_of_decimal_digits = coefficient_scale;
    var scale = math.pow(u128, 10, num_of_decimal_digits);

    if (exponent > -6 and exponent <= 0) {
        num_of_decimal_digits = exponent_abs + 1;
        scale = math.pow(u128, 10, num_of_decimal_digits);
    }

    const msd = @divTrunc(coefficient, scale);

    if (exponent > 0 or coefficient_scale > exponent_abs or exponent_abs -| num_of_decimal_digits >= 6) {
        try writer.print("{d}", .{msd});

        if (num_of_decimal_digits > 0) {
            try writer.writeByte('.');

            const decimal: u128 = coefficient - msd * scale;
            if (decimal > 0) {
                const decimal_digits: u16 = math.log10_int(decimal);
                const decimal_leading_zeros: u16 = num_of_decimal_digits - decimal_digits - 1;
                if (decimal_leading_zeros > 0) {
                    try writer.writeByteNTimes('0', decimal_leading_zeros);
                }
                try writer.print("{d}", .{decimal});
            } else {
                try writer.writeByteNTimes('0', num_of_decimal_digits);
            }
        }

        if (exponent > 0) {
            try writer.print("E+{d}", .{exponent_abs + num_of_decimal_digits - 1});
        } else if (exponent <= -6) {
            const adjusted_exponent_abs = exponent_abs + 1 - num_of_decimal_digits;

            if (adjusted_exponent_abs > 0)
                try writer.print("E-{d}", .{adjusted_exponent_abs});
        }
    } else {
        try writer.writeAll("0.");

        if (coefficient > 0) {
            const decimal_leading_zeros = exponent_abs -| coefficient_scale;
            if (decimal_leading_zeros > 0) {
                try writer.writeByteNTimes('0', decimal_leading_zeros);
            }
            try writer.print("{d}", .{coefficient});
        } else {
            try writer.writeByteNTimes('0', num_of_decimal_digits);
        }
    }

    return;
}

fn createNaN(is_negative: bool) Decimal128 {
    var encoded_bits: u128 = special_value_bits_nan;

    encoded_bits |= sign_bit * @as(u128, @intFromBool(is_negative));

    return Decimal128{
        .encoded_bits = encoded_bits,
    };
}

fn createInfinite(is_negative: bool) Decimal128 {
    var encoded_bits: u128 = special_value_bits_infinite;

    encoded_bits |= sign_bit * @as(u128, @intFromBool(is_negative));

    return Decimal128{
        .encoded_bits = encoded_bits,
    };
}

fn isSpecialValue(self: Decimal128) bool {
    return equalsSpecialValue(self.encoded_bits);
}

inline fn equalsSpecialValue(encoded_bits: u128) bool {
    return encoded_bits & special_value_bits == special_value_bits;
}

pub fn isNegative(self: Decimal128) bool {
    return equalsNegative(self.encoded_bits);
}

pub inline fn equalsNegative(encoded_bits: u128) bool {
    return encoded_bits & sign_bit != 0;
}

pub fn isNaN(self: Decimal128) bool {
    return equalsNaN(self.encoded_bits);
}

pub fn equalsNaN(encoded_bits: u128) bool {
    return encoded_bits & special_value_bits_nan == special_value_bits_nan;
}

pub fn isInfinite(self: Decimal128) bool {
    return equalsInfinite(self.encoded_bits);
}

pub inline fn equalsInfinite(encoded_bits: u128) bool {
    return encoded_bits == special_value_bits_infinite or encoded_bits == special_value_bits_negative_infinite;
}

test {
    _ = @import("tests/decimal128.basic.test.zig");
    _ = @import("tests/decimal128.invalid.test.zig");
    _ = @import("tests/decimal128.special.test.zig");
    _ = @import("tests/decimal128.zeros.test.zig");
    _ = @import("tests/decimal128.exponent.test.zig");
    _ = @import("tests/decimal128.rounding.test.zig");
    _ = @import("tests/decimal128.representation-adjustments.test.zig");
}

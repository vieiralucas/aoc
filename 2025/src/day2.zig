const std = @import("std");

pub fn part1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
    var ranges = std.mem.splitSequence(u8, trimmed, ",");
    var sum: u64 = 0;

    while (ranges.next()) |raw_range| {
        var parts = std.mem.splitSequence(u8, raw_range, "-");
        const lhs = parts.next() orelse return error.InvalidInput;
        const rhs = parts.next() orelse return error.InvalidInput;

        const invalids = try find_invalids(allocator, lhs, rhs);
        defer allocator.free(invalids);
        for (invalids) |item| {
            sum += item;
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{sum});
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
    var ranges = std.mem.splitSequence(u8, trimmed, ",");
    var sum: u64 = 0;

    while (ranges.next()) |raw_range| {
        var parts = std.mem.splitSequence(u8, raw_range, "-");
        const lhs = parts.next() orelse return error.InvalidInput;
        const rhs = parts.next() orelse return error.InvalidInput;

        const invalids = try find_invalids_part2(allocator, lhs, rhs);
        defer allocator.free(invalids);
        for (invalids) |item| {
            sum += item;
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{sum});
}

fn is_invalid(id: []const u8) bool {
    const pivot = id.len / 2;
    const lhs = id[0..pivot];
    const rhs = id[pivot..];
    if (std.mem.eql(u8, lhs, rhs)) {
        return true;
    }

    return false;
}

fn find_invalids(allocator: std.mem.Allocator, start: []const u8, end: []const u8) ![]const u64 {
    const end_num = try std.fmt.parseInt(u64, end, 10);
    var current_num = try std.fmt.parseInt(u64, start, 10);
    var output = try std.ArrayList(u64).initCapacity(allocator, 0);
    defer output.deinit(allocator);

    while (current_num <= end_num) : (current_num += 1) {
        const id_buf = try std.fmt.allocPrint(allocator, "{}", .{current_num});
        defer allocator.free(id_buf);

        if (is_invalid(id_buf)) {
            try output.append(allocator, current_num);
        }
    }

    return output.toOwnedSlice(allocator);
}

fn find_invalids_part2(allocator: std.mem.Allocator, start: []const u8, end: []const u8) ![]const u64 {
    const end_num = try std.fmt.parseInt(u64, end, 10);
    var current_num = try std.fmt.parseInt(u64, start, 10);
    var output = try std.ArrayList(u64).initCapacity(allocator, 0);
    defer output.deinit(allocator);

    while (current_num <= end_num) : (current_num += 1) {
        const id_buf = try std.fmt.allocPrint(allocator, "{}", .{current_num});
        defer allocator.free(id_buf);

        if (is_invalid_part2(id_buf)) {
            try output.append(allocator, current_num);
        }
    }

    return output.toOwnedSlice(allocator);
}

fn is_invalid_part2(id: []const u8) bool {
    var pivot = id.len / 2;
    while (pivot > 0) : (pivot -= 1) {
        const lhs = id[0..pivot];
        var rest = id[pivot..];
        var invalid = true;
        while (rest.len >= lhs.len and invalid) {
            const next = rest[0..lhs.len];
            if (!std.mem.eql(u8, lhs, next)) {
                invalid = false;
            }
            rest = rest[lhs.len..];
        }

        if (rest.len == 0 and invalid) {
            return true;
        }
    }

    return false;
}

test "is_invalid" {
    try std.testing.expect(is_invalid("11"));
    try std.testing.expect(is_invalid("22"));
    try std.testing.expect(is_invalid("99"));
    try std.testing.expect(is_invalid("1010"));
    try std.testing.expect(is_invalid("118855118855"));
    try std.testing.expect(is_invalid("222222"));
    try std.testing.expect(is_invalid("446446"));
    try std.testing.expect(is_invalid("38593859"));
}

test "find_invalids" {
    const TestCase = struct {
        start: []const u8,
        end: []const u8,
        want: []const u64,
    };

    const tests = [_]TestCase{
        .{ .start = "11", .end = "22", .want = &[_]u64{ 11, 22 } },
        .{ .start = "95", .end = "115", .want = &[_]u64{99} },
        .{ .start = "998", .end = "1012", .want = &[_]u64{1010} },
        .{ .start = "1188511880", .end = "1188511890", .want = &[_]u64{1188511885} },
        .{ .start = "222220", .end = "222224", .want = &[_]u64{222222} },
        .{ .start = "1698522", .end = "1698528", .want = &[_]u64{} },
        .{ .start = "446443", .end = "446449", .want = &[_]u64{446446} },
        .{ .start = "38593856", .end = "38593862", .want = &[_]u64{38593859} },
        .{ .start = "38593856", .end = "38593862", .want = &[_]u64{38593859} },
    };

    const allocator = std.testing.allocator;
    for (tests) |t| {
        const invalids = try find_invalids(allocator, t.start, t.end);
        defer allocator.free(invalids);
        try std.testing.expectEqualSlices(u64, t.want, invalids);
    }
}

test "is_invalid_part2" {
    // try std.testing.expect(is_invalid_part2("11"));
    // try std.testing.expect(is_invalid_part2("22"));
    // try std.testing.expect(is_invalid_part2("99"));
    try std.testing.expect(is_invalid_part2("111"));
    try std.testing.expect(is_invalid_part2("999"));
    try std.testing.expect(is_invalid_part2("1010"));
    try std.testing.expect(is_invalid_part2("118855118855"));
    try std.testing.expect(is_invalid_part2("222222"));
    try std.testing.expect(is_invalid_part2("446446"));
    try std.testing.expect(is_invalid_part2("38593859"));
    try std.testing.expect(is_invalid_part2("565656"));
    try std.testing.expect(is_invalid_part2("824824824"));
    try std.testing.expect(is_invalid_part2("2121212121"));
}

test "find_invalids_part2" {
    const TestCase = struct {
        start: []const u8,
        end: []const u8,
        want: []const u64,
    };

    const tests = [_]TestCase{
        .{ .start = "11", .end = "22", .want = &[_]u64{ 11, 22 } },
        .{ .start = "95", .end = "115", .want = &[_]u64{ 99, 111 } },
        .{ .start = "998", .end = "1012", .want = &[_]u64{ 999, 1010 } },
        .{ .start = "1188511880", .end = "1188511890", .want = &[_]u64{1188511885} },
        .{ .start = "222220", .end = "222224", .want = &[_]u64{222222} },
        .{ .start = "1698522", .end = "1698528", .want = &[_]u64{} },
        .{ .start = "446443", .end = "446449", .want = &[_]u64{446446} },
        .{ .start = "38593856", .end = "38593862", .want = &[_]u64{38593859} },
        .{ .start = "38593856", .end = "38593862", .want = &[_]u64{38593859} },
        .{ .start = "824824821", .end = "824824827", .want = &[_]u64{824824824} },
        .{ .start = "2121212118", .end = "2121212124", .want = &[_]u64{2121212121} },
    };

    const allocator = std.testing.allocator;
    for (tests) |t| {
        const invalids = try find_invalids_part2(allocator, t.start, t.end);
        defer allocator.free(invalids);
        try std.testing.expectEqualSlices(u64, t.want, invalids);
    }
}

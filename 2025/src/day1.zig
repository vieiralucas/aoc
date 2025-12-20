const std = @import("std");

pub fn part1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var lines = std.mem.splitSequence(u8, input, "\n");
    var pos: i32 = 50;
    var result: u32 = 0;
    while (lines.next()) |line| {
        if (line.len < 1) {
            continue;
        }

        const d = line[0];
        if (d != 'L' and d != 'R') {
            return error.LineInvalidDirection;
        }

        const step_str = line[1..];
        var step = try std.fmt.parseInt(i32, step_str, 10);
        if (d == 'L') {
            step = step * -1;
        }

        pos += step;
        while (pos < 0) {
            pos = 100 + pos;
        }

        while (pos >= 100) {
            pos = pos - 100;
        }

        if (pos == 0) {
            result += 1;
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{result});
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var lines = std.mem.splitSequence(u8, input, "\n");
    var pos: i32 = 50;
    var result: u32 = 0;
    while (lines.next()) |line| {
        if (line.len < 1) {
            continue;
        }

        const d = line[0];
        if (d != 'L' and d != 'R') {
            return error.LineInvalidDirection;
        }

        const step_str = line[1..];
        const step = try std.fmt.parseInt(u32, step_str, 10);
        for (0..step) |_| {
            pos += if (d == 'L') -1 else 1;
            if (pos == 100) {
                pos = 0;
            } else if (pos == -1) {
                pos = 99;
            }

            if (pos == 0) {
                result += 1;
            }
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{result});
}

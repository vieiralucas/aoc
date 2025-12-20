const std = @import("std");

const day1 = @import("day1.zig");

const Day = struct {
    number: u32,
    part1_fn: *const fn (std.mem.Allocator, []const u8) anyerror![]const u8,
    part2_fn: *const fn (std.mem.Allocator, []const u8) anyerror![]const u8,
};

const days = [_]Day{
    .{ .number = 1, .part1_fn = day1.part1, .part2_fn = day1.part2 },
};

fn runPart(allocator: std.mem.Allocator, day: u32, part: u32, part_fn: *const fn (std.mem.Allocator, []const u8) anyerror![]const u8) !void {
    const input_path = try std.fmt.allocPrint(allocator, "inputs/day{d}_part{d}.txt", .{ day, part });

    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 1024 * 1024) catch |err| {
        if (err == error.FileNotFound) {
            std.debug.print("Day {d} Part {d}: Input file not found ({s})\n", .{ day, part, input_path });
            return;
        }
        return err;
    };

    const result = try part_fn(allocator, input);
    std.debug.print("Day {d} Part {d}: {s}\n", .{ day, part, result });
}

fn runDay(allocator: std.mem.Allocator, day: u32) !void {
    for (days) |d| {
        if (d.number == day) {
            try runPart(allocator, day, 1, d.part1_fn);
            try runPart(allocator, day, 2, d.part2_fn);
            return;
        }
    }

    std.debug.print("Day {d} not implemented yet\n", .{day});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        for (days) |day| {
            var arena = std.heap.ArenaAllocator.init(allocator);
            defer arena.deinit();

            try runDay(arena.allocator(), day.number);
        }
    } else {
        const day = try std.fmt.parseInt(u32, args[1], 10);

        var arena = std.heap.ArenaAllocator.init(allocator);
        defer arena.deinit();
        try runDay(arena.allocator(), day);
    }
}

const std = @import("std");

const day1 = @import("day1.zig");
const day2 = @import("day2.zig");

const Day = struct {
    number: u32,
    part1_fn: *const fn (std.mem.Allocator, []const u8) anyerror![]const u8,
    part2_fn: *const fn (std.mem.Allocator, []const u8) anyerror![]const u8,
};

const days = [_]Day{
    .{ .number = 1, .part1_fn = day1.part1, .part2_fn = day1.part2 },
    .{ .number = 2, .part1_fn = day2.part1, .part2_fn = day2.part2 },
};

fn runPart(allocator: std.mem.Allocator, day: u32, part: u32, use_sample: bool, part_fn: *const fn (std.mem.Allocator, []const u8) anyerror![]const u8) !void {
    const suffix = if (use_sample) "sample" else "actual";
    const input_path = try std.fmt.allocPrint(allocator, "inputs/day{d:0>2}_{s}.txt", .{ day, suffix });

    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 1024 * 1024) catch |err| {
        if (err == error.FileNotFound) {
            std.debug.print("Day {d} Part {d}{s}: Input file not found ({s})\n", .{ day, part, if (use_sample) " (sample)" else "", input_path });
            return;
        }
        return err;
    };

    const result = try part_fn(allocator, input);
    std.debug.print("Day {d} Part {d}{s}: {s}\n", .{ day, part, if (use_sample) " (sample)" else "", result });
}

fn runDay(allocator: std.mem.Allocator, day: u32, use_sample: bool) !void {
    for (days) |d| {
        if (d.number == day) {
            try runPart(allocator, day, 1, use_sample, d.part1_fn);
            try runPart(allocator, day, 2, use_sample, d.part2_fn);
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

    var use_sample = false;
    var day_arg: ?[]const u8 = null;

    for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg, "--sample")) {
            use_sample = true;
        } else if (day_arg == null) {
            day_arg = arg;
        }
    }

    if (day_arg) |day_str| {
        const day = std.fmt.parseInt(u32, day_str, 10) catch {
            std.debug.print("Invalid day argument: {s}\n", .{day_str});
            return;
        };

        var arena = std.heap.ArenaAllocator.init(allocator);
        defer arena.deinit();
        try runDay(arena.allocator(), day, use_sample);
    } else {
        for (days) |day| {
            var arena = std.heap.ArenaAllocator.init(allocator);
            defer arena.deinit();

            try runDay(arena.allocator(), day.number, use_sample);
        }
    }
}

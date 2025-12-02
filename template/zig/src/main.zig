const std = @import("std");
const raw_input = @embedFile("./input.txt");

pub fn main() !void {
    std.debug.print("{s}", .{raw_input});
}

const std = @import("std");

const State = struct { turn: i32, zeroes: u32 };

pub fn main() !void {
    const turns: []i32 = blk: {
        const allocator = std.heap.page_allocator;

        const input_raw = @embedFile("./input.txt");
        const input_str = std.mem.trim(u8, input_raw, "\t\r\n");
        var turns_str = std.mem.splitScalar(u8, input_str, '\n');

        const turns_len =
            std.mem.count(u8, input_str, "\n") + 1;
        const turns = try allocator.alloc(i32, turns_len);

        var i: u32 = 0;
        while (turns_str.next()) |turn_str| {
            const mult: i32 = if (turn_str[0] == 'L') -1 else 1;
            turns[i] = try std.fmt.parseInt(i32, turn_str[1..], 10) * mult;
            i += 1;
        }
        break :blk turns;
    };

    var part_1 = State{ .turn = 50, .zeroes = 0 };
    for (turns) |turn| {
        const iturn: i32 = @intCast(part_1.turn);
        part_1.turn = @mod(iturn + turn, 100);
        part_1.zeroes += @intFromBool(part_1.turn == 0);
    }
    std.debug.print("Part 1: {}\n", .{part_1.zeroes});

    var part_2 = State{ .turn = 50, .zeroes = 0 };
    for (turns) |turn| {
        const iturn: i32 = @intCast(part_2.turn);
        const raw_turn: i32 = iturn + turn;
        // if it is below zero before being moduloed and the original number itself wasn't zero it means that it did touch zero but the division thing wouldn't count it, so we give this extra support.
        // of course, there is no need to deal with a negative to positive situation because the acc.turn will never be negative!!!
        part_2.zeroes += @abs(raw_turn) / 100 + @intFromBool(part_2.turn != 0 and raw_turn <= 0);
        part_2.turn = @mod(raw_turn, 100);
    }
    std.debug.print("Part 2: {}\n", .{part_2.zeroes});
}

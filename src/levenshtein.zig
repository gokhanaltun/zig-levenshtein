const std = @import("std");

pub fn distance(s1: []const u8, s2: []const u8, allocator: std.mem.Allocator) !usize {
    if (s1.len == 0) return s2.len;
    if (s2.len == 0) return s1.len;

    const rows = s1.len + 1;
    const cols = s2.len + 1;

    const table = try allocator.alloc(usize, rows * cols);
    defer allocator.free(table);

    for (0..cols) |j| {
        table[j] = j;
    }

    for (0..rows) |i| {
        table[i * cols] = i;
    }

    for (1..rows) |i| {
        for (1..cols) |j| {
            if (s1[i - 1] == s2[j - 1]) {
                table[i * cols + j] = table[(i - 1) * cols + (j - 1)];
            } else {
                const delete = table[(i - 1) * cols + j];
                const insert = table[i * cols + (j - 1)];
                const replace = table[(i - 1) * cols + (j - 1)];
                table[i * cols + j] = 1 + @min(delete, @min(insert, replace));
            }
        }
    }

    return table[(rows - 1) * cols + (cols - 1)];
}

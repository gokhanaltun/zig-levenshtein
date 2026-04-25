const std = @import("std");

pub fn distance(s1: []const u8, s2: []const u8, allocator: std.mem.Allocator) !usize {
    const view1 = try std.unicode.Utf8View.init(s1);
    const view2 = try std.unicode.Utf8View.init(s2);

    // collect codepoints
    var cp1: std.ArrayListUnmanaged(u21) = .empty;
    defer cp1.deinit(allocator);
    var cp2: std.ArrayListUnmanaged(u21) = .empty;
    defer cp2.deinit(allocator);

    var iter1 = view1.iterator();
    while (iter1.nextCodepoint()) |cp| try cp1.append(allocator, cp);

    var iter2 = view2.iterator();
    while (iter2.nextCodepoint()) |cp| try cp2.append(allocator, cp);

    const len1 = cp1.items.len;
    const len2 = cp2.items.len;

    if (len1 == 0) return len2;
    if (len2 == 0) return len1;

    const rows = len1 + 1;
    const cols = len2 + 1;

    const table = try allocator.alloc(usize, rows * cols);
    defer allocator.free(table);

    for (0..cols) |j| table[j] = j;
    for (0..rows) |i| table[i * cols] = i;

    for (1..rows) |i| {
        for (1..cols) |j| {
            if (cp1.items[i - 1] == cp2.items[j - 1]) {
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

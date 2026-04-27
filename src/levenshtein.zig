const std = @import("std");

pub fn distance(s1: []const u8, s2: []const u8, allocator: std.mem.Allocator) !usize {
    _ = try std.unicode.Utf8View.init(s1);
    _ = try std.unicode.Utf8View.init(s2);

    const len1 = try std.unicode.utf8CountCodepoints(s1);
    const len2 = try std.unicode.utf8CountCodepoints(s2);

    if (len1 == 0) return len2;
    if (len2 == 0) return len1;

    const is_v1_shorter = len1 < len2;
    const s_len = if (is_v1_shorter) len1 else len2;
    const short_str = if (is_v1_shorter) s1 else s2;
    const long_str = if (is_v1_shorter) s2 else s1;

    const short_cp = try allocator.alloc(u21, s_len);
    defer allocator.free(short_cp);

    var it_s = (try std.unicode.Utf8View.init(short_str)).iterator();
    var idx: usize = 0;
    while (it_s.nextCodepoint()) |cp| : (idx += 1) {
        short_cp[idx] = cp;
    }

    const row = try allocator.alloc(usize, s_len + 1);
    defer allocator.free(row);

    for (0..s_len + 1) |j| row[j] = j;

    var it_l = (try std.unicode.Utf8View.init(long_str)).iterator();
    var i: usize = 1;
    while (it_l.nextCodepoint()) |cp_l| : (i += 1) {
        var prev_sub_cost = row[0];
        row[0] = i;

        for (0..s_len) |j| {
            const cost: usize = if (cp_l == short_cp[j]) 0 else 1;
            const substitution_cost = prev_sub_cost + cost;

            prev_sub_cost = row[j + 1];

            row[j + 1] = @min(substitution_cost, @min(row[j] + 1, row[j + 1] + 1));
        }
    }

    return row[s_len];
}

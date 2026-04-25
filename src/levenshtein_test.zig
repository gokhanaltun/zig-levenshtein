const std = @import("std");
const distance = @import("levenshtein.zig").distance;

test "empty strings" {
    const allocator = std.testing.allocator;
    try std.testing.expectEqual(@as(usize, 3), try distance("", "cat", allocator));
    try std.testing.expectEqual(@as(usize, 3), try distance("cat", "", allocator));
    try std.testing.expectEqual(@as(usize, 0), try distance("", "", allocator));
}

test "equal strings" {
    const allocator = std.testing.allocator;
    try std.testing.expectEqual(@as(usize, 0), try distance("cat", "cat", allocator));
}

test "single character difference" {
    const allocator = std.testing.allocator;
    try std.testing.expectEqual(@as(usize, 1), try distance("cat", "cut", allocator));
}

test "different lengths" {
    const allocator = std.testing.allocator;
    try std.testing.expectEqual(@as(usize, 4), try distance("hi", "hello", allocator));
}

test "classic example" {
    const allocator = std.testing.allocator;
    try std.testing.expectEqual(@as(usize, 3), try distance("kitten", "sitting", allocator));
}

# zig-levenshtein

A simple, fast, and allocation-based Levenshtein distance implementation in Zig.

## Installation

Run the following command to add the package to your project:

```bash
zig fetch --save https://github.com/gokhanaltun/zig-levenshtein/archive/refs/tags/v1.0.0.tar.gz
```

Then add it to your `build.zig`:

```zig
const lev_dep = b.dependency("zig_levenshtein", .{});
exe.root_module.addImport("levenshtein", lev_dep.module("levenshtein"));
```

## Usage

```zig
const std = @import("std");
const lev = @import("levenshtein");

pub fn main(init: std.process.Init) !void {
    const d = try lev.distance("kitten", "sitting", init.gpa);
    std.debug.print("distance: {d}\n", .{d}); // 3
}
```

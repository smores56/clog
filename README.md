The Clog Family
===============

The Clog is a split 34-key keyboard with pinky clusters, the split version of [the
Osprette][osprette]. It grew its own revisions from there, and they all share the
same layout and firmware, so they live in one repo now, a folder per board:

- [Clog][v1] (`v1`): the original split. Pro-micro compatible, wired or bluetooth
- [Clog V2][v2] (`v2`): wireless-only, on a Seeeduino Xiao BLE, with splay and a roller
- [Clog V3][v3] (`v3`): pro-micro compatible, solder or hotswap
- [Clog V4][v4] (`v4`): hotswap with a switch plate, on a Xiao
- [Steel Toe][steel-toe] (`steel-toe`): BoardSource's V3-derived board
- [Sephirette][sephirette] (`sephirette`): MX-switch split, matching the Osprette MX

Each folder has its own README with ordering details and pictures.

# Firmware

The pro-micro boards (Clog, V3, Steel Toe and Sephirette) share a matrix, so they
all run the same firmware: `clog` in QMK and the `clog` shield in ZMK. Clog V2 is
wireless-only and has its own ZMK config, and V4 doesn't have firmware yet. My
personal keymaps live in [qmk_userspace][qmk_userspace] and [zmk-config][zmk-config].

# Building

These boards use my [smores.pretty][smores-pretty] KiCad library as a submodule,
so clone with `--recurse-submodules`. The original Clog and the Sephirette still
pull in Foostan's `kbd` and Daprice's `keyswitches.pretty` directly.

The unibody half of the family is [the Osprette][osprette].


[osprette]: https://github.com/smores56/osprette
[v1]: ./v1
[v2]: ./v2
[v3]: ./v3
[v4]: ./v4
[steel-toe]: ./steel-toe
[sephirette]: ./sephirette
[qmk_userspace]: https://github.com/smores56/qmk_userspace
[zmk-config]: https://github.com/smores56/zmk-config
[smores-pretty]: https://github.com/smores56/smores.pretty

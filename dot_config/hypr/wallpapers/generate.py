#!/usr/bin/env python3
"""Layered-ridge day/night wallpapers in the Catppuccin Macchiato palette.

Both images share one seed, so the mountains are the same place at a different
hour. Each carries a handful of small silhouettes to find at full size.
"""
import math
import os
import sys
import numpy as np
from PIL import Image, ImageDraw, ImageFilter

W, H = 2560, 1440
SEED = 20260907


# ------------------------------------------------------------------ primitives
def hex2rgb(h):
    h = h.lstrip("#")
    return np.array([int(h[i:i + 2], 16) for i in (0, 2, 4)], dtype=np.float64)


def rgba(h, a=255):
    r, g, b = hex2rgb(h).astype(int)
    return (int(r), int(g), int(b), a)


def smoothstep(t):
    t = np.clip(t, 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)


def sky_gradient(stops):
    ys = np.linspace(0.0, 1.0, H)
    out = np.zeros((H, 3))
    for k in range(len(stops) - 1):
        p0, c0 = stops[k]
        p1, c1 = stops[k + 1]
        m = (ys >= p0) & (ys <= p1)
        t = smoothstep((ys[m] - p0) / max(p1 - p0, 1e-9))[:, None]
        out[m] = hex2rgb(c0) * (1 - t) + hex2rgb(c1) * t
    out[ys < stops[0][0]] = hex2rgb(stops[0][1])
    out[ys > stops[-1][0]] = hex2rgb(stops[-1][1])
    return np.repeat(out[:, None, :], W, axis=1)


def value_noise_1d(n, res, rng):
    ctrl = rng.random(res + 1)
    ctrl[-1] = ctrl[0]
    x = np.linspace(0, res, n, endpoint=False)
    i = x.astype(int)
    f = smoothstep(x - i)
    return ctrl[i] * (1 - f) + ctrl[i + 1] * f


def fbm_1d(n, octaves, base_res, rng, persistence=0.5):
    total, amp, res, norm = np.zeros(n), 1.0, base_res, 0.0
    for _ in range(octaves):
        total += amp * value_noise_1d(n, max(int(res), 2), rng)
        norm += amp
        amp *= persistence
        res *= 2.0
    return total / norm


def noise_2d(gh, gw, rng):
    g = (rng.random((gh, gw)) * 255).astype(np.uint8)
    return np.asarray(Image.fromarray(g).resize((W, H), Image.BICUBIC)) / 255.0


def fbm_2d(octaves, gh, gw, rng, persistence=0.55):
    total, amp, norm = np.zeros((H, W)), 1.0, 0.0
    for _ in range(octaves):
        total += amp * noise_2d(max(int(gh), 2), max(int(gw), 2), rng)
        norm += amp
        amp *= persistence
        gh, gw = gh * 2, gw * 2
    return total / norm


def blur_1d(a, sigma):
    r = int(sigma * 3)
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / sigma) ** 2)
    return np.convolve(np.pad(a, r, mode="edge"), k / k.sum(), mode="valid")


def radial(cx, cy):
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float64)
    return np.sqrt((xx - cx) ** 2 + (yy - cy) ** 2)


def add_glow(img, cx, cy, radius, color, strength, falloff=2.0):
    g = np.exp(-((radial(cx, cy) / radius) ** falloff)) * strength
    return img + g[..., None] * hex2rgb(color)


def draw_disc(img, cx, cy, r, color, softness=2.5):
    a = np.clip((r - radial(cx, cy)) / softness, 0.0, 1.0)[..., None]
    return img * (1 - a) + a * hex2rgb(color)


# ---------------------------------------------------------------------- ridges
GEOMETRY = [
    dict(base=0.630, amp=0.200, res=7, sharp=1.7, env=0.42, tilt=-90, haze=300),
    dict(base=0.700, amp=0.165, res=6, sharp=1.6, env=0.46, tilt=+60, haze=250),
    dict(base=0.775, amp=0.135, res=5, sharp=1.4, env=0.52, tilt=-55, haze=200),
    dict(base=0.855, amp=0.110, res=4, sharp=1.2, env=0.58, tilt=+70, haze=160),
    dict(base=0.950, amp=0.092, res=3, sharp=1.0, env=0.64, tilt=-45, haze=125),
    dict(base=1.060, amp=0.080, res=2, sharp=0.9, env=0.70, tilt=+50, haze=95),
]


def heightfields():
    """Ridge crest y-position per layer, far -> near. Deterministic."""
    rng = np.random.default_rng(SEED + 555)
    xs = np.arange(W)
    out = []
    for g in GEOMETRY:
        env = fbm_1d(W, 3, 2, rng, 0.55)
        det = 1.0 - np.abs(2.0 * fbm_1d(W, 5, g["res"], rng, 0.52) - 1.0)
        h = g["env"] * env + (1.0 - g["env"]) * det ** g["sharp"]
        h = (h - h.min()) / max(np.ptp(h), 1e-9)
        out.append(H * g["base"] - H * g["amp"] * h + g["tilt"] * (xs / W - 0.5))
    return out


def paint_ridges(img, colors, hs, decorate=None):
    yy = np.arange(H)[:, None]
    for i, (g, (top, bot)) in enumerate(zip(GEOMETRY, colors)):
        depth = yy - hs[i][None, :]
        mask = smoothstep(depth / 1.6)[..., None]
        # Haze follows a smoothed crest; the raw crest makes every peak streak.
        haze = smoothstep((yy - blur_1d(hs[i], 220.0)[None, :]) / g["haze"])[..., None]
        img = img * (1 - mask) + (hex2rgb(top) * (1 - haze) + hex2rgb(bot) * haze) * mask
        if decorate is not None:
            img = decorate(img, i)
    return img


# ------------------------------------------------------------------ silhouettes
class Overlay:
    """Transparent RGBA layer for silhouette work, composited back onto floats."""

    def __init__(self):
        self.im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        self.d = ImageDraw.Draw(self.im)

    def onto(self, img):
        o = np.asarray(self.im).astype(np.float64)
        a = o[..., 3:4] / 255.0
        return img * (1 - a) + o[..., :3] * a


ASSETS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets")
_masks = {}


def mask(name):
    """Alpha mask for a silhouette asset (see assets/ATTRIBUTION.md)."""
    if name not in _masks:
        _masks[name] = Image.open(os.path.join(ASSETS, f"{name}.png")).split()[-1]
    return _masks[name]


def stamp(ov, name, x, ground, h, color, alpha=255, flip=False):
    """Place a silhouette standing on `ground`, centred on x, `h` px tall."""
    m = mask(name)
    h = max(2, int(round(h)))
    w = max(1, round(m.width * h / m.height))
    mm = m.resize((w, h), Image.LANCZOS)
    if flip:
        mm = mm.transpose(Image.FLIP_LEFT_RIGHT)
    if alpha < 255:
        mm = mm.point(lambda v: v * alpha // 255)
    tile = Image.new("RGBA", mm.size, tuple(hex2rgb(color).astype(int)) + (255,))
    ov.im.paste(tile, (int(round(x - w / 2)), int(round(ground - h))), mm)
    return w


def treeline(ov, h, color, rng, x0, x1, count, lo, hi, alpha=255):
    """Scatter conifers along a ridge crest."""
    for x in rng.uniform(x0, x1, count):
        xi = int(np.clip(x, 0, W - 1))
        kind = "spruce_a" if rng.random() < 0.72 else "spruce_c"
        stamp(ov, kind, xi, h[xi] + 2, rng.uniform(lo, hi), color, alpha,
              flip=rng.random() < 0.5)


def cabin(d, x, ground, s, col):
    d.polygon([(x - s * 0.60, ground), (x + s * 0.60, ground),
               (x + s * 0.60, ground - s * 0.55), (x - s * 0.60, ground - s * 0.55)],
              fill=col)
    d.polygon([(x - s * 0.80, ground - s * 0.50), (x + s * 0.80, ground - s * 0.50),
               (x, ground - s * 1.08)], fill=col)
    d.rectangle([x + s * 0.24, ground - s * 1.04, x + s * 0.42, ground - s * 0.55],
                fill=col)                                        # chimney


def tent(d, x, ground, s, col):
    d.polygon([(x - s * 0.62, ground), (x + s * 0.62, ground), (x, ground - s)],
              fill=col)
    d.line([(x + s * 0.62, ground), (x + s * 0.98, ground)], fill=col,
           width=max(1, int(s * 0.07)))                          # guy line


def finish(img, path, vignette=0.16, grain=1.8):
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float64)
    r = np.clip(np.sqrt(((xx / W - 0.5) * 1.05) ** 2 + (yy / H - 0.5) ** 2) / 0.72, 0, 1)
    img = img * (1.0 - vignette * r ** 2.2)[..., None]
    rng = np.random.default_rng(SEED + 7)
    img = img + rng.normal(0.0, grain, img.shape)   # dither: kills gradient banding
    Image.fromarray(np.clip(img, 0, 255).astype(np.uint8)).save(path, optimize=True)
    print(f"wrote {path}")


# ------------------------------------------------------------------------- day
def make_day(path):
    rng = np.random.default_rng(SEED)
    hs = heightfields()
    img = sky_gradient([
        (0.00, "#3d4f96"), (0.14, "#6d8ede"), (0.28, "#9aa8ee"), (0.38, "#c9b0e4"),
        (0.47, "#efc3c6"), (0.56, "#f5a97f"), (0.64, "#f2cf9d"), (1.00, "#efd0a4"),
    ])
    sun_x, sun_y = W * 0.685, H * 0.470

    clouds = fbm_2d(5, 16, 3, rng)
    ys = np.arange(H)
    band = smoothstep((ys - H * 0.04) / (H * 0.16)) * (1 - smoothstep((ys - H * 0.34) / (H * 0.16)))
    alpha = (smoothstep((clouds - 0.56) / 0.18) * band[:, None] * 0.40)[..., None]
    lit = np.exp(-(radial(sun_x, sun_y) / (W * 0.50)) ** 2)[..., None]
    img = img * (1 - alpha) + alpha * (hex2rgb("#e6c3ec") * (1 - lit) + hex2rgb("#fbe6cc") * lit)

    img = add_glow(img, sun_x, sun_y, W * 0.32, "#f5a97f", 0.26, falloff=1.7)
    img = add_glow(img, sun_x, sun_y, W * 0.055, "#f9e2af", 0.30, falloff=1.9)
    img = draw_disc(img, sun_x, sun_y, 40, "#fdf1dc", softness=3.0)

    # Birds, drawn into the sky before any ridge covers them.
    ov = Overlay()
    for bx, by, bh in [(300, 250, 13), (356, 231, 11), (410, 264, 12),
                       (262, 297, 9), (452, 227, 10), (332, 302, 8), (398, 205, 8)]:
        stamp(ov, "bird_soar", bx, by, bh, "#5d5480", 190, flip=bx % 2 == 0)
    stamp(ov, "bird_side", 1180, 196, 26, "#584f78", 165)     # a lone raptor, higher up
    img = ov.onto(img)

    dec_rng = np.random.default_rng(SEED + 31)

    def decorate(im, i):
        ov = Overlay()
        if i == 1:
            treeline(ov, hs[1], "#7b68a4", dec_rng, 60, 900, 26, 13, 22)
        elif i == 2:
            treeline(ov, hs[2], "#5b4e7d", dec_rng, 1300, 2500, 34, 15, 27)
            x = 780
            stamp(ov, "walker", x, hs[2][x] + 2, 30, "#4a3f68")   # walker on the crest
        elif i == 3:
            treeline(ov, hs[3], "#3d3555", dec_rng, 100, 1500, 40, 17, 31)
            cabin(ov.d, 2010, hs[3][2010] + 2, 26, rgba("#332c48"))
        elif i == 4:
            treeline(ov, hs[4], "#241f34", dec_rng, 1500, 2540, 30, 20, 38)
        im = ov.onto(im)
        if i == 3:                                   # chimney smoke, after the cabin
            x, gy = 2010, hs[3][2010]
            sm = np.zeros((H, W))
            for t in np.linspace(0, 1, 90):
                px = x + 7 + 26 * t + 9 * math.sin(t * 5.0)
                py = gy - 28 - 95 * t
                sm += np.exp(-((radial(px, py) / (3.5 + 11 * t)) ** 2)) * (1 - t) * 0.037
            im = im + np.clip(sm, 0, 0.5)[..., None] * hex2rgb("#e8d8e8")
        return im

    img = paint_ridges(img, [
        ("#cdbcf0", "#b09ad9"), ("#a892d2", "#8a76b6"), ("#7e6ba6", "#635489"),
        ("#584c78", "#443b5e"), ("#372f4c", "#282338"), ("#1d1a2a", "#131120"),
    ], hs, decorate)
    finish(img, path)


# ----------------------------------------------------------------------- night
def make_night(path):
    rng = np.random.default_rng(SEED + 101)
    hs = heightfields()
    img = sky_gradient([
        (0.00, "#0b0c14"), (0.20, "#141625"), (0.40, "#1e2030"), (0.55, "#2a2c43"),
        (0.64, "#3a3757"), (0.72, "#4a3f6b"), (1.00, "#54476f"),
    ])
    moon_x, moon_y = W * 0.735, H * 0.200

    n = 2100
    sx = rng.random(n) * W
    sy = (rng.random(n) ** 1.6) * H * 0.72
    mag = rng.random(n) ** 2.3
    fade = 1 - smoothstep((sy - H * 0.28) / (H * 0.38))
    near_moon = 1 - np.exp(-((np.hypot(sx - moon_x, sy - moon_y) / (W * 0.11)) ** 2))
    star = np.zeros((H, W))
    np.add.at(star, (sy.astype(int), sx.astype(int)), mag * fade * near_moon)

    # Ursa Major, faint but findable, upper left.
    dipper = [(300, 300), (395, 268), (487, 281), (566, 330),
              (648, 316), (742, 352), (806, 288)]
    for (px, py) in dipper:
        np.add.at(star, (py, px), 1.6)
    star = np.asarray(Image.fromarray((np.clip(star, 0, 1) * 255).astype(np.uint8))
                      .filter(ImageFilter.GaussianBlur(0.7))) / 255.0
    img = img + (star * 230)[..., None] * (hex2rgb("#cad3f5") / 255)

    ov = Overlay()
    for a, b in zip(dipper, dipper[1:]):             # very faint join lines
        ov.d.line([a, b], fill=rgba("#8aadf4", 34), width=1)
    img = ov.onto(img)

    mw = fbm_2d(4, 3, 9, rng)
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float64)
    dist = np.abs((yy - H * 0.22) - (xx - W * 0.5) * 0.26) / (H * 0.18)
    img = img + (np.exp(-dist ** 2) * smoothstep((mw - 0.46) / 0.34) * 24)[..., None] \
        * (hex2rgb("#b7bdf8") / 255)

    # A meteor, upper right, fading as it falls.
    for t in np.linspace(0, 1, 220):
        px, py = 900 + 286 * t, 112 + 150 * t
        img = add_glow(img, px, py, 1.5 + 1.3 * (1 - t), "#dce3fb",
                       0.34 * (1 - t) ** 1.7, falloff=2.0)

    img = add_glow(img, moon_x, moon_y, W * 0.24, "#8aadf4", 0.13, falloff=1.6)
    img = add_glow(img, moon_x, moon_y, W * 0.038, "#c6d0f5", 0.26, falloff=2.0)
    disc = np.clip((34 - radial(moon_x, moon_y)) / 2.2, 0, 1)
    bite = np.clip((34 - radial(moon_x + 15.5, moon_y - 8.5)) / 2.2, 0, 1)
    cres = (disc * (1 - bite))[..., None]
    img = img * (1 - cres) + hex2rgb("#eef1fd") * cres

    img = add_glow(img, W * 0.60, H * 0.640, W * 0.32, "#8087a2", 0.26, falloff=1.8)

    dec_rng = np.random.default_rng(SEED + 31)       # same seed => same treelines

    def decorate(im, i):
        if i == 4:      # firelight goes down before the silhouettes on top of it
            gy = hs[4][620]
            im = add_glow(im, 654, gy - 5, 30, "#f5a97f", 0.30, falloff=1.8)
            im = add_glow(im, 654, gy - 6, 6, "#f9e2af", 0.50, falloff=2.0)
        ov = Overlay()
        if i == 1:
            treeline(ov, hs[1], "#302f4c", dec_rng, 60, 900, 26, 13, 22)
        elif i == 2:
            treeline(ov, hs[2], "#26263c", dec_rng, 1300, 2500, 34, 15, 27)
            x = 780
            stamp(ov, "stag", x, hs[2][x] + 2, 30, "#1d1d2e", flip=True)
        elif i == 3:
            treeline(ov, hs[3], "#1c1c2d", dec_rng, 100, 1500, 40, 17, 31)
        elif i == 4:
            treeline(ov, hs[4], "#101019", dec_rng, 1500, 2540, 30, 20, 38)
            x = 620
            tent(ov.d, x, hs[4][x] + 2, 30, rgba("#0b0b13"))
            stamp(ov, "walker", 690, hs[4][690] + 2, 22, "#0b0b13", flip=True)
            gx = 1100                                    # a lone tree on a high point
            stamp(ov, "spruce_a", gx, hs[4][gx] + 2, 66, "#0b0b13")
            stamp(ov, "owl", gx + 5, hs[4][gx] - 60, 26, "#0b0b13")

        im = ov.onto(im)
        if i == 5:                                   # fireflies in the foreground
            ff = np.random.default_rng(SEED + 77)
            for _ in range(30):
                px = ff.uniform(0, W)
                py = hs[5][int(px)] + ff.uniform(10, 120)
                im = add_glow(im, px, py, ff.uniform(3, 6), "#eed49f",
                              ff.uniform(0.14, 0.38), falloff=2.0)
        return im

    img = paint_ridges(img, [
        ("#4e4d78", "#3d3c60"), ("#3e3d61", "#30304c"), ("#31314c", "#26263c"),
        ("#26263c", "#1c1c2d"), ("#1a1a29", "#12121e"), ("#0f0f19", "#08080e"),
    ], hs, decorate)
    finish(img, path, vignette=0.22, grain=1.5)


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "."
    make_day(f"{out}/macchiato-day.png")
    make_night(f"{out}/macchiato-night.png")

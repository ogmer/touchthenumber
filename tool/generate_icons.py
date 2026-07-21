"""アプリアイコンとストア用画像を生成する。
使い方: py tool/generate_icons.py  (要: py -m pip install pillow)

生成物:
  assets/icon/app_icon.png            1024x1024 マスターアイコン（iOS・レガシー用、全面塗り）
  assets/icon/app_icon_rounded.png    1024x1024 角丸版（Web/Windows 用）
  assets/icon/app_icon_foreground.png 1024x1024 Android アダプティブ前景（数字タイルのみ・透過）
  assets/icon/app_icon_background.png 1024x1024 Android アダプティブ背景（グラデーションのみ）
  store/icon_512.png                  Google Play ストア掲載用アイコン
  store/feature_graphic.png           Google Play フィーチャーグラフィック (1024x500)

デザイン: ゲーム画面と同じ「丸角の数字タイル」モチーフ。
Android はアダプティブアイコン（前景＋背景）にしているため、端末やユーザー設定の
マスク（円・角丸・スクワークル等）に追従して形が変わる（形は固定しない）。
iOS は OS 側で角丸が適用されるためマスターは全面塗り。
Web/Windows は app_icon_rounded.png で角を透過させる。
"""
import os
import urllib.request
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONT_DIR = os.path.join(ROOT, "tool", "_font_src")
FONT_URL = ("https://github.com/google/fonts/raw/main/ofl/"
            "mplusrounded1c/MPLUSRounded1c-Bold.ttf")

# テーマカラー（既定テーマのブルー系）
BG_TOP = (79, 195, 247)      # 明るいブルー
BG_BOTTOM = (21, 101, 192)   # 深いブルー
TILE_WHITE = (255, 255, 255)
NUM_BLUE = (25, 118, 210)
ACCENT = (255, 179, 0)       # "1"タイルのアンバー
SHADOW = (13, 71, 161, 90)

SS = 4  # アンチエイリアス用のスーパーサンプリング倍率


def font_path() -> str:
    """アプリと同じ丸ゴシック（フル版）を用意する"""
    os.makedirs(FONT_DIR, exist_ok=True)
    path = os.path.join(FONT_DIR, "MPLUSRounded1c-Bold.ttf")
    if not os.path.exists(path):
        print("downloading font ...")
        urllib.request.urlretrieve(FONT_URL, path)
    return path


def vertical_gradient(size, top, bottom):
    w, h = size
    img = Image.new("RGB", size)
    for y in range(h):
        t = y / max(h - 1, 1)
        color = tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        img.paste(color, (0, y, w, y + 1))
    return img


def draw_tile(draw, box, radius, fill, shadow_offset):
    """影付きの丸角タイルを描く"""
    x0, y0, x1, y1 = box
    draw.rounded_rectangle(
        (x0 + shadow_offset, y0 + shadow_offset,
         x1 + shadow_offset, y1 + shadow_offset),
        radius=radius, fill=SHADOW)
    draw.rounded_rectangle(box, radius=radius, fill=fill)


def draw_centered_text(draw, center, text, font, fill):
    x0, y0, x1, y1 = draw.textbbox((0, 0), text, font=font)
    w, h = x1 - x0, y1 - y0
    draw.text((center[0] - w / 2 - x0, center[1] - h / 2 - y0),
              text, font=font, fill=fill)


def draw_number_tiles(img, tile_frac):
    """2x2の数字タイルを img に描く。tile_fracはタイル一辺の画像比"""
    s = img.width
    draw = ImageDraw.Draw(img, "RGBA")
    tile = round(s * tile_frac)
    gap = round(tile * 0.15)
    radius = round(tile * 0.22)
    shadow_offset = round(s * 0.012)
    grid = tile * 2 + gap
    left = (s - grid) // 2
    top = (s - grid) // 2

    font = ImageFont.truetype(font_path(), round(tile * 0.62))

    numbers = [("1", ACCENT, TILE_WHITE), ("2", TILE_WHITE, NUM_BLUE),
               ("3", TILE_WHITE, NUM_BLUE), ("4", TILE_WHITE, NUM_BLUE)]
    for i, (num, tile_color, num_color) in enumerate(numbers):
        col, row = i % 2, i // 2
        x0 = left + col * (tile + gap)
        y0 = top + row * (tile + gap)
        draw_tile(draw, (x0, y0, x0 + tile, y0 + tile),
                  radius, tile_color, shadow_offset)
        draw_centered_text(draw, (x0 + tile / 2, y0 + tile / 2),
                           num, font, num_color)


def render_icon(size=1024, tile_frac=0.30, transparent=False):
    """数字タイル2x2のアイコンを描く。
    transparent=True で背景なし（Android adaptive iconの前景用）"""
    s = size * SS
    if transparent:
        img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    else:
        img = vertical_gradient((s, s), BG_TOP, BG_BOTTOM).convert("RGBA")
    draw_number_tiles(img, tile_frac)
    return img.resize((size, size), Image.LANCZOS)


def render_background(size=1024):
    """Android adaptive iconの背景用グラデーション（タイルなし）"""
    s = size * SS
    return vertical_gradient((s, s), BG_TOP, BG_BOTTOM).resize(
        (size, size), Image.LANCZOS)


def round_corners(img, radius_frac=0.225):
    """一般的なアプリアイコンの角丸（角を透過）にする。Web/Windows用"""
    size = img.width
    big = size * 4
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, big - 1, big - 1), radius=round(big * radius_frac), fill=255)
    mask = mask.resize((size, size), Image.LANCZOS)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def render_feature_graphic(w=1024, h=500):
    """Google Play用フィーチャーグラフィック"""
    s_w, s_h = w * SS, h * SS
    img = vertical_gradient((s_w, s_h), BG_TOP, BG_BOTTOM).convert("RGBA")
    draw = ImageDraw.Draw(img, "RGBA")

    # 左側: 縦にジグザグに並ぶ数字タイル（テキスト領域と重ならない幅に収める）
    tile = round(s_h * 0.26)
    radius = round(tile * 0.22)
    shadow_offset = round(s_h * 0.012)
    num_font = ImageFont.truetype(font_path(), round(tile * 0.6))
    tiles = [
        ("1", ACCENT, TILE_WHITE, 0.05, 0.08),
        ("2", TILE_WHITE, NUM_BLUE, 0.13, 0.37),
        ("3", TILE_WHITE, NUM_BLUE, 0.05, 0.66),
    ]
    for num, tile_color, num_color, fx, fy in tiles:
        x0, y0 = round(s_w * fx), round(s_h * fy)
        draw_tile(draw, (x0, y0, x0 + tile, y0 + tile),
                  radius, tile_color, shadow_offset)
        draw_centered_text(draw, (x0 + tile / 2, y0 + tile / 2),
                           num, num_font, num_color)

    # 右側: タイトルとキャッチコピー
    title_font = ImageFont.truetype(font_path(), round(s_h * 0.14))
    tagline_font = ImageFont.truetype(font_path(), round(s_h * 0.066))
    text_cx = s_w * 0.63
    draw_centered_text(draw, (text_cx, s_h * 0.38),
                       "Touch the Number", title_font, TILE_WHITE)
    draw_centered_text(draw, (text_cx, s_h * 0.58),
                       "数字を順にタップ！脳トレタイムアタック",
                       tagline_font, (255, 255, 255, 235))

    return img.resize((w, h), Image.LANCZOS)


def main():
    icon_dir = os.path.join(ROOT, "assets", "icon")
    store_dir = os.path.join(ROOT, "store")
    os.makedirs(icon_dir, exist_ok=True)
    os.makedirs(store_dir, exist_ok=True)

    icon = render_icon(1024)
    icon.save(os.path.join(icon_dir, "app_icon.png"))
    round_corners(icon).save(os.path.join(icon_dir, "app_icon_rounded.png"))
    # Android アダプティブアイコン用の2レイヤー。
    # 前景=数字タイルのみ（透過）。端末が外周を削るため、タイルを少し小さめ
    # （tile_frac=0.27）にしてセーフゾーンに収める。
    # 背景=グラデーションのみ。これで端末/ユーザー設定のマスク（円・角丸・
    # スクワークル等）に追従して形が変わる（固定しない）。
    render_icon(1024, tile_frac=0.27, transparent=True).save(
        os.path.join(icon_dir, "app_icon_foreground.png"))
    render_background(1024).save(
        os.path.join(icon_dir, "app_icon_background.png"))
    icon.resize((512, 512), Image.LANCZOS).save(
        os.path.join(store_dir, "icon_512.png"))
    render_feature_graphic().save(
        os.path.join(store_dir, "feature_graphic.png"))

    print("generated: assets/icon/app_icon.png, "
          "assets/icon/app_icon_rounded.png, "
          "assets/icon/app_icon_foreground.png, "
          "assets/icon/app_icon_background.png, "
          "store/icon_512.png, store/feature_graphic.png")


if __name__ == "__main__":
    main()

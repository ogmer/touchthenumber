"""アプリアイコンとストア用画像を生成する。
使い方: py tool/generate_icons.py  (要: py -m pip install pillow)

生成物:
  assets/icon/app_icon.png   1024x1024 マスターアイコン（flutter_launcher_iconsの入力）
  store/icon_512.png         Google Play ストア掲載用アイコン
  store/feature_graphic.png  Google Play フィーチャーグラフィック (1024x500)

デザイン: ゲーム画面と同じ「丸角の数字タイル」モチーフ。
角丸はストア/OS側で自動適用されるため、マスターは全面塗りで出力する。
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


def render_icon(size=1024):
    """数字タイル2x2のアイコンを描く"""
    s = size * SS
    img = vertical_gradient((s, s), BG_TOP, BG_BOTTOM).convert("RGBA")
    draw = ImageDraw.Draw(img, "RGBA")

    tile = round(s * 0.30)          # タイル一辺
    gap = round(s * 0.045)          # タイル間隔
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

    return img.resize((size, size), Image.LANCZOS)


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
    icon.resize((512, 512), Image.LANCZOS).save(
        os.path.join(store_dir, "icon_512.png"))
    render_feature_graphic().save(
        os.path.join(store_dir, "feature_graphic.png"))

    print("generated: assets/icon/app_icon.png, "
          "store/icon_512.png, store/feature_graphic.png")


if __name__ == "__main__":
    main()

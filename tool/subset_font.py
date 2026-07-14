"""アプリで使う文字だけに絞った日本語フォントのサブセットを生成する。
使い方: py tool/subset_font.py  (要: py -m pip install fonttools brotli)
元フォント(M PLUS Rounded 1c)が無ければ google/fonts から自動ダウンロードする。
lib配下のDartソースに新しい日本語を足したら再実行すること。
"""
import glob
import os
import urllib.request
from fontTools import subset

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DIR = os.path.join(ROOT, "tool", "_font_src")
OUT_DIR = os.path.join(ROOT, "assets", "fonts")
SRC_URL = "https://github.com/google/fonts/raw/main/ofl/mplusrounded1c/"

def ensure_source(name: str) -> str:
    """元フォントが無ければダウンロードして、そのパスを返す"""
    os.makedirs(SRC_DIR, exist_ok=True)
    path = os.path.join(SRC_DIR, name)
    if not os.path.exists(path):
        print(f"downloading {name} ...")
        urllib.request.urlretrieve(SRC_URL + name, path)
    return path

# 1) Dartソースに出現する全文字を集める
chars = set()
for path in glob.glob(os.path.join(ROOT, "lib", "**", "*.dart"), recursive=True):
    with open(path, encoding="utf-8") as f:
        chars.update(f.read())

# 2) 将来のテキスト追加に備え、かな全域・ASCII・和文記号も含める
for cp in range(0x20, 0x7F):            # ASCII印字可能文字
    chars.add(chr(cp))
for cp in range(0x3040, 0x30FF + 1):    # ひらがな・カタカナ
    chars.add(chr(cp))
for cp in range(0xFF00, 0xFFEF + 1):    # 全角英数・記号
    chars.add(chr(cp))
chars.update("　、。・「」『』（）！？…〜ー℃°％＆")

# 制御文字は除外
unicodes = sorted(ord(c) for c in chars if ord(c) >= 0x20)
print(f"subset chars: {len(unicodes)}")

os.makedirs(OUT_DIR, exist_ok=True)

for name in ["MPLUSRounded1c-Regular.ttf", "MPLUSRounded1c-Bold.ttf"]:
    src = ensure_source(name)
    out = os.path.join(OUT_DIR, name)
    options = subset.Options()
    options.flavor = None            # TTFのまま出力
    options.desubroutinize = True
    options.recalc_bounds = True
    options.notdef_outline = True
    options.name_IDs = ["*"]
    options.name_legacy = True
    font = subset.load_font(src, options)
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(unicodes=unicodes)
    subsetter.subset(font)
    subset.save_font(font, out, options)
    before = os.path.getsize(src)
    after = os.path.getsize(out)
    print(f"{name}: {before // 1024}KB -> {after // 1024}KB")

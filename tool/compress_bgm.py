"""BGMのWAVをMP3に圧縮してアプリサイズを削減する。
使い方: py tool/compress_bgm.py  (要: py -m pip install lameenc)

generate_sounds.dart でWAVを生成した後に実行する。BGMは長く非圧縮WAVだと
数MBになるため、全プラットフォーム（iOS/Android/Web/デスクトップ）で再生できる
MP3に変換する（OGGはiOSのAVFoundationで再生できないため使わない）。
効果音(correct/error/complete)は短く既に小さいのでWAVのまま残す。
"""
import os
import wave
import lameenc

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SND = os.path.join(ROOT, "assets", "sounds")
BITRATE = 96  # kbps。22.05kHzモノラルのBGMには十分な音質

for name in ["bgm", "bgm_title"]:
    wav_path = os.path.join(SND, name + ".wav")
    if not os.path.exists(wav_path):
        print(f"skip: {name}.wav が無い")
        continue

    w = wave.open(wav_path, "rb")
    assert w.getsampwidth() == 2 and w.getnchannels() == 1, "16bitモノラル前提"
    pcm = w.readframes(w.getnframes())
    rate = w.getframerate()
    w.close()

    enc = lameenc.Encoder()
    enc.set_bit_rate(BITRATE)
    enc.set_in_sample_rate(rate)
    enc.set_channels(1)
    enc.set_quality(2)  # 2 = high quality
    mp3 = enc.encode(pcm) + enc.flush()

    with open(os.path.join(SND, name + ".mp3"), "wb") as f:
        f.write(mp3)
    os.remove(wav_path)  # 圧縮済みの元WAVは削除
    print(f"{name}.wav ({len(pcm) // 1024}KB PCM) -> "
          f"{name}.mp3 ({len(mp3) // 1024}KB)")

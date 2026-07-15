// 効果音のWAVファイルを生成するスクリプト
// 実行: dart run tool/generate_sounds.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

// 22.05kHz（ナイキスト11kHz）。このアプリの合成音は最高倍音が約7.3kHzで
// 十分収まるため、44.1kHzに対して音質をほぼ落とさずファイルサイズを半減できる
const int sampleRate = 22050;

void main() {
  final outDir = Directory('assets/sounds');
  outDir.createSync(recursive: true);

  File('${outDir.path}/correct.wav').writeAsBytesSync(_wav(_correctTone()));
  File('${outDir.path}/error.wav').writeAsBytesSync(_wav(_errorTone()));
  File('${outDir.path}/complete.wav').writeAsBytesSync(_wav(_completeTone()));
  File('${outDir.path}/bgm.wav').writeAsBytesSync(_wav(_bgmTrack()));
  File('${outDir.path}/bgm_title.wav').writeAsBytesSync(_wav(_titleBgmTrack()));

  stdout.writeln(
      'Generated: correct.wav, error.wav, complete.wav, bgm.wav, bgm_title.wav');
}

/// 正解音: 短く明るいベル風の音（880Hz + 倍音）
List<double> _correctTone() {
  return _tone(
    frequencies: [880.0, 1760.0],
    amplitudes: [0.45, 0.15],
    duration: 0.10,
    decay: 30.0,
  );
}

/// ミス音: 低いブザー音（矩形波風）
List<double> _errorTone() {
  return _tone(
    frequencies: [160.0, 480.0, 800.0],
    amplitudes: [0.35, 0.12, 0.07],
    duration: 0.18,
    decay: 12.0,
  );
}

/// クリア音: 上昇アルペジオ（C5 → E5 → G5 → C6）
List<double> _completeTone() {
  const notes = [523.25, 659.25, 783.99, 1046.50];
  const noteLength = 0.13;
  const lastRingOut = 0.40;

  final samples = <double>[];
  for (var i = 0; i < notes.length; i++) {
    final isLast = i == notes.length - 1;
    samples.addAll(_tone(
      frequencies: [notes[i], notes[i] * 2],
      amplitudes: [0.40, 0.12],
      duration: isLast ? lastRingOut : noteLength,
      decay: isLast ? 8.0 : 20.0,
    ));
  }
  return samples;
}

/// プレイ中BGM: 寿司打風のポップで疾走感のあるチップチューン。
/// キック＋ハイハットのリズムに跳ねるベース、ヨナ抜き音階の
/// 和風メロディを乗せた C→Am→F→G 進行の8小節（約12秒）シームレスループ
List<double> _bgmTrack() {
  const bpm = 155.0;
  const beatSec = 60.0 / bpm;
  const eighthSec = beatSec / 2;
  const barSec = beatSec * 4;
  const bars = 8;
  final totalLength = (sampleRate * barSec * bars).round();
  final buffer = List<double>.filled(totalLength, 0.0);
  final noiseRandom = Random(20260713); // 再生成しても同じ音になるよう固定シード

  double note(int midi) => 440.0 * pow(2.0, (midi - 69) / 12.0);

  // 小節末尾で減衰しきらない音は先頭に折り返して書き込み、
  // ループの継ぎ目でクリックノイズが出ないようにする。
  // partials は奇数倍音（1,3,5倍…）の音量比。矩形波風の明るい音を作る
  void addTone({
    required double startSec,
    required double durSec,
    required double freq,
    required double amp,
    required double decay,
    List<double> partials = const [1.0],
  }) {
    final start = (startSec * sampleRate).round();
    final length = (durSec * sampleRate).round();
    const attackSamples = sampleRate * 0.005;
    for (var i = 0; i < length; i++) {
      final t = i / sampleRate;
      final attack = i < attackSamples ? i / attackSamples : 1.0;
      var value = 0.0;
      for (var h = 0; h < partials.length; h++) {
        value += partials[h] * sin(2 * pi * freq * (h * 2 + 1) * t);
      }
      buffer[(start + i) % totalLength] += amp * value * attack * exp(-decay * t);
    }
  }

  // キック: ピッチが急降下する短いサイン波
  void addKick(double startSec) {
    final start = (startSec * sampleRate).round();
    final length = (sampleRate * 0.09).round();
    var phase = 0.0;
    for (var i = 0; i < length; i++) {
      final t = i / sampleRate;
      final freq = 45.0 + 110.0 * exp(-30 * t);
      phase += 2 * pi * freq / sampleRate;
      buffer[(start + i) % totalLength] += 0.28 * sin(phase) * exp(-28 * t);
    }
  }

  // ハイハット: 短いホワイトノイズ
  void addHat(double startSec, double amp) {
    final start = (startSec * sampleRate).round();
    final length = (sampleRate * 0.03).round();
    for (var i = 0; i < length; i++) {
      final t = i / sampleRate;
      buffer[(start + i) % totalLength] +=
          amp * (noiseRandom.nextDouble() * 2 - 1) * exp(-130 * t);
    }
  }

  // コード進行: C→Am→F→G を2周（スタブ用3音のMIDIノート）
  const chords = [
    [60, 64, 67], // C:  C4 E4 G4
    [57, 60, 64], // Am: A3 C4 E4
    [53, 57, 60], // F:  F3 A3 C4
    [55, 59, 62], // G:  G3 B3 D4
  ];
  const bassRoots = [48, 45, 41, 43]; // C3 A2 F2 G2

  // メロディ: 小節ごとの [8分音符位置, MIDIノート, 長さ(8分音符数)]。
  // ヨナ抜き長音階（ド・レ・ミ・ソ・ラ）だけで作った和風の旋律。
  // 8小節目は音階を駆け上がってループ頭に戻る
  const melody = [
    [[0, 76, 1], [1, 79, 1], [2, 81, 1], [3, 79, 1], [4, 76, 2], [6, 74, 2]],
    [[0, 72, 1], [1, 74, 1], [2, 76, 1], [3, 74, 1], [4, 72, 2], [6, 69, 2]],
    [[0, 69, 1], [1, 72, 1], [2, 74, 1], [3, 72, 1], [4, 69, 2], [6, 67, 2]],
    [[0, 67, 1], [1, 69, 1], [2, 72, 1], [3, 74, 1], [4, 76, 2], [6, 74, 2]],
    [[0, 76, 1], [1, 79, 1], [2, 81, 1], [3, 79, 1], [4, 76, 2], [6, 74, 2]],
    [[0, 72, 1], [1, 76, 1], [2, 79, 1], [3, 76, 1], [4, 74, 2], [6, 72, 2]],
    [[0, 69, 1], [1, 72, 1], [2, 69, 1], [3, 67, 1], [4, 64, 2], [6, 67, 2]],
    [[0, 67, 1], [1, 69, 1], [2, 72, 1], [3, 74, 1], [4, 79, 4]],
  ];

  for (var bar = 0; bar < bars; bar++) {
    final barStart = bar * barSec;
    final chordIndex = bar % chords.length;
    final chord = chords[chordIndex];

    // リズム: キックは1・3拍目、ハイハットは8分刻み（裏拍を強め）
    addKick(barStart);
    addKick(barStart + beatSec * 2);
    for (var e = 0; e < 8; e++) {
      addHat(barStart + e * eighthSec, e.isOdd ? 0.09 : 0.045);
    }

    // ベース: ルートと5度を8分で行き来する跳ねるオムパ・ベース
    for (var e = 0; e < 8; e++) {
      final midi = e.isEven ? bassRoots[chordIndex] : bassRoots[chordIndex] + 7;
      addTone(
        startSec: barStart + e * eighthSec,
        durSec: eighthSec * 0.9,
        freq: note(midi),
        amp: 0.15,
        decay: 9.0,
        partials: [1.0, 0.15],
      );
    }

    // コードスタブ: 裏拍で短く刻んでポップな弾みを出す
    for (final e in [1, 3, 5, 7]) {
      for (final midi in chord) {
        addTone(
          startSec: barStart + e * eighthSec,
          durSec: eighthSec,
          freq: note(midi),
          amp: 0.03,
          decay: 16.0,
          partials: [1.0, 0.2],
        );
      }
    }

    // メロディ: 箏の爪弾き風（倍音多め＋強めの減衰）のリード
    for (final n in melody[bar]) {
      addTone(
        startSec: barStart + n[0] * eighthSec,
        durSec: n[2] * eighthSec * 1.2,
        freq: note(n[1]),
        amp: 0.13,
        decay: 6.0,
        partials: [1.0, 0.40, 0.18],
      );
    }
  }

  return buffer;
}

/// タイトルBGM: プレイ中より落ち着きつつも明るい曲調のループ(108BPM)。
/// ドラムなしで、パッド和音・2分音符のベース・高めの音域で動く
/// ヨナ抜き音階のメロディ・小節頭のベルを重ねた4小節（約9秒）。
/// C→F→G→C の進行なのでループの継ぎ目で気持ちよく解決する
List<double> _titleBgmTrack() {
  const bpm = 108.0;
  const beatSec = 60.0 / bpm;
  const eighthSec = beatSec / 2;
  const barSec = beatSec * 4;
  const bars = 4;
  final totalLength = (sampleRate * barSec * bars).round();
  final buffer = List<double>.filled(totalLength, 0.0);

  double note(int midi) => 440.0 * pow(2.0, (midi - 69) / 12.0);

  // ループ端で折り返して書き込むのはプレイ中BGMと同じ。
  // パッド用に attackSec（立ち上がり時間）と末尾フェードを持つ
  void addTone({
    required double startSec,
    required double durSec,
    required double freq,
    required double amp,
    required double decay,
    double attackSec = 0.01,
    List<double> partials = const [1.0],
  }) {
    final start = (startSec * sampleRate).round();
    final length = (durSec * sampleRate).round();
    final attackSamples = (attackSec * sampleRate).round().clamp(1, length);
    const releaseSamples = 2000; // 末尾約45msをフェードしてクリック音を防ぐ
    for (var i = 0; i < length; i++) {
      final t = i / sampleRate;
      final attack = i < attackSamples ? i / attackSamples : 1.0;
      final release =
          i > length - releaseSamples ? (length - i) / releaseSamples : 1.0;
      var value = 0.0;
      for (var h = 0; h < partials.length; h++) {
        value += partials[h] * sin(2 * pi * freq * (h * 2 + 1) * t);
      }
      buffer[(start + i) % totalLength] +=
          amp * value * attack * exp(-decay * t) * release;
    }
  }

  // コード進行: C → F → G → C（明るく、Gからループ頭のCへ解決する）
  const chords = [
    [60, 64, 67], // C:  C4 E4 G4
    [57, 60, 65], // F:  A3 C4 F4（高め寄りの明るいボイシング）
    [59, 62, 67], // G:  B3 D4 G4
    [60, 64, 67], // C
  ];
  const bassRoots = [48, 53, 55, 48]; // C3 F3 G3 C3（高めで軽やかに）

  // メロディ: [8分音符位置, MIDIノート, 長さ(8分音符数)]。
  // ヨナ抜き音階の高めの音域で、動きのある明るいフレーズ
  const melody = [
    [[0, 76, 2], [2, 79, 1], [3, 81, 1], [4, 79, 2], [6, 76, 2]],
    [[0, 74, 2], [2, 76, 1], [3, 74, 1], [4, 72, 2], [6, 69, 2]],
    [[0, 74, 2], [2, 76, 1], [3, 79, 1], [4, 81, 2], [6, 79, 2]],
    [[0, 84, 2], [2, 81, 1], [3, 79, 1], [4, 76, 2], [6, 74, 2]],
  ];

  for (var bar = 0; bar < bars; bar++) {
    final barStart = bar * barSec;
    final chord = chords[bar];

    // ベース: 2分音符×2で軽い鼓動感を出す
    for (var half = 0; half < 2; half++) {
      addTone(
        startSec: barStart + half * barSec / 2,
        durSec: barSec / 2,
        freq: note(bassRoots[bar]),
        amp: 0.13,
        decay: 1.2,
        attackSec: 0.02,
        partials: [1.0, 0.1],
      );
    }

    // パッド: ふわっと立ち上がる和音
    for (final midi in chord) {
      addTone(
        startSec: barStart,
        durSec: barSec,
        freq: note(midi),
        amp: 0.05,
        decay: 0.15,
        attackSec: 0.25,
      );
    }

    // ベル: 小節頭にきらっとした高音を添える
    addTone(
      startSec: barStart,
      durSec: barSec * 0.5,
      freq: note(chord[2] + 24),
      amp: 0.03,
      decay: 4.0,
      attackSec: 0.005,
      partials: [1.0, 0.2],
    );

    // メロディ: 箏風の明るいフレーズ
    for (final n in melody[bar]) {
      addTone(
        startSec: barStart + n[0] * eighthSec,
        durSec: n[2] * eighthSec * 1.2,
        freq: note(n[1]),
        amp: 0.11,
        decay: 3.0,
        attackSec: 0.008,
        partials: [1.0, 0.35, 0.15],
      );
    }
  }

  return buffer;
}

/// 指定した周波数の正弦波を合成し、アタック＋指数減衰の
/// エンベロープをかけたサンプル列を返す
List<double> _tone({
  required List<double> frequencies,
  required List<double> amplitudes,
  required double duration,
  required double decay,
}) {
  final length = (sampleRate * duration).round();
  const attackSamples = sampleRate * 0.005; // 5msアタックでクリックノイズを防ぐ

  return List.generate(length, (i) {
    final t = i / sampleRate;
    var value = 0.0;
    for (var f = 0; f < frequencies.length; f++) {
      value += amplitudes[f] * sin(2 * pi * frequencies[f] * t);
    }
    final attack = i < attackSamples ? i / attackSamples : 1.0;
    return value * attack * exp(-decay * t);
  });
}

/// 16bit PCM モノラルのWAVバイト列を組み立てる
Uint8List _wav(List<double> samples) {
  final dataSize = samples.length * 2;
  final bytes = ByteData(44 + dataSize);

  void writeString(int offset, String s) {
    for (var i = 0; i < s.length; i++) {
      bytes.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  writeString(0, 'RIFF');
  bytes.setUint32(4, 36 + dataSize, Endian.little);
  writeString(8, 'WAVE');
  writeString(12, 'fmt ');
  bytes.setUint32(16, 16, Endian.little); // fmtチャンクサイズ
  bytes.setUint16(20, 1, Endian.little); // PCM
  bytes.setUint16(22, 1, Endian.little); // モノラル
  bytes.setUint32(24, sampleRate, Endian.little);
  bytes.setUint32(28, sampleRate * 2, Endian.little); // バイトレート
  bytes.setUint16(32, 2, Endian.little); // ブロックアライン
  bytes.setUint16(34, 16, Endian.little); // ビット深度
  writeString(36, 'data');
  bytes.setUint32(40, dataSize, Endian.little);

  for (var i = 0; i < samples.length; i++) {
    final clamped = samples[i].clamp(-1.0, 1.0);
    bytes.setInt16(44 + i * 2, (clamped * 32767).round(), Endian.little);
  }

  return bytes.buffer.asUint8List();
}

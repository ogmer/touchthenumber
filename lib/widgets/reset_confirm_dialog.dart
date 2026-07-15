import 'package:flutter/material.dart';

/// 「リセットしますか？」の確認ダイアログを表示する。
/// ランキング・統計画面で重複していた実装の共通化。
/// リセットが選ばれたときだけ true を返す
Future<bool> showResetConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('リセット'),
        ),
      ],
    ),
  );
  return confirmed == true;
}

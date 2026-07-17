import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// 「リセットしますか？」の確認ダイアログを表示する。
/// ランキング・統計画面で重複していた実装の共通化。
/// リセットが選ばれたときだけ true を返す
Future<bool> showResetConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(l10n.reset),
        ),
      ],
    ),
  );
  return confirmed == true;
}

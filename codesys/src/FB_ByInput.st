(*
 * FB_ByInput
 * 目的 : VAR_INPUT（コピー渡し）の確認。
 *        呼んだ瞬間に構造体まるごとが FB の中へコピーされる。
 *
 * 確かめること:
 *   - 途中で元データが書き換わっても、FB の中の値は変わらない（bSnapshotKept = TRUE）
 *   - 外から fbInput.stIn を覗ける（モニタで展開できる）
 *
 * 入力 : stIn      渡されたデータ（コピー）
 *        bDisturb  TRUE で、処理の途中に元データを書き換える（別タスクの割り込みを再現）
 * 出力 : nSeenFirst / nSeenSecond  書き換え前後に FB が見た nCounter
 *        bSnapshotKept             前後で同じ値だったか
 * 履歴 : 2026-11-03 新規作成
 *)
FUNCTION_BLOCK FB_ByInput
VAR_INPUT
    stIn     : ST_PassData;
    bDisturb : BOOL;
END_VAR
VAR_OUTPUT
    nSeenFirst    : DINT;
    nSeenSecond   : DINT;
    bSnapshotKept : BOOL;
END_VAR

nSeenFirst := stIn.nCounter;
IF bDisturb THEN
    FC_DisturbOtherTask();          // 元データ（GVL）の nCounter を +1000
END_IF
nSeenSecond := stIn.nCounter;      // コピーなので、さっきと同じ値のはず
bSnapshotKept := nSeenFirst = nSeenSecond;

// 実験: 下のコメントを外してもコンパイルは通る。書き換わるのは FB 内のコピーだけで、元データは無傷
// stIn.nCounter := 0;

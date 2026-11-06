(*
 * FB_ByInOutConst
 * 目的 : VAR_IN_OUT CONSTANT（場所を渡す・読むだけ）の確認。
 *        コピーはせず、呼び出し元の変数そのものを見る。
 *
 * 確かめること:
 *   - 途中で元データが書き換わると、FB の中の値も変わる（bSnapshotKept = FALSE）
 *   - FB の中から書き換えようとするとコンパイルエラー（CONSTANT の効果）
 *   - 外から fbInOut.stIn は覗けない。モニタでどう表示されるか
 *
 * 入力 : stIn      呼び出し元のデータ（参照・読み取り専用）
 *        bDisturb  TRUE で、処理の途中に元データを書き換える
 * 出力 : FB_ByInput と同じ
 * 履歴 : 2026-11-03 新規作成
 *)
FUNCTION_BLOCK FB_ByInOutConst
VAR_IN_OUT CONSTANT
    stIn : ST_PassData;
END_VAR
VAR_INPUT
    bDisturb : BOOL;
END_VAR
VAR_OUTPUT
    nSeenFirst    : DINT;
    nSeenSecond   : DINT;
    bSnapshotKept : BOOL;
END_VAR

nSeenFirst := stIn.nCounter;
IF bDisturb THEN
    FC_DisturbOtherTask();
END_IF
nSeenSecond := stIn.nCounter;      // 元データを直接見ているので、+1000 された値が見える
bSnapshotKept := nSeenFirst = nSeenSecond;

// 実験: 下のコメントを外すとコンパイルエラー（CONSTANT なので書けない）
// stIn.nCounter := 0;

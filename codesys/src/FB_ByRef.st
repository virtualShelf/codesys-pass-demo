(*
 * FB_ByRef
 * 目的 : REFERENCE TO（場所を登録しておく）の確認。CODESYS 独自の機能。
 *        呼び出し側が  fbRef.refIn REF= 変数;  で場所を登録してから呼ぶ。
 *
 * 確かめること:
 *   - VAR_IN_OUT と同じく、途中の書き換えが見える（bSnapshotKept = FALSE）
 *   - 登録していないインスタンスは bRefValid = FALSE になり、何もしない
 *   - 外から fbRef.refIn を覗いたとき、モニタでどう表示されるか
 *
 * 入力 : refIn     データの場所（REF= で登録）
 *        bDisturb  TRUE で、処理の途中に元データを書き換える
 * 出力 : bRefValid  refIn が有効か（__ISVALIDREF の結果）
 *        ほかは FB_ByInput と同じ
 * 履歴 : 2026-11-03 新規作成
 *)
FUNCTION_BLOCK FB_ByRef
VAR_INPUT
    refIn    : REFERENCE TO ST_PassData;   // CODESYS 拡張（IEC 61131-3 の標準ではない）
    bDisturb : BOOL;
END_VAR
VAR_OUTPUT
    bRefValid     : BOOL;
    nSeenFirst    : DINT;
    nSeenSecond   : DINT;
    bSnapshotKept : BOOL;
END_VAR

// 登録されていない参照を読むと例外で PLC が止まる。必ず先に確かめる
bRefValid := __ISVALIDREF(refIn);   // CODESYS 拡張
IF NOT bRefValid THEN
    nSeenFirst    := 0;
    nSeenSecond   := 0;
    bSnapshotKept := FALSE;
    RETURN;
END_IF

nSeenFirst := refIn.nCounter;      // 普通の変数と同じ書き方で読める
IF bDisturb THEN
    FC_DisturbOtherTask();
END_IF
nSeenSecond := refIn.nCounter;
bSnapshotKept := nSeenFirst = nSeenSecond;

// 実験: 下のコメントを外すとコンパイルは通り、元データが書き換わる（REFERENCE には CONSTANT がない）
// refIn.nCounter := 0;

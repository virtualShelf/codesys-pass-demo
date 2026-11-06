(*
 * PRG_Bench
 * 目的 : 渡し方による処理時間の違いを見る。
 *        選んだ渡し方で、16 KB の構造体を nCalls 回 FB に渡す。
 *        BenchTask の周期時間を「タスク設定 → モニタ」で見て比べる。
 *
 * モニタから切り替えるもの:
 *   eMode   NONE / BY_INPUT / BY_INOUT / BY_REF
 *   nCalls  1 サイクルに呼ぶ回数（0〜MAX_CALLS）
 *
 * 履歴 : 2026-11-03 新規作成
 *)
PROGRAM PRG_Bench
VAR
    eMode    : E_PassMode := E_PassMode.NONE;
    nCalls   : INT := 100;
    nDone    : INT;           (* 実際に呼んだ回数 *)
    i        : INT;
    fbInput  : FB_ByInput;
    fbInOut  : FB_ByInOutConst;
    fbRef    : FB_ByRef;
END_VAR

nCalls := LIMIT(0, nCalls, GVL_PassConst.MAX_CALLS);   // ループ回数に上限を置く
nDone  := 0;

CASE eMode OF
E_PassMode.NONE:
    ;   // 何もしない。この時の周期時間が基準

E_PassMode.BY_INPUT:
    FOR i := 1 TO nCalls DO
        fbInput(stIn := GVL_PassTest.stData, bDisturb := FALSE);   // 毎回 16 KB コピー
        nDone := nDone + 1;
    END_FOR

E_PassMode.BY_INOUT:
    FOR i := 1 TO nCalls DO
        fbInOut(stIn := GVL_PassTest.stData, bDisturb := FALSE);   // 場所だけ渡す
        nDone := nDone + 1;
    END_FOR

E_PassMode.BY_REF:
    fbRef.refIn REF= GVL_PassTest.stData;                         // CODESYS 拡張
    FOR i := 1 TO nCalls DO
        fbRef(bDisturb := FALSE);
        nDone := nDone + 1;
    END_FOR

ELSE
    eMode := E_PassMode.NONE;
END_CASE

(*
 * PRG_PassDemo
 * 目的 : 3 つの渡し方を、同じ元データ・同じ条件で並べて呼ぶ。
 *        オンラインでこの PRG を開き、各インスタンスを展開して見比べる。
 *
 * モニタから切り替えるもの（書き込み値を入れて Ctrl+F7）:
 *   bDisturb        TRUE: FB の処理途中で元データを書き換える
 *   bRefEveryCycle  TRUE: 毎サイクル REF= し直す / FALSE: 最初の1回だけ
 *
 * 履歴 : 2026-11-03 新規作成
 *)
PROGRAM PRG_PassDemo
VAR
    fbInput        : FB_ByInput;
    fbInOut        : FB_ByInOutConst;
    fbRef          : FB_ByRef;
    fbRefNotLinked : FB_ByRef;          (* わざと REF= しない。bRefValid = FALSE になるのを見る *)
    fbInOutRW      : FB_ByInOutRW;

    nCycle         : DINT;
    bDisturb       : BOOL := TRUE;
    bRefEveryCycle : BOOL := TRUE;
    bRefLinked     : BOOL;
    tonBlink       : TON;

    nDataSize      : UDINT;             (* 構造体の大きさ [byte]。コピーされる量の目安 *)
    nInstSizeInput : UDINT;             (* FB インスタンスの大きさ [byte] *)
    nInstSizeInOut : UDINT;
    nInstSizeRef   : UDINT;
END_VAR
VAR CONSTANT
    T_BLINK : TIME := T#500MS;
END_VAR

nCycle := nCycle + 1;

(* 元データを毎サイクル作り直す。FB ごとの比較を同じ条件にするため *)
tonBlink(IN := NOT tonBlink.Q, PT := T_BLINK);
IF tonBlink.Q THEN
    GVL_PassTest.stData.bFlag := NOT GVL_PassTest.stData.bFlag;
END_IF
GVL_PassTest.stData.aBig[0]                   := nCycle;
GVL_PassTest.stData.aBig[GVL_PassConst.N_BIG] := -nCycle;

(* ---- 1. VAR_INPUT（コピー） ---- *)
GVL_PassTest.stData.nCounter := nCycle;
fbInput(stIn := GVL_PassTest.stData, bDisturb := bDisturb);

(* ---- 2. VAR_IN_OUT CONSTANT（場所を渡す） ---- *)
GVL_PassTest.stData.nCounter := nCycle;          // 1. で +1000 された分を戻す
fbInOut(stIn := GVL_PassTest.stData, bDisturb := bDisturb);

(* ---- 3. REFERENCE TO（場所を登録） ---- *)
GVL_PassTest.stData.nCounter := nCycle;
IF bRefEveryCycle OR NOT bRefLinked THEN
    fbRef.refIn REF= GVL_PassTest.stData;        // CODESYS 拡張
    bRefLinked := TRUE;
END_IF
fbRef(bDisturb := bDisturb);

fbRefNotLinked(bDisturb := FALSE);              // refIn 未登録のまま呼ぶ

(* ---- 4. CONSTANT なしの VAR_IN_OUT（比較用） ---- *)
fbInOutRW(stData := GVL_PassTest.stData);       // stData.rValue が毎サイクル +1 される

(* 最後に、元データの nCounter を正しい値に戻しておく *)
GVL_PassTest.stData.nCounter := nCycle;

(* 大きさの確認 *)
nDataSize      := SIZEOF(GVL_PassTest.stData);
nInstSizeInput := SIZEOF(fbInput);    // 16 KB 超のはず（コピーを中に持つ）
nInstSizeInOut := SIZEOF(fbInOut);    // 小さいはず（場所だけ持つ）
nInstSizeRef   := SIZEOF(fbRef);      // 小さいはず（場所だけ持つ）

(* ---- 実験：1行ずつコメントを外して、コンパイル結果を見る ----
   nCycle := fbInOut.stIn.nCounter;   // VAR_IN_OUT は外から読めない → エラーの予想
   fbInOut(bDisturb := FALSE);        // VAR_IN_OUT を渡さずに呼ぶ → エラーの予想
   nCycle := fbRef.refIn.nCounter;    // REFERENCE は外から読める → 通る予想
   nCycle := fbInput.stIn.nCounter;   // VAR_INPUT は外から読める → 通る予想
*)

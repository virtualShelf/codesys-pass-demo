(*
 * FB_ByInOutRW
 * 目的 : CONSTANT を付けない VAR_IN_OUT の確認（比較用・悪い例）。
 *        FB が呼び出し元の変数を書き換えられてしまう。
 *
 * 確かめること:
 *   - GVL_PassTest.stData.rValue が、この FB を呼ぶたびに +1 される
 *   - 「入力のつもりで渡したら、中身を変えられていた」が起きる
 *
 * 入出力 : stData  呼び出し元のデータ（参照・読み書き可）
 * 履歴 : 2026-11-03 新規作成
 *)
FUNCTION_BLOCK FB_ByInOutRW
VAR_IN_OUT
    stData : ST_PassData;
END_VAR

stData.rValue := stData.rValue + 1.0;   // 呼び出し元の rValue が書き換わる

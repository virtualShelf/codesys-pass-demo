(*
 * GVL_PassConst
 * 目的 : 確認用の定数
 * 履歴 : 2026-11-03 新規作成
 *)
{attribute 'qualified_only'}  // CODESYS 拡張: GVL_PassConst.N_BIG の形でしか書けなくする
VAR_GLOBAL CONSTANT
    N_BIG      : INT := 4095;   (* 大きい配列の上限。DINT × 4096 = 16 KB *)
    MAX_CALLS  : INT := 1000;   (* ベンチマークで1サイクルに呼ぶ回数の上限 *)
END_VAR

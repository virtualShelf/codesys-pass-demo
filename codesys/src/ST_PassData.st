(*
 * ST_PassData
 * 目的 : 渡し方の比較に使う構造体。
 *        小さいメンバー（モニタで見る用）と、大きい配列（コピーの重さを見る用）を持つ。
 * 履歴 : 2026-11-03 新規作成
 *)
TYPE ST_PassData :
STRUCT
    nCounter : DINT;    (* 毎サイクル更新。FB がどの値を見たかの目印 *)
    rValue   : REAL;    (* FB_ByInOutRW が書き換える *)
    bFlag    : BOOL;    (* 0.5 秒ごとに点滅。モニタで「生きている」のが見える *)
    aBig     : ARRAY[0..GVL_PassConst.N_BIG] OF DINT;   (* 16 KB。コピーの負荷を見る用 *)
END_STRUCT
END_TYPE

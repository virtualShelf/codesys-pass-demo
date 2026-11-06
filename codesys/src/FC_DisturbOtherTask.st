(*
 * FC_DisturbOtherTask
 * 目的 : 「FB の処理の途中で、別のタスクが元データを書き換えた」状況を再現する。
 *        本物の別タスクだとタイミングが運任せになるので、FB の中からわざと呼んで必ず起こす。
 *        ※ 学習用。通常のコードで、FB の中から GVL を書き換えてはいけない。
 * 履歴 : 2026-11-03 新規作成
 *)
FUNCTION FC_DisturbOtherTask : BOOL
VAR CONSTANT
    N_JUMP : DINT := 1000;   (* 書き換えたことが一目で分かるよう、大きく足す *)
END_VAR

GVL_PassTest.stData.nCounter := GVL_PassTest.stData.nCounter + N_JUMP;
FC_DisturbOtherTask := TRUE;

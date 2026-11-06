(*
 * E_PassMode
 * 目的 : PRG_Bench で、どの渡し方を測るかを選ぶ
 * 履歴 : 2026-11-03 新規作成
 *)
{attribute 'qualified_only'}  // CODESYS 拡張
{attribute 'strict'}          // CODESYS 拡張
TYPE E_PassMode :
(
    NONE     := 0,   (* 何もしない（基準の周期を見る） *)
    BY_INPUT := 1,   (* VAR_INPUT（コピー） *)
    BY_INOUT := 2,   (* VAR_IN_OUT CONSTANT（場所を渡す） *)
    BY_REF   := 3    (* REFERENCE TO（場所を登録） *)
);
END_TYPE

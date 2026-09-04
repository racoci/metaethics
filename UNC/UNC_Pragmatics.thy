theory UNC_Pragmatics
  imports UNC
begin

(* 1. Speech Acts & Discursive Constants *)
consts ExecArgue :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts ExecAssert :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts Presuppose :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts N_ver :: "\<sigma>"
consts N_eq :: "\<sigma>"
consts p_discourse :: "p"

(* 2. Axioms of Discursive Constitutivity *)
axiomatization where
  argue_assert: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> ExecAssert a \<phi>\<rfloor>" and
  argue_presuppose_ver: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> Presuppose a N_ver\<rfloor>" and
  argue_presuppose_eq: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> Presuppose a N_eq\<rfloor>"

end

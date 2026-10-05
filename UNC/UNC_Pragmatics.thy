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

(* 3. Deontic Output under the Discourse Perspective *)
axiomatization where
  deontic_output_ver: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> \<^bold>O\<^sub>p_discourse N_ver\<rfloor>" and
  deontic_output_eq: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> \<^bold>O\<^sub>p_discourse N_eq\<rfloor>"

(* 4. Performative Contradiction Predicate *)
definition PC :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" where
  "PC a \<chi> \<equiv> \<lambda>w. (ExecAssert a \<chi>) w \<and> (\<exists>\<psi>. (Presuppose a \<psi>) w \<and> \<lfloor>\<chi> \<^bold>\<rightarrow> \<^bold>\<not>\<psi>\<rfloor>)"

(* 5. Transcendental Bridge Theorem (The Deduction) *)
theorem transcendental_bridge: "\<lfloor>ExecArgue a (\<^bold>\<not>N_ver) \<^bold>\<rightarrow> PC a (\<^bold>\<not>N_ver)\<rfloor>"
proof (intro allI impI)
  fix w
  assume h_argue: "ExecArgue a (\<^bold>\<not>N_ver) w"
  then have h_assert: "(ExecAssert a (\<^bold>\<not>N_ver)) w"
    using argue_assert by blast
  have h_presup: "(Presuppose a N_ver) w"
    using argue_presuppose_ver h_argue by blast
  have h_exists: "\<exists>\<psi>. (Presuppose a \<psi>) w \<and> \<lfloor>\<^bold>\<not>N_ver \<^bold>\<rightarrow> \<^bold>\<not>\<psi>\<rfloor>"
    apply (rule_tac x="N_ver" in exI)
    using h_presup by simp
  show "(PC a (\<^bold>\<not>N_ver)) w"
    using h_assert h_exists unfolding PC_def by auto
qed

(* 6. Model Satisfiability & Consistency (Avoid Modal Collapse) *)
lemma consistency_and_satisfiability:
  shows "\<exists>a \<phi> w. (ExecArgue a \<phi>) w"
  nitpick[satisfy]
  oops

end

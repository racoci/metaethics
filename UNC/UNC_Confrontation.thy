theory UNC_Confrontation
  imports UNC UNC_Bridges
begin

(* 1. Perspectives for Deontology and Rule Utilitarianism *)
consts p_kant :: p
consts p_util :: p

(* 2. Qualitative Utility & Instrumentalization Mappings *)
consts UtilityMax :: "act \<Rightarrow> i \<Rightarrow> bool"
consts Instrumentalize :: "a \<Rightarrow> \<sigma>"
consts ExecAssert :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"

(* 3. Metaethical Axioms of Deontology & Rule Utilitarianism *)
axiomatization where
  kant_definition: "\<forall>x act w. OptimalAct p_kant x act w \<longleftrightarrow> \<not>(\<exists>y. ExecAssert x (Instrumentalize y) w)" and
  util_definition: "\<forall>x act w. OptimalAct p_util x act w \<longleftrightarrow> UtilityMax act w"

(* 4. Selection set definition in terms of optimal actions *)
axiomatization where
  B_kant_def: "\<forall>w. B p_kant w = {v. \<forall>x act. OptimalAct p_kant x act w \<longrightarrow> Does x act v}" and
  B_util_def: "\<forall>w. B p_util w = {v. \<forall>x act. OptimalAct p_util x act w \<longrightarrow> Does x act v}"

(* 5. Conditional "No Conflict" / "Practical Convergence" Scenario *)
definition NoConflict :: "i \<Rightarrow> bool" where
  "NoConflict w \<equiv> \<forall>x act. UtilityMax act w \<longleftrightarrow> \<not>(\<exists>y. ExecAssert x (Instrumentalize y) w)"

(* 6. Theorem: Practical Convergence (Action-Level Equivalence) *)
theorem action_equivalence:
  assumes "NoConflict w"
  shows "OptimalAct p_kant x act w \<longleftrightarrow> OptimalAct p_util x act w"
  using assms kant_definition util_definition unfolding NoConflict_def by auto

(* 7. Theorem: Set-Level Equivalence of Optimal Selection Worlds *)
theorem B_set_equivalence:
  assumes "NoConflict w"
  shows "B p_kant w = B p_util w"
proof -
  have h_opt: "\<forall>x act. OptimalAct p_kant x act w \<longleftrightarrow> OptimalAct p_util x act w"
    using assms action_equivalence by auto
  then show ?thesis
    unfolding B_kant_def B_util_def by simp
qed

(* 8. Theorem: Local Deontic Equivalence under NoConflict *)
theorem local_deontic_equivalence:
  assumes "NoConflict w"
  shows "(UNCobligatory p_kant \<phi>) w \<longleftrightarrow> (UNCobligatory p_util \<phi>) w"
  unfolding DeonticEquiv_def
  using assms B_set_equivalence by auto

(* 9. Theorem: Global Deontic Equivalence under Global Harmony *)
theorem global_deontic_equivalence:
  assumes "\<forall>w. NoConflict w"
  shows "DeonticEquiv p_kant p_util"
  unfolding DeonticEquiv_def
proof (intro allI)
  fix \<phi> w
  have "B p_kant w = B p_util w"
    using assms B_set_equivalence by auto
  then show "UNCobligatory p_kant \<phi> w \<longleftrightarrow> UNCobligatory p_util \<phi> w"
    by auto
qed

(* 10. Model Satisfiability and Consistency Check using Nitpick *)
lemma consistency_check:
  "NoConflict w \<and> (UNCobligatory p_kant \<phi>) w"
  nitpick[satisfy, expect=genuine]
  oops

end

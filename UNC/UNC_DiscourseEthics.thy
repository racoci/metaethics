theory UNC_DiscourseEthics
  imports UNC UNC_Pragmatics
begin

(* 1. Speech Acts, Agents and Perspectives *)
consts Accepts :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts OptimalAct :: "p \<Rightarrow> a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"

(* 2. Axioms / Definition of the Universalization Principle (U) *)
axiomatization where
  U_principle: "\<forall>x N w. (OptimalAct p_discourse x N) w \<longleftrightarrow> (\<forall>a. (Accepts a N) w)"

(* 3. Convergence Condition between Procedural consensus and another Metaethical Perspective *)
definition ConvergenceCond :: "p \<Rightarrow> p \<Rightarrow> bool" where
  "ConvergenceCond p_dis p_other \<equiv> \<forall>x N w. (\<forall>a. (Accepts a N) w) \<longleftrightarrow> (\<^bold>O\<^sub>p_other N) w"

(* 4. Procedural Deontic Equivalence Theorem *)
theorem procedural_deontic_equivalence:
  assumes "ConvergenceCond p_discourse p_other"
  shows "\<forall>x N w. (OptimalAct p_discourse x N) w \<longleftrightarrow> (\<^bold>O\<^sub>p_other N) w"
proof (intro allI)
  fix x N w
  have h_U: "(OptimalAct p_discourse x N) w \<longleftrightarrow> (\<forall>a. (Accepts a N) w)"
    by (simp add: U_principle)
  have h_conv: "(\<forall>a. (Accepts a N) w) \<longleftrightarrow> (\<^bold>O\<^sub>p_other N) w"
    using assms unfolding ConvergenceCond_def by blast
  from h_U h_conv show "(OptimalAct p_discourse x N) w \<longleftrightarrow> (\<^bold>O\<^sub>p_other N) w"
    by simp
qed

(* 5. Consistency & Satisfiability Verification via Nitpick *)
lemma discourse_ethics_consistency:
  shows "\<exists>a N w. (Accepts a N) w"
  nitpick[satisfy, expect=genuine]
  oops

end

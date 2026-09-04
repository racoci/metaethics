theory UNC_Category
  imports UNC
begin

(* Preorder relation on perspectives *)
definition leq_p :: "p \<Rightarrow> p \<Rightarrow> bool" (infix "\<le>\<^sub>p" 50) where
  "p1 \<le>\<^sub>p p2 \<equiv> \<forall>\<phi> w. (UNCobligatory p2 \<phi>) w \<longrightarrow> (UNCobligatory p1 \<phi>) w"

(* Reflexivity *)
lemma leq_p_refl: "p \<le>\<^sub>p p"
  unfolding leq_p_def by simp

(* Transitivity *)
lemma leq_p_trans:
  assumes "p1 \<le>\<^sub>p p2" and "p2 \<le>\<^sub>p p3"
  shows "p1 \<le>\<^sub>p p3"
  using assms unfolding leq_p_def by blast

(* Monotonic Functors *)
definition mono_functor :: "(p \<Rightarrow> p) \<Rightarrow> bool" where
  "mono_functor F \<equiv> \<forall>p1 p2. p1 \<le>\<^sub>p p2 \<longrightarrow> (F p1) \<le>\<^sub>p (F p2)"

(* Galois Adjunction *)
definition adjunction :: "(p \<Rightarrow> p) \<Rightarrow> (p \<Rightarrow> p) \<Rightarrow> bool" where
  "adjunction F G \<equiv> \<forall>p1 p2. (F p1) \<le>\<^sub>p p2 \<longleftrightarrow> p1 \<le>\<^sub>p (G p2)"

(* Galois Connection properties *)
lemma adjunction_extensive:
  assumes "adjunction F G"
  shows "p \<le>\<^sub>p G (F p)"
  using assms leq_p_refl unfolding adjunction_def by blast

lemma adjunction_coextensive:
  assumes "adjunction F G"
  shows "F (G p) \<le>\<^sub>p p"
  using assms leq_p_refl unfolding adjunction_def by blast

lemma adjunction_mono_F:
  assumes "adjunction F G"
  shows "mono_functor F"
unfolding mono_functor_def
proof (safe)
  fix p1 p2
  assume "p1 \<le>\<^sub>p p2"
  have "p2 \<le>\<^sub>p G (F p2)" using assms adjunction_extensive by simp
  then have "p1 \<le>\<^sub>p G (F p2)" using \<open>p1 \<le>\<^sub>p p2\<close> leq_p_trans by blast
  then show "F p1 \<le>\<^sub>p F p2" using assms unfolding adjunction_def by blast
qed

lemma adjunction_mono_G:
  assumes "adjunction F G"
  shows "mono_functor G"
unfolding mono_functor_def
proof (safe)
  fix p1 p2
  assume "p1 \<le>\<^sub>p p2"
  have "F (G p1) \<le>\<^sub>p p1" using assms adjunction_coextensive by simp
  then have "F (G p1) \<le>\<^sub>p p2" using \<open>p1 \<le>\<^sub>p p2\<close> leq_p_trans by blast
  then show "G p1 \<le>\<^sub>p G p2" using assms unfolding adjunction_def by blast
qed

(* Idempotency of closure operator G ∘ F *)
lemma closure_idempotent_G_F:
  assumes "adjunction F G"
  shows "G (F (G (F p))) \<le>\<^sub>p G (F p)" (is ?L)
    and "G (F p) \<le>\<^sub>p G (F (G (F p)))" (is ?R)
proof -
  have "F (G (F p)) \<le>\<^sub>p F p" using assms adjunction_coextensive by simp
  then show ?L using assms adjunction_mono_G unfolding mono_functor_def by blast
next
  show ?R using assms adjunction_extensive by simp
qed

(* Isomorphism / equivalence of perspectives *)
definition equiv_p :: "p \<Rightarrow> p \<Rightarrow> bool" (infix "\<cong>\<^sub>p" 50) where
  "p1 \<cong>\<^sub>p p2 \<equiv> p1 \<le>\<^sub>p p2 \<and> p2 \<le>\<^sub>p p1"

lemma equiv_p_implies_deontic_equiv:
  assumes "p1 \<cong>\<^sub>p p2"
  shows "DeonticEquiv p1 p2"
  using assms unfolding equiv_p_def leq_p_def DeonticEquiv_def by blast

(* Fundamental Theorem: Galois Fixed Points yield Deontic Equivalence *)
theorem galois_fixed_point_deontic_equivalence:
  assumes "adjunction F G"
  assumes "G (F p) \<le>\<^sub>p p" (* Fixed point closure hypothesis *)
  shows "DeonticEquiv p (G (F p))"
proof -
  have "p \<le>\<^sub>p G (F p)" using assms(1) adjunction_extensive by simp
  then have "p \<cong>\<^sub>p G (F p)" using assms(2) unfolding equiv_p_def by simp
  then show ?thesis using equiv_p_implies_deontic_equiv by simp
qed

(* Satisfiability and consistency check with Nitpick *)
lemma adjunction_satisfiable:
  "adjunction F G \<Longrightarrow> \<exists>p. p \<cong>\<^sub>p G (F p)"
  nitpick[satisfy, expect=genuine]
  oops

end

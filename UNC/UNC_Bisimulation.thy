theory UNC_Bisimulation
  imports UNC
begin

consts Does :: "a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool"

datatype form =
    Atom "a" "act"
  | Not form
  | And form form
  | Oblig p form
  | Knows a form

fun eval :: "form \<Rightarrow> i \<Rightarrow> bool" (infix "\<Turnstile>" 60) where
  "(Atom x act) \<Turnstile> w = Does x act w"
| "(Not \<phi>) \<Turnstile> w = (\<not> (\<phi> \<Turnstile> w))"
| "(And \<phi> \<psi>) \<Turnstile> w = ((\<phi> \<Turnstile> w) \<and> (\<psi> \<Turnstile> w))"
| "(Oblig p \<phi>) \<Turnstile> w = (\<forall>v \<in> UNC.B p w. \<phi> \<Turnstile> v)"
| "(Knows x \<phi>) \<Turnstile> w = (\<forall>v. UNC.R_K x w v \<longrightarrow> \<phi> \<Turnstile> v)"

definition image_finite_B_at :: "p \<Rightarrow> i \<Rightarrow> bool" where
  "image_finite_B_at p w \<equiv> finite (UNC.B p w)"

definition image_finite_R_K_at :: "a \<Rightarrow> i \<Rightarrow> bool" where
  "image_finite_R_K_at x w \<equiv> finite {v. UNC.R_K x w v}"

definition image_finite_B :: "bool" where
  "image_finite_B \<equiv> \<forall>p w. image_finite_B_at p w"

definition image_finite_R_K :: "bool" where
  "image_finite_R_K \<equiv> \<forall>x w. image_finite_R_K_at x w"

definition Bisimulation :: "(i \<Rightarrow> i \<Rightarrow> bool) \<Rightarrow> bool" where
  "Bisimulation Z \<equiv> \<forall>w1 w2. Z w1 w2 \<longrightarrow>
      (\<forall>x act. Does x act w1 \<longleftrightarrow> Does x act w2) \<and>
      (\<forall>p v1. v1 \<in> UNC.B p w1 \<longrightarrow> (\<exists>v2. v2 \<in> UNC.B p w2 \<and> Z v1 v2)) \<and>
      (\<forall>p v2. v2 \<in> UNC.B p w2 \<longrightarrow> (\<exists>v1. v1 \<in> UNC.B p w1 \<and> Z v1 v2)) \<and>
      (\<forall>x v1. UNC.R_K x w1 v1 \<longrightarrow> (\<exists>v2. UNC.R_K x w2 v2 \<and> Z v1 v2)) \<and>
      (\<forall>x v2. UNC.R_K x w2 v2 \<longrightarrow> (\<exists>v1. UNC.R_K x w1 v1 \<and> Z v1 v2))"

lemma bisimulation_invariance:
  assumes "Bisimulation Z"
  assumes "Z w1 w2"
  shows "\<phi> \<Turnstile> w1 \<longleftrightarrow> \<phi> \<Turnstile> w2"
using assms(2)
proof (induction \<phi> arbitrary: w1 w2)
  case (Atom x act w1 w2)
  then show ?case using assms(1) unfolding Bisimulation_def by auto
next
  case (Not \<phi> w1 w2)
  then show ?case by simp
next
  case (And \<phi> \<psi> w1 w2)
  then show ?case by simp
next
  case (Oblig p \<phi> w1 w2)
  have "(\<forall>v1 \<in> UNC.B p w1. \<phi> \<Turnstile> v1) = (\<forall>v2 \<in> UNC.B p w2. \<phi> \<Turnstile> v2)"
  proof
    assume H: "\<forall>v1 \<in> UNC.B p w1. \<phi> \<Turnstile> v1"
    show "\<forall>v2 \<in> UNC.B p w2. \<phi> \<Turnstile> v2"
    proof
      fix v2 assume "v2 \<in> UNC.B p w2"
      with `Z w1 w2` assms(1) obtain v1 where "v1 \<in> UNC.B p w1" and "Z v1 v2"
        unfolding Bisimulation_def by blast
      from `v1 \<in> UNC.B p w1` H have "\<phi> \<Turnstile> v1" by simp
      with Oblig.IH `Z v1 v2` show "\<phi> \<Turnstile> v2" by simp
    qed
  next
    assume H: "\<forall>v2 \<in> UNC.B p w2. \<phi> \<Turnstile> v2"
    show "\<forall>v1 \<in> UNC.B p w1. \<phi> \<Turnstile> v1"
    proof
      fix v1 assume "v1 \<in> UNC.B p w1"
      with `Z w1 w2` assms(1) obtain v2 where "v2 \<in> UNC.B p w2" and "Z v1 v2"
        unfolding Bisimulation_def by blast
      from `v2 \<in> UNC.B p w2` H have "\<phi> \<Turnstile> v2" by simp
      with Oblig.IH `Z v1 v2` show "\<phi> \<Turnstile> v1" by simp
    qed
  qed
  then show ?case by simp
next
  case (Knows x \<phi> w1 w2)
  have "(\<forall>v1. UNC.R_K x w1 v1 \<longrightarrow> \<phi> \<Turnstile> v1) = (\<forall>v2. UNC.R_K x w2 v2 \<longrightarrow> \<phi> \<Turnstile> v2)"
  proof
    assume H: "\<forall>v1. UNC.R_K x w1 v1 \<longrightarrow> \<phi> \<Turnstile> v1"
    show "\<forall>v2. UNC.R_K x w2 v2 \<longrightarrow> \<phi> \<Turnstile> v2"
    proof (intro allI impI)
      fix v2 assume "UNC.R_K x w2 v2"
      with `Z w1 w2` assms(1) obtain v1 where "UNC.R_K x w1 v1" and "Z v1 v2"
        unfolding Bisimulation_def by blast
      from `UNC.R_K x w1 v1` H have "\<phi> \<Turnstile> v1" by simp
      with Knows.IH `Z v1 v2` show "\<phi> \<Turnstile> v2" by simp
    qed
  next
    assume H: "\<forall>v2. UNC.R_K x w2 v2 \<longrightarrow> \<phi> \<Turnstile> v2"
    show "\<forall>v1. UNC.R_K x w1 v1 \<longrightarrow> \<phi> \<Turnstile> v1"
    proof (intro allI impI)
      fix v1 assume "UNC.R_K x w1 v1"
      with `Z w1 w2` assms(1) obtain v2 where "UNC.R_K x w2 v2" and "Z v1 v2"
        unfolding Bisimulation_def by blast
      from `UNC.R_K x w2 v2` H have "\<phi> \<Turnstile> v2" by simp
      with Knows.IH `Z v1 v2` show "\<phi> \<Turnstile> v1" by simp
    qed
  qed
  then show ?case by simp
qed

consts list_B :: "p \<Rightarrow> i \<Rightarrow> i list"
consts list_R_K :: "a \<Rightarrow> i \<Rightarrow> i list"

axiomatization where
  list_B_sound: "set (list_B p w) = UNC.B p w" and
  list_R_K_sound: "set (list_R_K x w) = {v. UNC.R_K x w v}"

fun conj_all :: "a \<Rightarrow> act \<Rightarrow> form list \<Rightarrow> form" where
  "conj_all x act [] = Not (And (Atom x act) (Not (Atom x act)))"
| "conj_all x act [\<phi>] = \<phi>"
| "conj_all x act (\<phi> # \<psi> # \<gamma>) = And \<phi> (conj_all x act (\<psi> # \<gamma>))"

fun disj_all :: "a \<Rightarrow> act \<Rightarrow> form list \<Rightarrow> form" where
  "disj_all x act [] = And (Atom x act) (Not (Atom x act))"
| "disj_all x act [\<phi>] = \<phi>"
| "disj_all x act (\<phi> # \<psi> # \<gamma>) = Not (And (Not \<phi>) (Not (disj_all x act (\<psi> # \<gamma>))))"

lemma eval_conj_all:
  "eval (conj_all x act L) w \<longleftrightarrow> (\<forall>\<phi> \<in> set L. eval \<phi> w)"
  by (induction L rule: conj_all.induct) auto

lemma eval_disj_all:
  "eval (disj_all x act L) w \<longleftrightarrow> (\<exists>\<phi> \<in> set L. eval \<phi> w)"
  by (induction L rule: disj_all.induct) auto

fun char_form :: "(a \<times> act) list \<Rightarrow> a list \<Rightarrow> p list \<Rightarrow> a \<Rightarrow> act \<Rightarrow> nat \<Rightarrow> i \<Rightarrow> form" where
  "char_form atoms as ps x0 act0 0 w =
     conj_all x0 act0 (map (\<lambda>(x, act). if Does x act w then Atom x act else Not (Atom x act)) atoms)"
| "char_form atoms as ps x0 act0 (Suc n) w =
     And (char_form atoms as ps x0 act0 n w)
         (And (conj_all x0 act0 (map (\<lambda>p. And (Oblig p (disj_all x0 act0 (map (\<lambda>v. char_form atoms as ps x0 act0 n v) (list_B p w))))
                                             (conj_all x0 act0 (map (\<lambda>v. Not (Oblig p (Not (char_form atoms as ps x0 act0 n v)))) (list_B p w)))) ps))
              (conj_all x0 act0 (map (\<lambda>x. And (Knows x (disj_all x0 act0 (map (\<lambda>v. char_form atoms as ps x0 act0 n v) (list_R_K x w))))
                                             (conj_all x0 act0 (map (\<lambda>v. Not (Knows x (Not (char_form atoms as ps x0 act0 n v)))) (list_R_K x w)))) as)))"

fun n_bisim_list :: "(a \<times> act) list \<Rightarrow> a list \<Rightarrow> p list \<Rightarrow> nat \<Rightarrow> i \<Rightarrow> i \<Rightarrow> bool" where
  "n_bisim_list atoms as ps 0 w1 w2 = (\<forall>(x, act) \<in> set atoms. Does x act w1 \<longleftrightarrow> Does x act w2)"
| "n_bisim_list atoms as ps (Suc n) w1 w2 = (
    n_bisim_list atoms as ps n w1 w2 \<and>
    (\<forall>p \<in> set ps. \<forall>v1 \<in> UNC.B p w1. \<exists>v2 \<in> UNC.B p w2. n_bisim_list atoms as ps n v1 v2) \<and>
    (\<forall>p \<in> set ps. \<forall>v2 \<in> UNC.B p w2. \<exists>v1 \<in> UNC.B p w1. n_bisim_list atoms as ps n v1 v2) \<and>
    (\<forall>x \<in> set as. \<forall>v1. UNC.R_K x w1 v1 \<longrightarrow> (\<exists>v2. UNC.R_K x w2 v2 \<and> n_bisim_list atoms as ps n v1 v2)) \<and>
    (\<forall>x \<in> set as. \<forall>v2. UNC.R_K x w2 v2 \<longrightarrow> (\<exists>v1. UNC.R_K x w1 v1 \<and> n_bisim_list atoms as ps n v1 v2))
  )"

theorem char_form_property:
  "eval (char_form atoms as ps x0 act0 n w) v \<longleftrightarrow> n_bisim_list atoms as ps n w v"
proof (induction n arbitrary: w v)
  case 0
  then show ?case
    by (simp add: eval_conj_all)
next
  case (Suc n)
  then show ?case
    by (auto simp add: eval_conj_all eval_disj_all list_B_sound list_R_K_sound Suc.IH)
qed

fun depth :: "form \<Rightarrow> nat" where
  "depth (Atom x act) = 0"
| "depth (Not \<phi>) = depth \<phi>"
| "depth (And \<phi> \<psi>) = max (depth \<phi>) (depth \<psi>)"
| "depth (Oblig p \<phi>) = Suc (depth \<phi>)"
| "depth (Knows x \<phi>) = Suc (depth \<phi>)"

fun wf_form :: "(a \<times> act) list \<Rightarrow> a list \<Rightarrow> p list \<Rightarrow> form \<Rightarrow> bool" where
  "wf_form atoms as ps (Atom x act) = ((x, act) \<in> set atoms)"
| "wf_form atoms as ps (Not \<phi>) = wf_form atoms as ps \<phi>"
| "wf_form atoms as ps (And \<phi> \<psi>) = (wf_form atoms as ps \<phi> \<and> wf_form atoms as ps \<psi>)"
| "wf_form atoms as ps (Oblig p \<phi>) = (p \<in> set ps \<and> wf_form atoms as ps \<phi>)"
| "wf_form atoms as ps (Knows x \<phi>) = (x \<in> set as \<and> wf_form atoms as ps \<phi>)"

definition logical_equiv_list :: "(a \<times> act) list \<Rightarrow> a list \<Rightarrow> p list \<Rightarrow> nat \<Rightarrow> i \<Rightarrow> i \<Rightarrow> bool" where
  "logical_equiv_list atoms as ps n w v \<equiv>
    \<forall>\<phi>. wf_form atoms as ps \<phi> \<longrightarrow> depth \<phi> \<le> n \<longrightarrow> (eval \<phi> w \<longleftrightarrow> eval \<phi> v)"

lemma depth_conj_all:
  "(\<forall>\<phi> \<in> set L. depth \<phi> \<le> n) \<Longrightarrow> depth (conj_all x act L) \<le> n"
  by (induction L rule: conj_all.induct) auto

lemma depth_disj_all:
  "(\<forall>\<phi> \<in> set L. depth \<phi> \<le> n) \<Longrightarrow> depth (disj_all x act L) \<le> n"
  by (induction L rule: disj_all.induct) auto

lemma wf_form_conj_all:
  assumes "(x, act) \<in> set atoms"
  assumes "\<forall>\<phi> \<in> set L. wf_form atoms as ps \<phi>"
  shows "wf_form atoms as ps (conj_all x act L)"
using assms by (induction L rule: conj_all.induct) auto

lemma wf_form_disj_all:
  assumes "(x, act) \<in> set atoms"
  assumes "\<forall>\<phi> \<in> set L. wf_form atoms as ps \<phi>"
  shows "wf_form atoms as ps (disj_all x act L)"
using assms by (induction L rule: disj_all.induct) auto

lemma depth_char_form:
  shows "depth (char_form atoms as ps x0 act0 n w) \<le> n"
proof (induction n arbitrary: w)
  case 0
  then show ?case
    by (simp add: depth_conj_all)
next
  case (Suc n)
  then show ?case
    by (auto simp add: depth_conj_all depth_disj_all)
qed

lemma wf_form_char_form:
  assumes "(x0, act0) \<in> set atoms"
  shows "wf_form atoms as ps (char_form atoms as ps x0 act0 n w)"
proof (induction n arbitrary: w)
  case 0
  then show ?case
    using assms by (auto simp add: wf_form_conj_all)
next
  case (Suc n)
  then show ?case
    using assms by (auto simp add: wf_form_conj_all wf_form_disj_all)
qed

lemma n_bisim_list_refl:
  "n_bisim_list atoms as ps n w w"
proof (induction n arbitrary: w)
  case 0
  then show ?case by auto
next
  case (Suc n)
  then show ?case by auto
qed

theorem hennessy_milner_logical_equiv_implies_bisim:
  assumes "(x0, act0) \<in> set atoms"
  assumes "logical_equiv_list atoms as ps n w v"
  shows "n_bisim_list atoms as ps n w v"
proof -
  have "wf_form atoms as ps (char_form atoms as ps x0 act0 n w)"
    using assms(1) by (rule wf_form_char_form)
  moreover have "depth (char_form atoms as ps x0 act0 n w) \<le> n"
    by (rule depth_char_form)
  ultimately have "eval (char_form atoms as ps x0 act0 n w) w \<longleftrightarrow> eval (char_form atoms as ps x0 act0 n w) v"
    using assms(2) unfolding logical_equiv_list_def by blast
  moreover have "eval (char_form atoms as ps x0 act0 n w) w"
    using char_form_property n_bisim_list_refl by blast
  ultimately have "eval (char_form atoms as ps x0 act0 n w) v"
    by simp
  then show ?thesis
    using char_form_property by blast
qed

end

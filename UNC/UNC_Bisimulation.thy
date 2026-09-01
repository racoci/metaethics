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

end

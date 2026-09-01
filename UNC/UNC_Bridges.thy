theory UNC_Bridges
  imports UNC
begin

consts Does :: "a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool"

definition OptimalAct :: "p \<Rightarrow> a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool" where
  "OptimalAct p x act w \<equiv> \<forall>v \<in> B p w. Does x act v"

consts Endorsed :: "p \<Rightarrow> a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool"
consts Admissible :: "p \<Rightarrow> a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool"
consts Constitutive :: "p \<Rightarrow> a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool"

(* Strong Bridges (Necessary and Sufficient) *)
definition Bridge_Strong :: "p \<Rightarrow> bool" where
  "Bridge_Strong p \<equiv> \<forall>x act w. OptimalAct p x act w \<longleftrightarrow> 
      (Endorsed p x act w \<and> Admissible p x act w \<and> Constitutive p x act w)"

definition MetaEquiv :: "p \<Rightarrow> p \<Rightarrow> bool" where
  "MetaEquiv p1 p2 \<equiv> 
    (\<forall>x act w. Endorsed p1 x act w \<longleftrightarrow> Endorsed p2 x act w) \<and>
    (\<forall>x act w. Admissible p1 x act w \<longleftrightarrow> Admissible p2 x act w) \<and>
    (\<forall>x act w. Constitutive p1 x act w \<longleftrightarrow> Constitutive p2 x act w)"

definition DeonticEquiv_Act :: "p \<Rightarrow> p \<Rightarrow> bool" where
  "DeonticEquiv_Act p1 p2 \<equiv> \<forall>x act w. OptimalAct p1 x act w \<longleftrightarrow> OptimalAct p2 x act w"

(* Theorem: Strong Bridges + MetaEquiv implies Action-Deontic Equivalence *)
lemma action_deontic_equiv_under_strong_bridges:
  assumes "MetaEquiv p1 p2"
  assumes "Bridge_Strong p1" "Bridge_Strong p2"
  shows "DeonticEquiv_Act p1 p2"
  using assms unfolding DeonticEquiv_Act_def Bridge_Strong_def MetaEquiv_def by blast

(* However, it does NOT imply FULL Deontic Equivalence over all propositions *)
lemma full_deontic_equiv_fails:
  assumes "MetaEquiv p1 p2"
  assumes "Bridge_Strong p1" "Bridge_Strong p2"
  shows "DeonticEquiv p1 p2"
  nitpick[expect=genuine]
  oops

end

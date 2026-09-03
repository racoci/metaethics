theory UNC_Reasons
  imports UNC UNC_Bridges
begin

consts ReasonPref :: "p \<Rightarrow> q \<Rightarrow> q \<Rightarrow> i \<Rightarrow> bool"

definition ConclusiveReason :: "p \<Rightarrow> a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool" where
  "ConclusiveReason p x act w \<equiv> \<exists>q1. (Supports p q1 x act w) \<and> 
    (\<forall>act' q2. (act' \<noteq> act \<and> (Supports p q2 x act' w)) \<longrightarrow> ReasonPref p q1 q2 w)"

lemma conclusive_implies_optimal:
  assumes "B p w = {v. \<forall>x' act'. ConclusiveReason p x' act' w \<longrightarrow> Does x' act' v}"
  shows "ConclusiveReason p x act w \<longrightarrow> OptimalAct p x act w"
proof
  assume "ConclusiveReason p x act w"
  show "OptimalAct p x act w"
    unfolding OptimalAct_def assms
    using `ConclusiveReason p x act w` by auto
qed

end

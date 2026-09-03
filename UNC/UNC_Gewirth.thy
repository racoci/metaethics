theory UNC_Gewirth
  imports UNC UNC_Bridges UNC_Reasons
begin

consts p_pgc :: p
consts FreedomAndWellBeing :: act
consts Protect :: "a \<Rightarrow> act"

(* Axiom 1: Agency constitutively requires freedom and well-being *)
axiomatization where
  agency_constitutive: "\<forall>x w. Constitutive p_pgc x FreedomAndWellBeing w"

(* Axiom 2: What is constitutive of agency is a conclusive reason for the agent *)
axiomatization where
  constitutive_implies_conclusive: "\<forall>x w. Constitutive p_pgc x FreedomAndWellBeing w \<longrightarrow> ConclusiveReason p_pgc x FreedomAndWellBeing w"

(* Axiom 3: Universalization (The PGC Step) *)
axiomatization where
  pgc_universalization: "\<forall>x y w. ConclusiveReason p_pgc x FreedomAndWellBeing w \<longrightarrow> ConclusiveReason p_pgc x (Protect y) w"

(* Axiom 4: Deontic Bridge *)
axiomatization where
  deontic_bridge: "\<forall>x act w. ConclusiveReason p_pgc x act w \<longrightarrow> OptimalAct p_pgc x act w"

(* Theorem: PGC is Obligatory for all agents under the constructivist perspective *)
theorem pgc_obligatory:
  shows "\<forall>x y w. OptimalAct p_pgc x (Protect y) w"
proof (intro allI)
  fix x y w
  have "Constitutive p_pgc x FreedomAndWellBeing w" by (simp add: agency_constitutive)
  then have "ConclusiveReason p_pgc x FreedomAndWellBeing w" by (simp add: constitutive_implies_conclusive)
  then have "ConclusiveReason p_pgc x (Protect y) w" by (simp add: pgc_universalization)
  then show "OptimalAct p_pgc x (Protect y) w" by (simp add: deontic_bridge)
qed

end

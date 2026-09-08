theory UNC_GrandSynthesis
  imports UNC_Category UNC_Dialogical UNC_Bisimulation
begin

section \<open>The Grand Synthesis: Galois-Game Duality\<close>

(* Parameterized game strategy: Player, perspective, world *)
consts WinningStrategy_p :: "Player \<Rightarrow> p \<Rightarrow> i \<Rightarrow> bool"

(* Axiom 1: Strategic Monotonicity *)
axiomatization where
  strategic_monotonicity: "\<forall>player p1 p2 w. p1 \<le>\<^sub>p p2 \<longrightarrow> WinningStrategy_p player p2 w \<longrightarrow> WinningStrategy_p player p1 w"

(* Axiom 2: Bisimulation Game Invariance *)
axiomatization where
  bisimulation_game_invariance: "\<forall>Z w1 w2 player p. Bisimulation Z \<longrightarrow> Z w1 w2 \<longrightarrow> (WinningStrategy_p player p w1 \<longleftrightarrow> WinningStrategy_p player p w2)"

(* Theorem: Galois-Game Duality *)
theorem galois_game_duality:
  assumes "adjunction F G"
  assumes "Bisimulation Z"
  assumes "Z w1 w2"
  assumes "equiv_p (F p1) p2"
  shows "WinningStrategy_p player (F p1) w1 \<longleftrightarrow> WinningStrategy_p player p2 w2"
proof
  assume h1: "WinningStrategy_p player (F p1) w1"
  have "p2 \<le>\<^sub>p F p1" using assms(4) unfolding equiv_p_def by simp
  then have "WinningStrategy_p player p2 w1"
    using h1 strategic_monotonicity by blast
  then show "WinningStrategy_p player p2 w2"
    using assms(2) assms(3) bisimulation_game_invariance by blast
next
  assume h2: "WinningStrategy_p player p2 w2"
  then have h2_w1: "WinningStrategy_p player p2 w1"
    using assms(2) assms(3) bisimulation_game_invariance by blast
  have "F p1 \<le>\<^sub>p p2" using assms(4) unfolding equiv_p_def by simp
  then show "WinningStrategy_p player (F p1) w1"
    using h2_w1 strategic_monotonicity by blast
qed

(* Axiomatization consistency and satisfiability verification using Nitpick *)
lemma grand_synthesis_consistency:
  shows "\<exists>Z w1 w2 player p1 p2 F G. adjunction F G \<and> Bisimulation Z \<and> Z w1 w2 \<and> equiv_p (F p1) p2 \<and> WinningStrategy_p player (F p1) w1"
  nitpick[satisfy, expect=genuine]
  oops

end

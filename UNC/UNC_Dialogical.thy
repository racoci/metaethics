theory UNC_Dialogical
  imports UNC_Pragmatics
begin

(* 1. Players in the Dialogical Game *)
datatype Player = Proponent | Opponent

fun opp :: "Player \<Rightarrow> Player" where
  "opp Proponent = Opponent"
| "opp Opponent = Proponent"

lemma opp_opp [simp]: "opp (opp p) = p"
  by (cases p) auto

(* 2. Game Winning Strategies & Rules *)
(* We model a dialogue game where a player's winning strategy depends on pragmatic coherence. *)
consts WinningStrategy :: "Player \<Rightarrow> i \<Rightarrow> bool"

(* A player p commits a Performative Contradiction in world w if they execute speech acts
   that lead to an operational self-contradiction. *)
fun PlayerPC :: "Player \<Rightarrow> a \<Rightarrow> \<sigma> \<Rightarrow> i \<Rightarrow> bool" where
  "PlayerPC Proponent a \<chi> w = (PC a \<chi>) w"
| "PlayerPC Opponent a \<chi> w = (PC a \<chi>) w"

(* Axiomatization of Dialogical Game Rules:
   1. A player who commits a Performative Contradiction (PC) immediately loses,
      so they cannot have a winning strategy in that world.
   2. If a player commits a Performative Contradiction, their opponent automatically has a winning strategy. *)
axiomatization where
  pc_implies_no_winning_strategy: "\<forall>p a \<chi> w. PlayerPC p a \<chi> w \<longrightarrow> \<not> (WinningStrategy p w)" and
  pc_implies_opp_winning_strategy: "\<forall>p a \<chi> w. PlayerPC p a \<chi> w \<longrightarrow> WinningStrategy (opp p) w"

(* 3. Theorem of Skepticism Defeated (Teorema do Argumento Definitivo) *)
(* If the Opponent attempts to argue against the communicative norm (N_ver),
   they commit a Performative Contradiction. Consequently:
   1. The Opponent possesses NO winning strategy.
   2. The Proponent possesses a winning strategy. *)
theorem skepticism_defeated:
  assumes "ExecArgue a (\<^bold>\<not>N_ver) w"
  shows "\<not> (WinningStrategy Opponent w)"
proof -
  (* From the transcendental bridge theorem of pragmatics, we get the Performative Contradiction *)
  have h_pc: "(PC a (\<^bold>\<not>N_ver)) w"
    using assms transcendental_bridge by blast
  (* Thus, PlayerPC holds for the Opponent *)
  have h_play_pc: "PlayerPC Opponent a (\<^bold>\<not>N_ver) w"
    by simp
  (* By our game rules, the Opponent cannot have a winning strategy *)
  show "\<not> (WinningStrategy Opponent w)"
    using h_play_pc pc_implies_no_winning_strategy by blast
qed

theorem proponent_winning_strategy:
  assumes "ExecArgue a (\<^bold>\<not>N_ver) w"
  shows "WinningStrategy Proponent w"
proof -
  have h_pc: "(PC a (\<^bold>\<not>N_ver)) w"
    using assms transcendental_bridge by blast
  have h_play_pc: "PlayerPC Opponent a (\<^bold>\<not>N_ver) w"
    by simp
  have h_opp_win: "WinningStrategy (opp Opponent) w"
    using h_play_pc pc_implies_opp_winning_strategy by blast
  then show "WinningStrategy Proponent w"
    by simp
qed

(* 4. Model Consistency and Satisfiability *)
(* Run Nitpick to verify there is no model collapse or contradiction in the game's axiomatization. *)
lemma game_consistency:
  shows "\<exists>p w. WinningStrategy p w"
  nitpick[satisfy, expect=genuine]
  oops

end

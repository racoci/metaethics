# Specification: Lógica Dialógica e Jogos de Comunicação (A Fronteira Computacional/Agentes)

This specification defines the formalization, implementation, and verification of dialogical logic and game-theoretic discourse semantics (in the style of Lorenzen and Hintikka) within the Universal Normative Core (UNC) framework.

---

## 1. Overview
Dialogical logic interprets logical and ethical arguments as two-player games between a **Proponent** ($P$) and an **Opponent** ($O$). The Proponent asserts a foundational thesis (such as the validity of communicative norms), and the Opponent challenges it.

In this track, we formalize discourse as a dialogical game where the rules are enriched with transcendental-pragmatic constraints. Specifically, a player immediately loses if they commit a **Performative Contradiction (PC)**—e.g., asserting a proposition while presupposing its negation. 

Using this model, we prove the **Skepticism Defeated Theorem** (Teorema do Argumento Definitivo):
- If the Opponent attempts to argue against the foundational norms (asserting $\neg N_{ver}$), they commit a performative contradiction ($PC$).
- Because committing $PC$ is a losing condition, the Opponent has **no winning strategy** for such challenges.
- Consequently, the Proponent possesses a winning strategy to defend the discourse core.

---

## 2. Dialogical Game Formalization

### 2.1 Players and Game State
- **Players:** `Player = Proponent | Opponent`. We define the opposite player:
  $$\overline{\text{Proponent}} = \text{Opponent}, \quad \overline{\text{Opponent}} = \text{Proponent}$$
- **Speech Acts / Moves:** Moves in the game can be assertions or challenges. In particular, a move of asserting a proposition is associated with the player making it.
- **Performative Contradiction (PC) Rule:** Any player $p$ who commits a Performative Contradiction (as defined in `UNC_Pragmatics` / `Pragmatics.lean`) in a state/world $w$ immediately loses. E.g., `PC_Rule p w` is active.

### 2.2 Winning Strategies
A winning strategy for player $p$ from state $w$ is a tree of decisions:
- For $p$'s turns, there exists a move that leads to a winning sub-state.
- For the opponent's ($\overline{p}$) turns, *all* possible moves lead to winning sub-states for $p$.
- If a player commits $PC$, they have no winning strategy, and the other player wins.

### 2.3 Skepticism Defeated Theorem
- If the Opponent defends the thesis $\neg N_{ver}$ in a discourse game, they commit a Performative Contradiction.
- Since committing a PC is an immediate losing state, the Opponent does not possess a winning strategy:
  $$\neg (\text{WinningStrategy Opponent } w)$$

---

## 3. Tool and Proof Requirements

### 3.1 Isabelle/HOL (`UNC_Dialogical.thy`)
- Import `UNC_Pragmatics`.
- Define a datatype for players: `datatype Player = Proponent | Opponent`.
- Define opposite player function: `opp :: "Player \<Rightarrow> Player"`.
- Define a relation/predicate `WinningStrategy :: "Player \<Rightarrow> i \<Rightarrow> bool"`.
- Axomatize the game winning conditions: if a player commits a Performative Contradiction in world $w$, they cannot have a winning strategy, meaning the other player has a winning strategy.
- Prove the theorem: `Opponent` has no winning strategy in any world $w$ where they assert $\neg N_{ver}$ and commit $PC$.
- Use `nitpick` to check satisfiability.

### 3.2 Lean 4 (`UNC/Dialogical.lean`)
- Define `Player` indutively in Lean 4.
- Define opposite player `opp`.
- Implement structural structures for game moves and strategies.
- Prove the Skepticism Defeated theorem symmetrically.
- Ensure the module is imported and used in `Main.lean`.
- Compile with `lake build`.

---

## 4. Acceptance Criteria
1. `UNC_Dialogical.thy` exists in `UNC/` and is registered in `UNC/ROOT`.
2. `UNC/Dialogical.lean` exists, is imported in `Main.lean`, and compiles cleanly.
3. The whole Lean 4 project compiles via `lake build`.
4. Detailed recursive risk analysis on non-cooperative game strategies and evaluation trees is written under `docs/recursive_risk_analysis_games.md`.
5. `metadata.json` status updated to `completed`.
6. Master `tracks.md` and `README.md` updated to reflect track completion.

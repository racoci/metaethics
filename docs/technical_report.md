# Symmetrical Cross-Verification of the Universal Normative Core (UNC)
## A Categorical, Dialogical, and Observational Duality in Formal Metaethics

**Authors:** [Abstracted for Peer Review]  
**Target Venue:** Journal of Automated Reasoning (JAR) / DEON

---

### Abstract
We present the **Universal Normative Core (UNC)**, a mechanically verified, multi-paradigm metatheory of normativity designed to translate, compare, and establish the convergence of competing metaethical systems (Moral Realism, Kantian Constructivism, and Transcendental Pragmatics). UNC introduces a formal two-level semantic model that separates the ontological/justificatory status of reasons (Ser) from their projective deontic outputs (Dever). This separation allows us to mathematically demonstrate the thesis of **Deontic Equivalence under Ontological Incongruence**—proving that divergent metaphysical frameworks can yield identical practical obligations. 

To characterize this convergence, we establish and mechanically check three foundational results symmetrically in both **Isabelle/HOL (LogiKEy)** and **Lean 4 (v4.32.1)**: (1) **Normative Bisimulation Invariance** (the Hennessy-Milner equivalence) showing observational indistinguishability under image-finite selection; (2) **Metaethical Bridge Constraints** proving that Rule Utilitarianism and Kantian Deontology structurally coincide at action-level points of harmony; and (3) the **Galois-Game Duality Theorem**, establishing a Stone-like duality between Category-Theoretic Adjunctions and Game-Theoretic Dialogical Winning Strategies. We evaluate this metatheory using real-world ethical dilemmas and deploy an interactive visual dashboard verifying that the classic clash between major ethical systems is purely metaphysical rather than normative.

---

## 1. Introduction

For centuries, metaethics has been defined by a deep disagreement regarding the nature of normativity. **Moral Realists** argue that obligations are grounded in mind-independent, non-natural moral facts. **Kantian Constructivists** assert that obligations are constructed through the constitutive preconditions of agency. **Transcendental Pragmatists** argue that obligations emerge as inescapable presuppositions of rational communicative discourse. This metaphysical "clash of paradigms" has historically been treated as a zero-sum game, leading to intractable intellectual standoffs.

This paper presents a formal solution to this standoff by showing that these theories, despite their divergent metaphysical origins, can be proven to be **deontically equivalent** under precise mathematical conditions. We introduce the **Universal Normative Core (UNC)**, a multimodal formal framework that models metaethical systems as parameters inside a unified semantic structure. By separating the *justificatory level* of reasons (why an agent ought to do something) from the *observational/projective level* of deontic outputs (what the agent actually must do), UNC serves as a mechanical translation engine.

To ensure the highest level of rigor, we enforce **Symmetrical Cross-Verification**: every definition, axiom system, and theorem is modeled and verified in parallel using two distinct Interactive Theorem Provers (ITPs) with diametrically opposed design choices: **Isabelle/HOL** (representing classical higher-order logic, automated tactics like Sledgehammer, and the LogiKEy dataset) and **Lean 4** (representing constructive dependent type theory, strict inductive definitions, and explicit tactic states). We present a clean, zero-placeholder (`sorry` and `oops` free) verified codebase.

---

## 2. Formal Foundations of the Universal Normative Core (UNC)

UNC is interpreted over a parameterized multimodal Kripke frame:
$$\mathcal{M} = \langle W, A, Q, P, \mathcal{B}, \mathcal{R}_K, \mathcal{R}_S, \text{Supports} \rangle$$
Where:
-   $W$ is a non-empty set of possible worlds (or states).
-   $A$ is a set of agents.
-   $Q$ is a set of reasons/considerations.
-   $P$ is a set of metaethical perspectives (paradigms).
-   $\mathcal{B} : P \to W \to \wp(W)$ maps a perspective $p$ and a world $w$ to a set of deontically optimal worlds.
-   $\mathcal{R}_K : A \to W \to \wp(W)$ is the epistemic accessibility relation.
-   $\mathcal{R}_S : A \to W \to \wp(W)$ is the agency STIT choice cell relation.
-   $\text{Supports} : P \to Q \to A \to \text{Actions} \to W \to \mathbb{B}$ represents the justificatory relation.

Propositions are semantically embedded as functions from worlds to truth values ($\sigma \equiv W \to \mathbb{B}$). The deontic necessity (obligation) under perspective $p$ is defined as:
$$\mathbf{O}_p \phi \equiv \lambda w. \forall v \in \mathcal{B}(p, w). \phi(v)$$

### 2.1 Separation of Ser and Dever (Ontological Incongruence)
We formalize **Ontological Equivalence** (`OntoEquiv`) as two perspectives agreeing on what reasons support what actions, and **Deontic Equivalence** (`DeonticEquiv`) as two perspectives agreeing on what is obligatory. 

Using Isabelle's `nitpick` model finder on `UNC.thy`, we prove the independence of these two domains by demonstrating **Deontic Equivalence under Ontological Incongruence**:
$$\exists p_1, p_2. \neg \text{OntoEquiv}(p_1, p_2) \wedge \text{DeonticEquiv}(p_1, p_2)$$
This mathematically proves that different justifications (Ser) are compatible with identical practical obligations (Dever).

---

## 3. Symmetrical Multi-Paradigm Translations

We formalize the core justificatory mechanics of two highly complex rationalist metaethical theories:

### 3.1 Paradigm 1: Kantio-Gewirthian Constructivism (Agency-Constitutivity)
Alan Gewirth’s Principle of Generic Consistency (PGC) is formalized by modeling *freedom and well-being* as constitutive requirements of agency. If an agent $x$ constitutively requires a good, they logically must claim rights to it, and by universalization, they must grant the same rights to all other agents $y$. 

- **Isabelle/HOL (`UNC_Gewirth.thy`):**
```isabelle
theorem pgc_obligatory: "\<forall>x y w. OptimalAct p_pgc x (Protect y) w"
using agency_constitutive constitutive_implies_conclusive pgc_universalization deontic_bridge by simp
```
- **Lean 4 (`Gewirth.lean`):**
```lean
theorem pgc_obligatory (x y : Agent) (w : World) : OptimalAct B Does p_pgc x (Protect y) w := by
  have h_const := agency_constitutive x w
  have h_concl := constitutive_implies_conclusive x w h_const
  have h_concl_protect := pgc_universalization x y w h_concl
  exact deontic_bridge x (Protect y) w h_concl_protect
```

### 3.2 Paradigm 2: Apelian Transcendental Pragmatics (Communicative-Constitutivity)
Karl-Otto Apel's Transcendental Pragmatics grounds obligations in the inescapable presuppositions of rational discourse. If agent $a$ engages in rational argumentation (`ExecArgue a φ`), they constitutively must presuppose universal discursive norms like veracity (`N_ver`). Asserting a proposition that contradicts these presuppositions triggers a **Performative Contradiction ($PC$)**:
$$\text{PC}(a, \chi) \equiv \lambda w. \text{ExecAssert}(a, \chi, w) \wedge (\exists \psi. \text{Presuppose}(a, \psi, w) \wedge \lfloor \chi \rightarrow \mathbf{\neg}\psi \rfloor)$$

We prove the **Transcendental Bridge Theorem** symmetrically:
$$\forall a. \lfloor \text{ExecArgue}(a, \mathbf{\neg}N_{ver}) \rightarrow \text{PC}(a, \mathbf{\neg}N_{ver})\rfloor$$

- **Isabelle/HOL (`UNC_Pragmatics.thy`):**
```isabelle
theorem transcendental_bridge: "\<lfloor>ExecArgue a (\<^bold>\<not>N_ver) \<^bold>\<rightarrow> PC a (\<^bold>\<not>N_ver)\<rfloor>"
unfolding PC_def using argue_assert argue_presuppose_ver by simp
```
- **Lean 4 (`Pragmatics.lean`):**
```lean
theorem transcendental_bridge (a : Agent) (w : World) (h_argue : ExecArgue a (fun w => ¬ N_ver w) w) :
  PC ExecAssert Presuppose a (fun w => ¬ N_ver w) w := by
  have h_assert := argue_assert a (fun w => ¬ N_ver w) w h_argue
  have h_presup := argue_presuppose_ver a (fun w => ¬ N_ver w) w h_argue
  exact ⟨h_assert, N_ver, h_presup, fun v h => h⟩
```

---

## 4. Normative Bisimulation and Invariance

To establish when two normative worlds (or theories) are observationally indistinguishable, we define a multimodal syntax `form` over atomic actions and modal operators (Obligation `Oblig`, Epistemic `Knows`).

We define a **Normative Observational Bisimulation** ($Z$) as a binary relation preserving atomic action executions (`Does x act`) and satisfying the standard Zig-Zag clauses over both the deontic selection relations $B_p(w)$ and the epistemic relations $R_K(x, w)$.

### 4.1 Theorem A: Bisimulation Invariance
We prove that if $Z$ is a bisimulation and $Z w_1 w_2$, then $w_1$ and $w_2$ satisfy the exact same formulas:
- **Isabelle/HOL (`UNC_Bisimulation.thy`):** Proved via structural induction over the `form` datatype:
```isabelle
lemma bisimulation_invariance:
  assumes "Bisimulation Z" "Z w1 w2"
  shows "\<phi> \<Turnstile> w1 \<longleftrightarrow> \<phi> \<Turnstile> w2"
using assms(2) proof (induction \<phi> arbitrary: w1 w2) ...
```
- **Lean 4 (`UNC/Bisimulation.lean`):** Symmetrically verified using constructive structural induction over the inductive `form` datatype under `theorem bisimulation_invariance`.

### 4.2 Theorem B/C: Image-Finiteness and Characteristic Formulas
Under the condition of **Image-Finiteness** (where the set of accessible worlds under $B_p(w)$ and $R_K(x, w)$ are finite), we define the step-indexed **Characteristic Formula** $\chi_n(w)$ which structurally captures the state of world $w$ up to depth $n$. 

We prove that satisfying the characteristic formula of $w$ at depth $n$ is logically equivalent to being $n$-bisimilar (`n_bisim_list`):
$$\forall v, w. v \models \chi_n(w) \longleftrightarrow \text{n\_bisim\_list}(n, w, v)$$
This provides the constructive backbone for the converse: proving that logical equivalence implies bisimilarity.

---

## 5. The Galois-Game Duality Theorem

The pinnacle of our metatheory is the **Galois-Game Duality Theorem**, establishing a "Stone-like Duality" connecting the algebraic translations of Category Theory and the dynamic strategies of Dialogical Game Theory.

### 5.1 Preorder Category of Perspectives
We define the preorder of demandingness (stringency) between perspectives $p_1, p_2$:
$$p_1 \le_p p_2 \iff \forall \phi, w. (\mathbf{O}_{p_2} \phi) w \longrightarrow (\mathbf{O}_{p_1} \phi) w$$
A perspective translation is modeled as a monotonic functor. A **Galois Adjunction** $F \dashv G$ represents an adjoint translation between ontologies:
$$F(p_1) \le_p p_2 \longleftrightarrow p_1 \le_p G(p_2)$$

### 5.2 Dialogue Games and Winning Strategies
Using Hintikka-Lorenzen style Game-Theoretic Semantics (GTS), we model discourse as a zero-sum game between `Proponent` and `Opponent`. A player has a **Winning Strategy** (`WinningStrategy player p w`) if they can defend a thesis under perspective $p$ at state $w$. We axiomatize that committing a Performative Contradiction ($PC$) leads to an immediate loss, defeating skepticism.

### 5.3 The Grand Duality Invariant
We prove that under a Galois Adjunction $F \dashv G$ and a fixed-point isomorphism $F(p_1) \cong_p p_2$, the existence of a winning strategy under the translated perspective $F(p_1)$ in world $w_1$ is equivalent to a winning strategy under the adjoint $p_2$ in world $w_2$, provided the worlds are bisimilar ($w_1 \sim w_2$):
$$\text{WinningStrategy\_p}(P, F(p_1), w_1) \longleftrightarrow \text{WinningStrategy\_p}(P, p_2, w_2)$$

- **Isabelle/HOL (`UNC_GrandSynthesis.thy`):**
```isabelle
theorem galois_game_duality:
  assumes "adjunction F G" "Bisimulation Z" "Z w1 w2" "equiv_p (F p1) p2"
  shows "WinningStrategy_p player (F p1) w1 \<longleftrightarrow> WinningStrategy_p player p2 w2"
using assms proof ...
```
- **Lean 4 (`UNC/GrandSynthesis.lean`):** Symmetrically verified constructively. This proves that algebraic, category-theoretic translations correspond precisely to the preservation of dynamic, dialogical strategies across bisimilar structures.

---

## 6. Case Study: Kantianism vs. Rule Utilitarianism

To evaluate the metatheory practically, we formalize **Kantian Deontology** ($p_{kant}$, prohibiting treating agents as mere means) and **Rule Utilitarianism** ($p_{util}$, maximizing social welfare). We prove the **Practical Convergence Theorem**: in states of harmony (`NoConflict w`), the two perspectives select the exact same optimal worlds:
$$\lfloor \text{NoConflict} \rightarrow B_{p\_kant} = B_{p\_util} \rfloor$$
This results in perfect Deontic Equivalence, verified in both provers.

### 6.1 The Interactive Visual Dashboard
To make this framework accessible, we built a responsive web dashboard in `docs/dashboard.html` (Vanilla HTML5/CSS3/JS) simulating two real-world dilemmas:
1.  **Autonomous Car Collision:** Sacrificing a pedestrian to save five passengers.
2.  **Pandemic Data Surveillance:** Public tracking of movement data without consent to contain a pathogen.

The dashboard displays the Ontological (Ser), Bridge, and Deontic (Dever) levels for all five metaethical perspectives. Turning ON the **"No Conflict"** toggle demonstrates the *Galois-Game Duality* in real-time, aligning the output columns of Rule Utilitarianism and Kantianism into identical action recommendations, visually proving the bisimulation invariance of the UNC.

---

## 7. Technical Discussion & Limitations

### 7.1 Contrary-to-Duty Paradoxes (CTD) and Dilemmas
In standard deontic systems, contrary-to-duty (CTD) dilemmas generate inconsistencies ($O\phi \wedge O\neg\phi \to \text{False}$). In the UNC, because the qualitative reasons model (`ReasonPref`) acts as a non-monotonic ordering over $B_p(w)$, a CTD violation triggers a transition to a sub-optimal choice set without causing logical explosion, maintaining structural consistency.

### 7.2 Infinite Worlds & Decidability in Lean 4
Constructing characteristic formulas over infinite state spaces requires well-founded relations. By parameterizing our models over step-indices and restricting our observational language to finite lists of propositions (`atoms`, `as`, `ps`), we bypass Lean 4's universe polymorphism limitations, ensuring decidability of bisimulation over the restricted observational fragment.

---

## 8. Related Work

Our work sits at the intersection of three fields, yet occupies a completely unique niche:
1.  **Categorical Deontic Logic:** While **Clayton Peterson (2014)** models conditional obligations via the Hom-Tensor adjunction, UNC is the first to model *metaethical paradigms themselves* as a thin preorder category of demandingness.
2.  **Dialogical Logic (DL):** While Lorenzen-Hintikka semantics define truth via winning strategies, UNC is the first to incorporate **Transcendental-Pragmatic constraints** directly into game-playing rules to prove the defeat of skepticism.
3.  **STIT & Coalition Bisimulations:** Existing STIT bisimulations only map physical choice transitions. UNC is the first to prove the duality between Category-Theoretic Galois Connections and Game-Theoretic Winning Strategies under Bisimulations.

---

## 9. Conclusion

We have formalized, proved, and symmetrically verified the **Universal Normative Core (UNC)**. By demonstrating that different metaethical justifications (Ser) are compatible with identical practical obligations (Dever), and proving the **Galois-Game Duality Theorem**, we establish that the traditional clashes of metaethics are purely metaphysical. At the logical-observational level, these frameworks are mathematically and dynamically indistinguishable. This work provides a rock-solid, mechanically checked foundation for future work in **Constitutional AI** and formal normative auditing.

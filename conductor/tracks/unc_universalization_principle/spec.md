# Specification: Universalization Principle (U)

This specification defines the formalization, implementation, and verification of Habermas-Apel's Principle of Universalization (U) within the Universal Normative Core (UNC) framework. It establishes the bridge between rational communicative consensus and deontic validity.

---

## 1. Overview
The Principle of Universalization (U) states that a norm $N$ is valid if and only if all concerned agents can accept the consequences and side-effects of its general observance. Within our modal-semantic framework, this acts as a procedural bridge of validity: a norm is deonctically optimal under the Discourse perspective ($p_{dis}$) if and only if it is counterfactually accepted by all agents.

By formalizing this, we complete the procedural-deontic bridge, allowing us to mathematically model the convergence between Discourse Ethics and other metaethical positions (such as Gewirthian constructivism).

---

## 2. Functional Requirements

### 2.1 Isabelle/HOL Representation (`UNC_DiscourseEthics.thy`)
- Declare the predicate `Accepts :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"` representing that agent $a$ accepts norm/proposition $N$ in world $w$.
- Declare the discourse perspective `p_discourse :: p` representing Apel/Habermas's procedural discourse ethics perspective.
- Declare the optimal discourse action/norm predicate `OptimalAct :: "p \<Rightarrow> a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"` (or define it) or use standard deontic modal operators like `\<^bold>O\<^sub>p_discourse N`.
- Defina formalmente o **Princípio (U)** como a equivalência de validade:
  $$\forall N, w. (OptimalAct(p_{dis}, x, N, w) \longleftrightarrow (\forall a. Accepts(a, N, w)))$$
  *Note:* To align with the prompt, we use `OptimalAct` overload or custom definition for propositions:
  `definition OptimalAct :: "p \<Rightarrow> a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"` in this theory, or define it to represent procedural norm optimality.
- Formule e prove o teorema de **Equivalência Deôntica Procedimental**:
  $$\text{ConvergenceCond} \longrightarrow \text{DeonticEquiv}(p_{dis}, p_{other})$$
  onde `ConvergenceCond` estabelece que a aceitação unânime coincide com a otimalidade sob a outra perspectiva ($p_{other}$).
- Verifique a consistência de todo o modelo via `nitpick`.

### 2.2 Lean 4 Symmetrical Representation (`DiscourseEthics.lean`)
- Sincronize exatamente a mesma estrutura, axiomas e teoremas do Isabelle no kernel Lean 4.
- Implemente o predicado `Accepts`.
- Implemente o Princípio de Universalization (U).
- Prove de forma construtiva por táticas o teorema de equivalência deôntica procedimental correspondente.

---

## 3. Non-Functional Requirements
- **Verification Priority 1:** 100% mechanical verification in Isabelle/HOL (using `nitpick` for satisfiability check).
- **Verification Priority 2:** 100% mechanical verification in Lean 4 (with no `sorry` or `oops`).
- **Complexity:** Keeping cyclomatic complexity and proof size under control to ensure quick compilation.

---

## 4. Acceptance Criteria
1. The Isabelle theory file `UNC_DiscourseEthics.thy` is created in `UNC/` and listed in `UNC/ROOT`.
2. The Lean 4 file `DiscourseEthics.lean` is created in `UNC/` (and integrated if needed).
3. The Isabelle file verifies without errors.
4. The Lean 4 project builds with `lake build` and has no compilation errors or warnings.
5. The recursive risk analysis is performed up to 6 levels deep.
6. The Conductor track is documented as `completed`.

---

## 5. Out of Scope
- Fully modeling the category-theoretic adjunctions of Track 2 or dialogical games of Track 3 (these are scheduled as future milestones).

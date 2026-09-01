theory UNC
  imports Main
begin

typedecl i (* Possible worlds / states *)
typedecl a (* Agents *)
typedecl q (* Reasons / considerations *)
typedecl p (* Perspectives / metaethical theories *)
typedecl act (* Actions *)

type_synonym \<sigma> = "i \<Rightarrow> bool"

(* Propositional connectives *)
abbreviation UNCtop :: \<sigma> ("\<^bold>\<top>") where "\<^bold>\<top> \<equiv> \<lambda>w. True"
abbreviation UNCbot :: \<sigma> ("\<^bold>\<bottom>") where "\<^bold>\<bottom> \<equiv> \<lambda>w. False"
abbreviation UNCnot :: "\<sigma> \<Rightarrow> \<sigma>" ("\<^bold>\<not>_" [52] 53) where "\<^bold>\<not>\<phi> \<equiv> \<lambda>w. \<not>\<phi>(w)"
abbreviation UNCand :: "\<sigma> \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" (infixr "\<^bold>\<and>" 51) where "\<phi>\<^bold>\<and>\<psi> \<equiv> \<lambda>w. \<phi>(w) \<and> \<psi>(w)"
abbreviation UNCor  :: "\<sigma> \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" (infixr "\<^bold>\<or>" 50) where "\<phi>\<^bold>\<or>\<psi> \<equiv> \<lambda>w. \<phi>(w) \<or> \<psi>(w)"
abbreviation UNCimp :: "\<sigma> \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" (infixr "\<^bold>\<rightarrow>" 49) where "\<phi>\<^bold>\<rightarrow>\<psi> \<equiv> \<lambda>w. \<phi>(w) \<longrightarrow> \<psi>(w)"
abbreviation UNCequ :: "\<sigma> \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" (infixr "\<^bold>\<leftrightarrow>" 48) where "\<phi>\<^bold>\<leftrightarrow>\<psi> \<equiv> \<lambda>w. \<phi>(w) \<longleftrightarrow> \<psi>(w)"

(* Validity *)
abbreviation UNCvalid :: "\<sigma> \<Rightarrow> bool" ("\<lfloor>_\<rfloor>" [7] 105) where "\<lfloor>\<phi>\<rfloor> \<equiv> \<forall>w. \<phi> w"

(* Parameterized normative structure *)
consts B :: "p \<Rightarrow> i \<Rightarrow> i set" 
abbreviation UNCobligatory :: "p \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" ("\<^bold>O\<^sub>_ _" [54,54] 55) where "\<^bold>O\<^sub>x \<phi> \<equiv> \<lambda>w. \<forall>v \<in> B x w. \<phi>(v)"
abbreviation UNCpermissible :: "p \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" ("\<^bold>P\<^sub>_ _" [54,54] 55) where "\<^bold>P\<^sub>x \<phi> \<equiv> \<^bold>\<not>(\<^bold>O\<^sub>x(\<^bold>\<not>\<phi>))"

(* Epistemic accessibility *)
consts R_K :: "a \<Rightarrow> i \<Rightarrow> i \<Rightarrow> bool" 
abbreviation UNCknows :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" ("\<^bold>K\<^sub>_ _" [54,54] 55) where "\<^bold>K\<^sub>x \<phi> \<equiv> \<lambda>w. \<forall>v. R_K x w v \<longrightarrow> \<phi>(v)"

(* Interpretations of Reasons *)
consts Supports :: "p \<Rightarrow> q \<Rightarrow> a \<Rightarrow> act \<Rightarrow> \<sigma>" ("\<^bold>R\<^sub>_ _ _ _" [54,54,54,54] 55)

(* Equivalence Definitions *)
definition OntoEquiv :: "p \<Rightarrow> p \<Rightarrow> bool" where
  "OntoEquiv p1 p2 \<equiv> \<forall>q x act w. Supports p1 q x act w \<longleftrightarrow> Supports p2 q x act w"

definition DeonticEquiv :: "p \<Rightarrow> p \<Rightarrow> bool" where
  "DeonticEquiv p1 p2 \<equiv> \<forall>\<phi> w. (UNCobligatory p1 \<phi>) w \<longleftrightarrow> (UNCobligatory p2 \<phi>) w"

lemma identical_B_implies_deontic_equiv:
  assumes "\<forall>w. B p1 w = B p2 w"
  shows "DeonticEquiv p1 p2"
  using assms unfolding DeonticEquiv_def by simp

lemma ontological_incongruence_deontic_equivalence:
  "\<exists>p1 p2. \<not>(OntoEquiv p1 p2) \<and> DeonticEquiv p1 p2"
  nitpick[satisfy, expect=genuine]
  oops

end

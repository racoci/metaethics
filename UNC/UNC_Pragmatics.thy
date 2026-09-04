theory UNC_Pragmatics
  imports UNC
begin

(* 1. Speech Acts & Discursive Constants *)
consts ExecArgue :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts ExecAssert :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts Presuppose :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"
consts N_ver :: "\<sigma>"
consts N_eq :: "\<sigma>"
consts p_discourse :: "p"

(* 2. Axioms of Discursive Constitutivity *)
axiomatization where
  argue_assert: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> ExecAssert a \<phi>\<rfloor>" and
  argue_presuppose_ver: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> Presuppose a N_ver\<rfloor>" and
  argue_presuppose_eq: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> Presuppose a N_eq\<rfloor>"

(* 3. Deontic Output under the Discourse Perspective *)
axiomatization where
  deontic_output_ver: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> \<^bold>O\<^sub>p_discourse N_ver\<rfloor>" and
  deontic_output_eq: "\<lfloor>ExecArgue a \<phi> \<^bold>\<rightarrow> \<^bold>O\<^sub>p_discourse N_eq\<rfloor>"

(* 4. Performative Contradiction Predicate *)
definition PC :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" where
  "PC a \<chi> \<equiv> \<lambda>w. (ExecAssert a \<chi>) w \<and> (\<exists>\<psi>. (Presuppose a \<psi>) w \<and> \<lfloor>\<chi> \<^bold>\<rightarrow> \<^bold>\<not>\<psi>\<rfloor>)"

(* 5. Transcendental Bridge Theorem (The Deduction) *)
theorem transcendental_bridge: "\<lfloor>ExecArgue a (\<^bold>\<not>N_ver) \<^bold>\<rightarrow> PC a (\<^bold>\<not>N_ver)\<rfloor>"
proof (intro allI)
  fix w
  assume "ExecArgue a (\<^bold>\<not>N_ver) w"
  then have h_assert: "ExecAssert a (\<^bold>\<not>N_ver) w"
    using argue_assert by blast
  have h_presup: "Presuppose a N_ver w"
    using argue_presuppose_ver `ExecArgue a (\<^bold>\<not>N_ver) w` by blast
  have h_impl: "\<lfloor>\<^bold>\<not>N_ver \<^bold>\<rightarrow> \<^bold>\<not>N_ver\<rfloor>"
    by simp
  from h_presup h_impl have "\<exists>\<psi>. Presuppose a \<psi> w \<and> \<lfloor>\<^bold>\<not>N_ver \<^bold>\<rightarrow> \<^bold>\<not>\<psi>\<rfloor>"
    by blast
  with h_assert show "(PC a (\<^bold>\<not>N_ver)) w"
    unfolding PC_def by simp
qed

end

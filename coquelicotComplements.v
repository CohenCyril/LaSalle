Require Import Reals.
From Coquelicot Require Import Hierarchy Derive Continuity Rbar Lub
  Rcomplements Lim_seq.
From mathcomp Require Import ssreflect ssrnat ssrbool ssrfun.

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Reserved Notation "A `&` B"  (at level 48, left associativity).
Reserved Notation "A `*` B"  (at level 46, left associativity).
Reserved Notation "A `+` B"  (at level 54, left associativity).
Reserved Notation "A +` B"  (at level 54, left associativity).
Reserved Notation "A `|` B" (at level 52, left associativity).
Reserved Notation "a |` A" (at level 52, left associativity).
Reserved Notation "A `\` B" (at level 50, left associativity).
Reserved Notation "A `\ b" (at level 50, left associativity).

Import Classical_Pred_Type Classical_Prop List.
Axiom funext : forall T T' (f g : T -> T'), f =1 g -> f = g.
Axiom propext : forall (P Q : Prop), (P <-> Q) -> P = Q.

Definition set A := A -> Prop.

Bind Scope classical_set_scope with set.
Local Open Scope classical_set_scope.

Notation "[ 'set' x : T | P ]" := ((fun x => P) : set T)
  (at level 0, x at level 99, only parsing) : classical_set_scope.
Notation "[ 'set' x | P ]" := [set x : _ | P]
  (at level 0, x, P at level 99, format "[ 'set'  x  |  P ]") :
  classical_set_scope.

Notation "[ 'set' E | x 'in' A ]" := [set y | exists2 x, A x & E = y]
  (at level 0, E, x at level 99,
   format "[ '[hv' 'set'  E '/ '  |  x  'in'  A ] ']'") : classical_set_scope.

Definition image A B (f : A -> B) (X : set A) : set B :=
  [set f a | a in X].

Definition preimage A B (f : A -> B) (X : set B) : set A := [set a | X (f a)].
Arguments preimage A B f X / a.

Definition setT {A} := [set _ : A | True].

Definition set0 {A} := [set _ : A | False].

Definition set1 A (x : A) := [set a : A | a = x].

Definition setI A (X Y : set A) := [set a | X a /\ Y a].

Definition setU A (X Y : set A) := [set a | X a \/ Y a].

Definition nonempty A (X : set A) := exists x, X x.

Definition setC A (X : set A) := [set a | ~ X a].

Definition setD A (X Y : set A) := [set a | X a /\ ~ Y a].

Notation "[ 'set' a ]" := (set1 a)
  (at level 0, a at level 99, format "[ 'set'  a ]") : classical_set_scope.
Notation "[ 'set' a : T ]" := [set (a : T)]
  (at level 0, a at level 99, format "[ 'set'  a   :  T ]") : classical_set_scope.
Notation "A `|` B" := (setU A B) : classical_set_scope.
Notation "a |` A" := ([set a] `|` A) : classical_set_scope.
Notation "[ 'set' a1 ; a2 ; .. ; an ]" := (setU .. (a1 |` [set a2]) .. [set an])
  (at level 0, a1 at level 99,
   format "[ 'set'  a1 ;  a2 ;  .. ;  an ]") : classical_set_scope.
Notation "A `&` B" := (setI A B) : classical_set_scope.
Notation "~` A" := (setC A) (at level 35, right associativity) : classical_set_scope.
Notation "[ 'set' ~ a ]" := (~` [set a])
  (at level 0, format "[ 'set' ~  a ]") : classical_set_scope.
Notation "A `\` B" := (setD A B) : classical_set_scope.
Notation "A `\ a" := (A `\` [set a]) : classical_set_scope.

Definition bigsetI A I (P : set I) (X : I -> set A) :=
  [set a | forall i, P i -> X i a].
Definition bigsetU A I (P : set I) (X : I -> set A) :=
  [set a | exists2 i, P i & X i a].

Notation "\bigcup_ ( i 'in' P ) F" :=
  (bigsetU P (fun i => F))
  (at level 41, F at level 41, i, P at level 50,
           format "'[' \bigcup_ ( i  'in'  P ) '/  '  F ']'")
 : classical_set_scope.
Notation "\bigcup_ ( i : T ) F" :=
  (\bigcup_(i in @setT T) F)
  (at level 41, F at level 41, i at level 50,
           format "'[' \bigcup_ ( i  :  T ) '/  '  F ']'")
 : classical_set_scope.
Notation "\bigcup_ i F" :=
  (\bigcup_(i : _) F)
  (at level 41, F at level 41, i at level 0,
           format "'[' \bigcup_ i '/  '  F ']'")
 : classical_set_scope.

Notation "\bigcap_ ( i 'in' P ) F" :=
  (bigsetI P (fun i => F))
  (at level 41, F at level 41, i, P at level 50,
           format "'[' \bigcap_ ( i  'in'  P ) '/  '  F ']'")
 : classical_set_scope.
Notation "\bigcap_ ( i : T ) F" :=
  (\bigcap_(i in @setT T) F)
  (at level 41, F at level 41, i at level 50,
           format "'[' \bigcap_ ( i  :  T ) '/  '  F ']'")
 : classical_set_scope.
Notation "\bigcap_ i F" :=
  (\bigcap_(i : _) F)
  (at level 41, F at level 41, i at level 0,
           format "'[' \bigcap_ i '/  '  F ']'")
 : classical_set_scope.

Definition subset A (X Y : set A) := forall a, X a -> Y a.

Notation "A `<=` B" := (subset A B) (at level 70, no associativity)
 : classical_set_scope.
Notation "f @^-1` A" := (preimage f A) (at level 24) : classical_set_scope.
Notation "f @` A" := (image f A) (at level 24) : classical_set_scope.
Notation "A !=set0" := (nonempty A) (at level 80) : classical_set_scope.

Lemma setIC A (X Y : set A) : X `&` Y = Y `&` X.
Proof. by apply/funext => ?; apply/propext; apply: and_comm. Qed.

Lemma empty_setI A (X Y : set A) : X = set0 -> X `&` Y = set0.
Proof.
by move=> X0; apply/funext => a; apply/propext; split=> // - []; rewrite X0.
Qed.

Lemma bigcap_setI A I (F : set I) (f : I -> set A) (X : set A) i :
  F i -> \bigcap_(i in F) f i `&` X = \bigcap_(i in F) (f i `&` X).
Proof.
move=> Fi; apply/funext => a; apply/propext; split.
  by move=> [Ifa Xa] j Fj; split=> //; apply: Ifa.
move=> IfIXa; split; [by move=> j /IfIXa []|by have /IfIXa [] := Fi].
Qed.

Lemma setI_bigcap A I (F : set I) (f : I -> set A) (X : set A) i :
  F i -> X `&` \bigcap_(i in F) f i = \bigcap_(i in F) (X `&` f i).
Proof.
move=> Fi; rewrite setIC (bigcap_setI _ _ Fi).
by apply/funext => a; apply/propext; split=> IfIXa j /IfIXa; rewrite setIC.
Qed.

Lemma setDE A (X Y : set A) : X `\` Y = X `&` ~` Y.
Proof. by []. Qed.

Lemma bigcap_setD A I (F : set I) (f : I -> set A) (X : set A) i :
  F i -> \bigcap_(i in F) f i `\` X = \bigcap_(i in F) (f i `\` X).
Proof. by move=> Fi; rewrite setDE (bigcap_setI _ _ Fi). Qed.

Lemma imageP A B (f : A -> B) (X : set A) a : X a -> (f @` X) (f a).
Proof. by exists a. Qed.

Lemma sub_image_setI A B (f : A -> B) (X Y : set A) :
  f @` (X `&` Y) `<=` f @` X `&` f @` Y.
Proof. by move=> b [x [Xa Ya <-]]; split; apply: imageP. Qed.
Arguments sub_image_setI {A B f X Y} a _.

Lemma nonempty_image A B (f : A -> B) (X : set A) :
  f @` X !=set0 -> X !=set0.
Proof. by case=> b [a]; exists a. Qed.

Lemma nonempty_preimage A B (f : A -> B) (X : set B) :
  f @^-1` X !=set0 -> X !=set0.
Proof. by case=> [a ?]; exists (f a). Qed.

Lemma subset_empty A (X Y : set A) : X `<=` Y -> X !=set0 -> Y !=set0.
Proof. by move=> sXY [x Xx]; exists x; apply: sXY. Qed.

Lemma subset_trans A (Y X Z : set A) : X `<=` Y -> Y `<=` Z -> X `<=` Z.
Proof. by move=> sXY sYZ ? ?; apply/sYZ/sXY. Qed.

Lemma nonempty_preimage_setI A B (f : A -> B) (X Y : set B) :
  (f @^-1` (X `&` Y)) !=set0 <-> (f @^-1` X `&` f @^-1` Y) !=set0.
Proof. by split; case=> x ?; exists x. Qed.

Lemma subsetC A (X Y : set A) : X `<=` Y -> ~` Y `<=` ~` X.
Proof. by move=> sXY ? nYa ?; apply/nYa/sXY. Qed.

Lemma subsetU A (X Y Z : set A) : X `<=` Z -> Y `<=` Z -> X `|` Y `<=` Z.
Proof. by move=> sXZ sYZ a; apply: or_ind; [apply: sXZ|apply: sYZ]. Qed.

Lemma subset_Dempty A (X Y : set A) : X `<=` Y -> X `\` Y = set0.
Proof.
move=> sXY; apply/funext => a; apply/propext; split=> // - [Xa].
by apply; apply/sXY.
Qed.

Lemma Dempty_subset A (X Y : set A) : X `\` Y = set0 -> X `<=` Y.
Proof.
move=> XDY0 a Xa; apply: NNPP=> /(conj Xa).
by rewrite -[_ /\ _]/((_ `\` _) _) XDY0.
Qed.

Structure canonical_filter_on X Y := CanonicalFilterOn {
  canonical_filter_term : X;
  _ : set (set Y)
}.
Definition canonical_term_filter X Y (F : canonical_filter_on X Y) :=
  let: CanonicalFilterOn x f := F in f.

Structure canonical_filter Y := CanonicalFilter {
  canonical_filter_type :> Type;
  _ : canonical_filter_type -> set (set Y)
}.
Definition canonical_type_filter Y (F : canonical_filter Y) :
  F -> set (set Y) :=
  let: CanonicalFilter X f := F in f.

Canonical default_filter_term Y (X : canonical_filter Y) (x : X) :=
  @CanonicalFilterOn X Y x (canonical_type_filter x).

Structure canonical_filter_source Z Y := CanonicalFilterSource {
  canonical_filter_source_type :> Type;
  _ : (canonical_filter_source_type -> Z) -> set (set Y)
}.
Definition canonical_source_filter Z Y (F : canonical_filter_source Z Y) :
  (F -> Z) -> set (set Y) :=
  let: CanonicalFilterSource X f := F in f.

Canonical default_arrow_filter Y Z (X : canonical_filter_source Z Y) :=
  @CanonicalFilter _ (X -> Z) (@canonical_source_filter _ _ X).

Canonical source_filter_filter Y :=
  @CanonicalFilterSource Prop _ (_ -> Prop) (@id (set (set Y))).

Canonical filter_uniform_space (U : UniformSpace) :=
  @CanonicalFilter _ U (@locally U).

Canonical filter_normed_module (K : AbsRing) (V : NormedModule K) :=
  @CanonicalFilter _  V (@locally V).

Canonical filter_Rbar := CanonicalFilter (Rbar_locally).
Canonical filter_R := CanonicalFilter (fun x : R => locally x).

Definition filter_of X Y (F : canonical_filter_on X Y)
  (x : X) (_ : phant_id x (canonical_filter_term F)) :=
  canonical_term_filter F.
Notation "[ 'filter' 'of' x ]" := (@filter_of _ _ _ x idfun)
  (format "[ 'filter'  'of'  x ]").
Arguments filter_of _ _ _ _ _ _ /.

Notation "x @ F" := (filtermap x [filter of F])
  (at level 60, format "x  @  F") : classical_set_scope.

Notation "F --> G" := (filter_le [filter of F] [filter of G])
  (at level 70, format "F  -->  G") : classical_set_scope.

Notation "'+oo'" := p_infty : classical_set_scope.

Canonical eventually_filter X :=
  @CanonicalFilterSource X _ nat (fun f => f @ eventually).

Definition cvg (U : UniformSpace) (F : set (set U)) : Prop :=
  exists l : U, F --> l.
Notation "[ 'cvg' F ]" := (cvg [filter of F])
  (format "[ 'cvg'  F ]") : classical_set_scope.

(* missing notation *)
Definition normedModule_of (T : AbsRing) (_ : phantom Type (AbsRing.sort T)) :=
  NormedModule T.
Notation "{ 'normedModule' T }" := (@normedModule_of _ (Phantom Type T))
  (at level 0, format "{ 'normedModule'  T }") : type_scope.

(* frequent composition *)
Lemma is_derive_shift K (V : NormedModule K) (f : K -> V) x l s :
  is_derive f (plus x s) l -> is_derive (fun y => f (plus y s)) x l.
Proof.
move=> f'_plus.
rewrite -[l]scal_one.
apply: is_derive_comp=> //.
rewrite -[one]plus_zero_r.
apply: is_derive_plus.
  exact: is_derive_id.
exact: is_derive_const.
Qed.

Section Cvg_to_set.

Variable (U : UniformSpace).
Implicit Types (p : U) (A B : set U).

(* The extension of a set with a band of width eps *)
Definition ball_set (A : set U) (eps : posreal) :=
  \bigcup_(p in A) ball p eps.

(* locally_set A P means that P holds for every point sufficiently near of A *)
Definition locally_set (A : set U) :=
  [set B | exists eps, ball_set A eps `<=` B].

Canonical filter_set_uniform_space :=
  @CanonicalFilterSource Prop _ U locally_set.

Lemma locally_set1P (p : U) A : locally p A <-> locally_set [set p] A.
Proof.
split=> - [eps peps_A]; exists eps.
  by move=> q [r [-> /peps_A]].
by move=> q pq_eps; apply: peps_A; exists p.
Qed.

Lemma locally_set_filter_le (A B : set U) : A `<=` B -> A --> B.
Proof.
move=> sAB C [eps /= Beps_C]; exists eps.
by move=> p [q /sAB Bq qp_eps]; apply: Beps_C; exists q.
Qed.

Lemma locally_set_subset A B :
  locally_set A B -> forall C, B `<=` C -> locally_set A C.
Proof. by move=> [eps Aeps_B] C sBC; exists eps; move=> y /Aeps_B /sBC. Qed.

Instance locally_set_filter (A : set U) : Filter (locally_set A).
Proof.
constructor; last 1 first.
- by move=> B C sBC nAB; apply: locally_set_subset sBC.
- by exists (mkposreal _ Rlt_0_1).
move=> B C [eps1 Aeps1_B] [eps2 Aeps2_C].
exists (mkposreal _ (Rmin_stable_in_posreal eps1 eps2)).
move=> p [q qinA q_near_p]; split.
  apply: Aeps1_B; exists q => //.
  exact: ball_le (Rmin_l _ _) _ q_near_p.
apply: Aeps2_C; exists q => //.
exact: ball_le (Rmin_r _ _) _ q_near_p.
Qed.

Lemma cvg_to_set1P (x : R -> U) p : x @ +oo --> [set p] <-> x @ +oo --> p.
Proof. by split=> hx P /locally_set1P; apply: hx. Qed.

Lemma cvg_to_superset A B x : A `<=` B ->
  x @ +oo --> A -> x @ +oo --> B.
Proof.
move=> sAB xtoA C /= [eps Beps_C]; apply: xtoA => /=.
by exists eps; apply: subset_trans Beps_C => p [q /sAB]; exists q.
Qed.

End Cvg_to_set.

Section Closedness.

Variable (U : UniformSpace).

Definition closure (A : set U) :=
  [set p | forall B, locally p B -> A `&` B !=set0].

Instance within_locally_proper (A : set U) p :
  closure A p -> ProperFilter (within A (locally p)).
Proof.
move=> Abarp; apply: Build_ProperFilter => B.
by move=> /Abarp [q [Aq AqsoBq]]; exists q; apply: AqsoBq.
Qed.

Lemma subset_closure (A : set U) : A `<=` closure A.
Proof. by move=> p B Bp; exists p; split=> //; apply: locally_singleton. Qed.

Definition is_closed (A : set U) := closure A `<=` A.

Lemma closed_is_closed (A : set U) : closed A -> is_closed A.
Proof. by move=> Aclosed p Abarp; apply: Aclosed => /Abarp [? []]. Qed.

Lemma closedP (A : set U) : closed A <-> is_closed A.
Proof.
split; first exact: closed_is_closed .
move=> Aclosed p /not_ex_all_not npnA; apply: Aclosed.
move=> B [eps peps_B].
have /not_all_ex_not [q] := npnA eps.
(* Show Enrico: move/(@imply_to_and _ _). *)
by move=> /(imply_to_and (ball _ _ _)) [/peps_B Bq /NNPP Aq]; exists q.
Qed.

Lemma is_closed_closure (A : set U) : is_closed (closure A).
Proof.
move=> p hp B [eps peps_B].
have /= [q [Abarq pq_heps]] := hp (ball p (pos_div_2 eps)) (locally_ball _ _).
have /= [r [Ar qr_heps]] := Abarq (ball q (pos_div_2 eps)) (locally_ball _ _).
exists r; split=> //; apply/peps_B.
rewrite [X in ball _ X]double_var.
exact: ball_triangle qr_heps.
Qed.

Lemma closure_bigcap I (F : set I) (f : I -> set U) :
  closure (\bigcap_(A in F) f A) `<=` \bigcap_(A in F) closure (f A).
Proof.
move=> p IFbarp A FA B /IFbarp [q [IFq Bq]].
by exists q; split=> //; apply: IFq.
Qed.

Lemma is_closed_bigcap I (F : set I) (f : I -> set U) :
  (forall A, F A -> is_closed (f A)) -> is_closed (\bigcap_(A in F) f A).
Proof.
move=> clfamF => p /closure_bigcap clFp A FA.
by apply: (clfamF _ FA); apply: clFp.
Qed.

Lemma is_closed_setI (A B : set U) :
  is_closed A -> is_closed B -> is_closed (A `&` B).
Proof.
by move=> Acl Bcl p ABbarp; split; [apply: Acl|apply: Bcl];
  move=> C /ABbarp [q [[]]]; exists q.
Qed.

Lemma is_closed_setC (A : set U) : open A -> is_closed (~` A).
Proof. by move=> Aop p ACbar_p /Aop /ACbar_p [? []]. Qed.

End Closedness.

Section Openness.

Variable (U : UniformSpace).

Definition interior (A : set U) := locally^~ A.

Notation "A ^°" := (interior A) (at level 1, format "A ^°").

Lemma interior_subset (A : set U) : A^° `<=` A.
Proof. by move=> ? [?]; apply; apply: ball_center. Qed.

Lemma openP (A : set U) : open A <-> A `<=` A^°.
Proof. by split=> opA ? /opA. Qed.

Lemma subset_interior (A : set U) : open A -> A `<=` A^°.
Proof. by move/openP. Qed.

Lemma open_interior (A : set U) : open A^°.
Proof.
move=> p [eps peps_A]; exists (pos_div_2 eps) => q pheps_q.
exists (pos_div_2 eps) => r qheps_r.
by apply: peps_A; rewrite [_ eps]double_var; apply: ball_triangle qheps_r.
Qed.

Lemma interior_bigcup I (F : set I) (f : I -> set U) :
  \bigcup_(A in F) (f A)^° `<=` (\bigcup_(A in F) f A)^°.
Proof. by move=> p [B ? [eps peps_fB]]; exists eps => q /peps_fB; exists B. Qed.

Lemma open_bigcup I (F : set I) (f : I -> set U) :
  (forall A, F A -> open (f A)) -> open (\bigcup_(A in F) f A).
Proof.
move=> opfamF; apply/openP => p [i Fi fip]; apply: interior_bigcup.
by exists i => //; apply: subset_interior => //; apply: opfamF.
Qed.

End Openness.

Lemma between_epsilon x y z :
  (forall eps : posreal, x - eps <= y <= z + eps) -> x <= y <= z.
Proof.
move=> xyz_eps.
by split; apply: le_epsilon=> eps epsgt0; [apply/Rle_minus_l|];
  have [] := xyz_eps (mkposreal _ epsgt0).
Qed.

Definition seg a b := Rle a `&` Rle^~ b.

Lemma seg_closed a b : is_closed (seg a b).
Proof.
move=> x abbarx; apply: between_epsilon => eps.
have /abbarx [y [[aley yleb]]] := locally_ball x eps.
move/AbsRing_norm_compat2; rewrite Rmult_1_l abs_minus.
move/Rlt_le/Rabs_le_between'=> [ymepslex xleypeps].
split; first by apply: Rle_trans ymepslex; apply: Rplus_le_compat_r.
by apply: Rle_trans; [apply: xleypeps|apply: Rplus_le_compat_r].
Qed.

(* Code adapted from Guillaume Cano's PhD *)
Section Ensemble.

Variable T : Type.

Definition in_set (p : T) (A : set T) := A p.
Notation "p \ins A" := (in_set p A) (at level 3).

Lemma insE p (A : set T) : p \ins A = A p.
Proof. done. Qed.

Definition eqset (A B : set T) : Prop := forall p, p \ins A  <-> p \ins B.

End Ensemble.

Notation "p \ins A" := (in_set p A) (at level 3).
Notation "A `=` B" := (eqset A B) (at level 70, no associativity).

Section famille.

Variable T : Type.
Variable Ti : Type.

Structure family : Type := mkfamily  {
     ind :  set Ti;
     F :> Ti -> set T
   }.

Definition finite_set (T1 : Type) (A : set T1) :=
  exists l : list T1, A `=` (fun p => List.In p l).

Structure finite_family := Ff {
   fam :> family;
   hfam : finite_set (ind fam)
}.

Definition ffam (f : family) := finite_set (ind f).

Lemma finfam : forall (f : finite_family), ffam f.
Proof. by case. Qed.

Lemma finfam_empty F : ffam (mkfamily set0 F).
Proof. by exists nil. Qed.

Lemma finfamU (f g : finite_family) F :
  ffam (mkfamily (ind f `|` ind g) F).
Proof.
have [l hl] := hfam f; have [l' hl'] := hfam g.
exists (l ++ l'); move=> j; apply: iff_trans; last apply iff_sym, in_app_iff.
apply: iff_trans; first exact/or_iff_compat_l/hl'.
exact/or_iff_compat_r/hl.
Qed.

Lemma finfam_sing i F : ffam (mkfamily (eq^~ i) F).
Proof.
exists (i :: nil).
move=> j; rewrite /in_set; split; first by move->; apply: in_eq.
by move/(@in_inv _ i j)=> hj; apply: or_ind hj.
Qed.

Lemma finfam_ext (f : finite_family) F : ffam (mkfamily (ind f) F).
Proof. by have [l] := finfam f; exists l. Qed.

Definition inter_fam (f : family) := \bigcap_(i in ind f) f i.

Definition union_fam (f : family) := \bigcup_(i in ind f) f i.

Definition cover (A : set T) (f : family) := A `<=` union_fam f.

Lemma cover_setI A (f g : family) :
  ind g `=` ind f -> (forall i, i \ins (ind f) -> f i `=` A `&` g i) ->
  cover A f <-> cover A g.
Proof.
move=> gieqfi fiAgi.
split.
  move=> fcov p Ap.
  have /fcov [j fij fjp] := Ap.
  exists j; first exact/gieqfi.
  apply: proj2.
  exact/(fiAgi _ fij).
move=> gcov p Ap.
have /gcov [j /gieqfi fij gjp] := Ap.
exists j => //.
exact/fiAgi.
Qed.

Definition sub_family f g :=
  ind g `<=` ind f /\ forall i, i \ins (ind g) -> f i `=` g i.

Definition finite_inter (f : family) :=
  forall g : finite_family, sub_family f g -> inter_fam g !=set0.

Definition fixed (f : family) := inter_fam f !=set0.

Lemma cover_setC A (f : family) :
  ~ fixed f -> cover A (mkfamily (ind f) (fun i => ~` f i)).
Proof.
move=> /not_ex_all_not if0 p Ap.
have /not_all_ex_not [i] := if0 p.
move/(imply_to_and (i \ins (ind f)))=> [fii nfix].
by exists i.
Qed.

Lemma nfixed_setC A (f : family) j : ind f j ->
  cover A f -> ~ fixed (mkfamily (ind f) (fun i => A `\` f i)).
Proof.
move=> fij fcov [q AnfIq]; have /AnfIq [Aq _] := fij.
by have /fcov [k fik fkq] := Aq; have /AnfIq [] := fik.
Qed.

End famille.
(* *)

Lemma filter_bigcap (U : UniformSpace) I (G : set I) (f : I -> set U)
  (F : set (set U)) :
  Filter F -> finite_set G -> (forall i, G i -> F (f i)) ->
  F (\bigcap_(i in G) f i).
Proof.
move=> Ffilter [l Geql] sfGF.
have himp : forall p, (forall i, In i l -> f i p) -> (\bigcap_(i in G) f i) p.
  by move=> p hp i /Geql /hp.
apply: filter_imp himp _.
have {sfGF} : forall i, In i l -> F (f i) by move=> i /Geql; apply: sfGF.
elim: l G Geql => [|a l ihl] G Geql sfGF; first exact: filter_imp filter_true.
apply: (filter_imp (f a `&` [set p|forall i, In i l -> f i p])).
  by move=> p [fap flp] i; apply: or_ind; [move<-|apply: flp].
apply: filter_and; first by apply: sfGF; left.
by apply: (ihl (In(A:=I)^~ l))=> // i li; apply: sfGF; right.
Qed.

Lemma filter_finite_inter (U : UniformSpace) (F : set (set U)) Ti
  (f : family U Ti) :
  ProperFilter F -> (forall i, i \ins (ind f) -> F (f i)) -> finite_inter f.
Proof.
move=> Fproper sfF g [ind_sgf gieqfi]; apply: filter_ex.
suff : F (\bigcap_(i in ind g) f i).
  apply: filter_imp => p If_indg_p j gij; apply/gieqfi => //.
  exact: If_indg_p.
by apply: filter_bigcap (hfam _) _ => i /ind_sgf; apply: sfF.
Qed.

Section Compactness.

Variables (U : UniformSpace).

Definition cluster (F : set (set U)) p :=
  forall A B, F A -> locally p B -> A `&` B !=set0.

Lemma clusterE F : cluster F = \bigcap_(A in F) (closure A).
Proof. by apply/funext=> p; apply/propext; split => cF ????; apply: cF. Qed.

Lemma filter_le_cluster F G : filter_le F G -> cluster F `<=` cluster G.
Proof. by move=> sGF p Fp P Q GP Qp; apply: Fp Qp; apply: sGF. Qed.

Definition compact A := forall (F : set (set U)), F A ->
  ProperFilter F -> A `&` cluster F !=set0.

Lemma subclosed_compact (A B : set U) :
  is_closed A -> compact B -> A `<=` B -> compact A.
Proof.
move=> Acl Bco sAB F FA Fproper.
have [|p [Bp Fp]] := Bco F; first exact: filter_imp FA.
by exists p; split=> //; apply: Acl=> C Cp; apply: Fp.
Qed.

Definition hausdorff := forall p q : U, cluster (locally p) q -> p = q.

Lemma hausdorffP : hausdorff <-> forall p q : U, p <> q -> exists A B,
  locally p A /\ locally q B /\ forall r, ~ (A `&` B) r.
Proof.
split=> h p q; last first.
  move=> hpq; apply: NNPP; move/h=> [A [B [pA [qB hAB]]]].
  by have [] := hpq _ _ pA qB.
have : p <> q ->
  ~ (forall A B, locally p A -> locally q B -> A `&` B !=set0).
  exact: impliesPn (Implies (h p q)).
move=> hpq /hpq /not_all_ex_not [A] /not_all_ex_not [B].
move/(imply_to_and (locally _ _))=> [pA].
move/(imply_to_and (locally _ _))=> [qB] /not_ex_all_not hAB.
by exists A; exists B.
Qed.

Lemma compact_closed (A : set U) : hausdorff -> compact A -> is_closed A.
Proof.
move=> hU Acompact p Abarp.
have pA : within A (locally p) A by exists (mkposreal _ Rlt_0_1).
have [q [Aq hq]] := Acompact _ pA (within_locally_proper Abarp).
rewrite (hU p q) //.
apply: filter_le_cluster hq.
exact: filter_le_within.
Qed.

(* Code adapted from Guillaume Cano's PhD *)
Definition open_family Ti (f : family U Ti) :=
  forall i, i \ins (ind f) -> open (f i).

Definition closed_family Ti (f : family U Ti) :=
  forall i, i \ins (ind f) -> is_closed (f i).

Definition quasi_compact (A : set U) :=
   forall Ti (f : family U Ti),
   open_family f -> cover A f ->
   exists g : finite_family U Ti, sub_family f g /\ cover A g.

Definition closed_of_family A Ti (f : family U Ti) :=
  exists g : family U Ti, closed_family g /\ ind g `=` ind f /\
  forall i, i \ins (ind f) -> f i `=` A `&` g i.

Definition open_of_family A Ti (f : family U Ti) :=
  exists g : family U Ti, open_family g /\ ind g `=` ind f /\
  forall i, i \ins (ind f) -> f i `=` A `&` g i.

Lemma closed_of_setC A Ti (f : family U Ti) : open_of_family A f ->
  closed_of_family A (mkfamily (ind f) (fun i => A `\` f i)).
Proof.
move=> [g [opg [gieqfi hgi]]].
exists (mkfamily (ind f) (fun i => ~` (g i))).
split; first by move=> j /gieqfi gij; apply/is_closed_setC/opg.
split=> // j /= fij p; split.
  by move=> [Ap nfjp]; split=> // gjp; apply/nfjp/hgi.
move=> [Ap ngjp]; split=> // fjp.
apply/ngjp; apply: proj2; exact/hgi.
Qed.

Lemma open_of_setC A Ti (f : family U Ti) : closed_of_family A f ->
  open_of_family A (mkfamily (ind f) (fun i => A `\` f i)).
Proof.
move=> [g [gclo [gieqfi hgi]]].
exists (mkfamily (ind f) (fun i => ~` (g i))).
split; first by move=> j /gieqfi gij; apply/open_not/closedP/gclo.
split=> // j /= fij p; split.
  by move=> [Ap nfjp]; split=> // gjp; apply/nfjp/hgi.
move=> [Ap ngjp]; split=> // fjp.
apply/ngjp; apply: proj2; exact/hgi.
Qed.
(* *)

Lemma qcompactE A :
  quasi_compact A <-> forall Ti (f : family U Ti) (j : Ti), ind f j ->
    open_family f -> cover A f -> exists (g : finite_family U Ti) (k : Ti),
    ind g k /\ sub_family f g /\ cover A g.
Proof.
split=> [coA Ti f j fij|coA Ti f] opf covf.
  have [g [[ind_sgf fieqgi] gcov]] := coA _ _ opf covf.
  exists (Ff (finfamU g (Ff (finfam_sing j (F f))) (F f))); exists j => /=.
  split; first by right.
  split; first by split=> // k; apply: or_ind => [|->] //; apply: ind_sgf.
  by move=> p /gcov [k gik /(fieqgi _ gik) gkp]; exists k => //; left.
apply: or_ind (classic (ind f !=set0)).
  by move=> [j fij]; have [g [_ [_ []]]] := coA _ _ _ fij opf covf; exists g.
move=> /not_ex_all_not ind_f0.
have finf : ffam f by exists nil; move=> j; split; [move/ind_f0|].
by exists (Ff finf); split=> //; split.
Qed.

Lemma qcompact_set A :
  quasi_compact A <->
  (forall Ti (f : family U Ti) (j : Ti), ind f j -> open_of_family A f ->
    cover A f -> exists (g : finite_family U Ti) (k : Ti),
    ind g k /\ sub_family f g /\ cover A g).
Proof.
apply: iff_trans (qcompactE A) _.
split=> [coA Ti f j fij [g [opg [ind_geqf fieqAgi]]]|coA Ti f j fij opf] fcov.
  have gcov : cover A g by apply/(cover_setI ind_geqf fieqAgi).
  have gij : ind g j by apply/ind_geqf.
  have [h [k [hik [[ind_shg gieqhi] hcov]]]] := coA _ _ _ gij opg gcov.
  exists (Ff (finfam_ext h f)); exists k; split=> //=.
  split; first by split=> // l /ind_shg /ind_geqf.
  move=> p Ap; have /hcov [l hil hlp] := Ap; exists l=> //=.
  apply/fieqAgi; first exact/ind_geqf/ind_shg.
  by split=> //; apply/gieqhi.
have Afcov : cover A (mkfamily (ind f) (fun i => A `&` f i)).
  by apply/cover_setI; last exact: fcov.
have opAf : open_of_family A (mkfamily (ind f) (fun i => A `&` f i)).
  by exists f.
have /(_ fij) [g [k [gik [[ind_sgAf Afieqgi] gcov]]]] := coA _ _ j _ opAf Afcov.
exists (Ff (finfam_ext g f)); exists k; split=> //=; split=> // p Ap.
by have /gcov [l gil /(Afieqgi _ gil) []] := Ap; exists l.
Qed.

Lemma qcompact_fixed (A : set U) :
  quasi_compact A <->
  (forall Ti (f : family U Ti) (j : Ti), ind f j -> closed_of_family A f ->
    finite_inter f -> fixed f).
Proof.
apply: iff_trans (qcompact_set A) _.
split=> [coA Ti f j fij clf|fixA Ti f j fij opf fcov].
  suff : ~ fixed f -> exists g : finite_family U Ti,
    sub_family f g /\ ~ fixed g.
    move=> contra; apply: NNPP.
    move/(imply_to_and (finite_inter _))=> [finIf] /contra [h [sfh Ih0]].
    by apply: Ih0; have /finIf [q] := sfh; exists q.
  move=> If0.
  have Anfcov : cover A (mkfamily (ind f) (fun i => A `\` (f i))).
    by apply/cover_setI; last apply: cover_setC If0.
  have /open_of_setC opAnf := clf.
  have /(_ fij) := coA _ _ j _ opAnf Anfcov.
  move=> [g [k [gik [[ind_sgAnf Anfieqgi] gcov]]]].
  exists (Ff (finfam_ext g (fun i => A `&` ~` g i))).
  split; last exact: nfixed_setC gik gcov.
  split=> //= l gil q; split.
    move=> flq; split; last by move=> /Anfieqgi - /(_ gil) [].
    have fil : ind f l by apply/ind_sgAnf.
    have [h [_ [_ fieqAhi]]] := clf.
    by have /fieqAhi /(_ q) /proj1 /(_ flq) [] := fil.
  move=> [Aq /Anfieqgi] /(_ gil) /not_and_or /or_to_imply /(_ Aq).
  exact: NNPP.
apply: NNPP; move/not_ex_all_not=> sfncov; apply/(nfixed_setC fij fcov).
apply: (fixA _ _ j) (closed_of_setC opf) _; first exact: fij.
move=> h [ind_shf Anfieqhi].
have shf : sub_family f (mkfamily (ind h `|` eq^~ j) f).
  by split=> //= k; apply: or_ind => [|->] //; apply: ind_shf.
have /= := sfncov (Ff (finfamU h (Ff (finfam_sing j (F f))) (F f))).
move=> /not_ex_all_not /(_ j) /not_and_or /or_to_imply /(_ (or_intror _)).
move=> /(_ eq_refl) /not_and_or /or_to_imply /(_ shf).
move=> /not_all_ex_not [q] /(imply_to_and (A _)) [Aq hq]; exists q => k hik.
by apply/Anfieqhi => //; split=> // fkq; apply: hq; exists k=> //; left.
Qed.

Lemma fin_inter_filter Ti (f : family U Ti) :
  finite_inter f -> Filter (fun A => exists g : finite_family U Ti,
    sub_family f g /\ inter_fam g `<=` A).
Proof.
move=> ffin; split.
- by exists (Ff (finfam_empty (fun _ _ => True))); split=> //; split.
- move=> A B [g [[sigif sgf] sigA]] [h [[sihif shf] sihB]].
  exists (Ff (finfamU g h
    (fun i p => (ind g i -> g i p) /\ (ind h i -> h i p)))); split=> /=.
    split; first exact: subsetU.
    move=> /= j kij p; split.
      move=> fjp.
      split; first by move/sgf=> eqgfj; apply/eqgfj.
      by move/shf=> eqhfj; apply/eqhfj.
    move=> [gp hp].
    apply: or_ind kij.
      move=> gij; apply/sgf=> //; exact: gp.
    move=> hij; apply/shf=> //; exact: hp.
  move=> p ikp; split.
    apply: sigA; move=> j gij.
    by have [/(_ gij)] := ikp j (or_introl (ind h j) gij).
  apply: sihB; move=> j hij.
  by have [_ /(_ hij)] := ikp j (or_intror (ind g j) hij).
- move=> A B sAB [g [sgf sigA]].
  by exists g; split=> //; apply: subset_trans sAB.
Qed.

Lemma fin_inter_proper Ti (f : family U Ti) :
  finite_inter f -> ProperFilter (fun A => exists g : finite_family U Ti,
    sub_family f g /\ inter_fam g `<=` A).
Proof.
move=> ffin.
split; last exact: fin_inter_filter.
move=> A [g [sgf sigA]].
have /ffin [p igp] := sgf.
exists p.
exact: sigA.
Qed.

Lemma compact_fixed A :
  compact A <-> forall Ti (f : family U Ti) (j : Ti), ind f j ->
  closed_of_family A f -> finite_inter f -> fixed f.
Proof.
split=> [coA Ti f j fij [g [clg [ind_geqf fieqAgi]]] finIf|fixA F FA Fproper].
  have sffam k B : ind f k -> subset (f k) B -> exists g : finite_family U Ti,
    sub_family f g /\ subset (inter_fam g) B.
    move=> fik sfkB; exists (Ff (finfam_sing k f)); split.
      by split=> // ? ->.
    by move=> p fkp; apply/sfkB/fkp.
  have [|p [Ap clfinIfp]] := coA _ _ (fin_inter_proper finIf).
    by apply: (sffam _ _ fij); move=> p /(fieqAgi _ fij) [].
  exists p => k fik; apply/(fieqAgi _ fik); split=> //.
  apply: clg; first exact/ind_geqf.
  move=> B pB; apply: clfinIfp pB.
  by apply: (sffam _ _ fik); move=> q /(fieqAgi _ fik) [].
have finIAclF : finite_inter (mkfamily F (fun B => A `&` closure B)).
  apply: filter_finite_inter => B FB; apply: filter_and=> //.
  exact: filter_imp (@subset_closure _ B) _.
have /(_ FA) [|p AclFIp] := fixA _ _ A _ _ finIAclF.
  exists (mkfamily F (fun B => closure B)); split=> // B FB.
  exact: is_closed_closure.
exists p; split=> [|B C FB pC]; first by have /AclFIp [] := FA.
by have /AclFIp [_] := FB; move=> /(_ _ pC).
Qed.

Lemma compactP A : compact A <-> quasi_compact A.
Proof.
by apply: iff_trans (compact_fixed A) _; apply: iff_sym; apply: qcompact_fixed.
Qed.

Lemma fixed_compactP A :
  (forall Ti (f : family U Ti) j, ind f j -> closed_of_family A f ->
   finite_inter f -> fixed f) <->
  forall I (F : set I) (f : I -> set U), F !=set0 -> (exists (g : I -> set U),
    forall i, F i -> f i = A `&` g i /\ is_closed (g i)) ->
    \bigcap_(i in F) f i = set0 -> exists (G : set I), finite_set G /\
      G `<=` F /\ \bigcap_(i in G) f i = set0.
Proof.
split.
  move=> coA I F f [j Fj] [g clAg] If0.
  have clAf : closed_of_family A (mkfamily F f).
    exists (mkfamily F g); split; first by move=> i /clAg [].
    by split=> //= i /clAg [->].
  have /(_ Fj) := coA _ _ j _ clAf.
  move=> /(@Implies (finite_inter _)) /impliesPn nfixed_nfinI.
  have /nfixed_nfinI /not_all_ex_not : ~ fixed (mkfamily F f).
    by move=> [p Ifp]; rewrite -[False]/(set0 p) -If0.
  move=> [h /(@imply_to_and _ (_ !=set0)) [[ind_shf hieqfi] Ih0]].
  exists (ind h); split; first (exact: hfam); split=> //.
  apply/funext => p; apply/propext; split=> // Ihfp; apply: Ih0.
  by exists p => k hik; apply/hieqfi => //; apply: Ihfp.
move=> coA Ti f j fij [g [clg [ind_geqf fieqAgi]]].
apply: NNPP => /(@imply_to_and (finite_inter _)) [finIf nfixedf].
have /coA : \bigcap_(i in ind f) f i = set0.
  by apply/funext=> a; apply/propext; split=> // Ifa; apply: nfixedf; exists a.
move=> []; first by exists j.
  exists (F g) => k fik; split; last exact/clg/ind_geqf.
  by apply/funext => a; apply/propext; move: a; apply: fieqAgi.
move=> G [finG [sGindf IGf0]].
have /finIf [p IGfp] : sub_family f (@Ff _ _ (mkfamily G f) finG) by [].
by rewrite -[False]/(set0 p) -IGf0.
Qed.

Lemma filter_cluster (F : set (set U)) (A : set U) :
  ProperFilter F -> F A -> compact A ->
  forall eps : posreal, F (ball_set (cluster F) eps).
Proof.
move=> Fproper FA /compact_fixed /fixed_compactP coA eps.
set B := ball_set (cluster F) eps.
have /subset_Dempty /(empty_setI A) : cluster F `<=` interior B.
  by move=> p clFp; exists eps => q peps_q; exists p.
rewrite setIC clusterE (bigcap_setD _ _ FA) (setI_bigcap _ _ FA).
move=> /coA [||G [finG [sGF clGnB0]]]; first by exists setT; apply: filter_true.
  exists (fun C => closure C `\` interior B) => C FC; split=> //.
  apply: is_closed_setI; first exact/is_closed_closure.
  exact/is_closed_setC/open_interior.
have [C GC] : G !=set0.
  apply: NNPP => /not_ex_all_not G0; have /filter_ex [p _] := FA.
  by rewrite -[False]/(set0 p) -clGnB0 => C /G0.
move: clGnB0; have -> : \bigcap_(C in G) (A `&` (closure C `\` interior B)) =
  \bigcap_(C in G) (A `&` closure C `\` interior B).
  apply/funext => a; apply/propext.
  by split=> [IclGa ? /IclGa [? []]|IclGa ? /IclGa [[]]].
rewrite -(bigcap_setD _ _ GC) => /Dempty_subset sIclGintB.
apply: filter_imp (@interior_subset _ B) _; apply: filter_imp sIclGintB _.
apply: filter_bigcap finG _ => D GD; apply: filter_and FA _.
by apply: filter_imp (@subset_closure _ D) _; apply: sGF.
Qed.

End Compactness.

Lemma map_sub_cluster (U V : UniformSpace) (F : set (set U)) (f : U -> V)
  (A : set U) : Filter F -> continuous_on A f -> F A -> is_closed A ->
  f @` (cluster F) `<=` cluster (f @ F).
Proof.
move=> Ffilt fcont FA Acl x [p clFp <-] B C fFB.
have Ap : A p by apply: Acl => ? /clFp - /(_ _ FA).
move=> /(fcont _ Ap) fp_C.
suff /clFp /(_ fp_C) [q [[Aq ?] /(_ Aq)]] : F (A `&` f @^-1` B) by exists (f q).
exact: filter_and FA _.
Qed.

Lemma Rhausdorff : hausdorff R_UniformSpace.
Proof.
move=> x y hxy.
apply/Rle_le_eq/between_epsilon.
move=> eps.
apply/Rabs_le_between'.
set heps := pos_div_2 eps.
have [z []] := hxy _ _ (locally_ball x heps) (locally_ball y heps).
move/AbsRing_norm_compat2/Rlt_le; rewrite Rmult_1_l.
move=> hxz /AbsRing_norm_compat2/Rlt_le; rewrite Rmult_1_l abs_minus.
move=> hyz.
rewrite -[_ - _]/(@minus R_AbsRing _ _) (minus_trans z)
        -[Rabs _]/(@abs R_AbsRing _).
apply: Rle_trans; first exact: abs_triangle.
rewrite [X in _ <= X]double_var.
exact: Rplus_le_compat.
Qed.

Coercion AbsRing_UniformSpace : AbsRing >-> UniformSpace.
Lemma hausdorff_normed_module (K : AbsRing) (V : NormedModule K) : hausdorff V.
Proof.
move=> p q cllocp_q.
suff /norm_eq_zero : norm (minus p q) = 0.
  by rewrite -(minus_eq_zero q); move/plus_reg_r.
apply: Rhausdorff => A B npmq_A.
rewrite -(@norm_zero _ V) -(minus_eq_zero p) => npmp_B.
set f := fun q => norm (minus p q).
have locfpreim r C : locally (f r) C -> locally r (f @^-1` C).
  move=> /locally_norm_le_locally [e npmr_e_C].
  apply: locally_le_locally_norm; exists e => s r_e_s; apply: npmr_e_C.
  apply: Rle_lt_trans (norm_triangle_inv _ _) _.
  by rewrite -norm_opp opp_plus !opp_minus -minus_trans.
have [r []] := cllocp_q _ _ (locfpreim _ _ npmp_B) (locfpreim _ _ npmq_A).
by exists (f r).
Qed.

Definition is_bounded (K : AbsRing) (U : NormedModule K) (A : set U) :=
  exists M, forall p, A p -> norm p < M.

Coercion INR : nat >-> R.

Definition maxn_list (l : list nat) m := fold_left maxn l m.

Lemma dflt_le_maxn_list l m : (m <= maxn_list l m)%N.
Proof.
elim: l m=> [|n l ihl m] //=.
apply: leq_trans; last exact: ihl.
exact: leq_maxl.
Qed.

Lemma le_maxn_list l m n : In n l -> (n <= maxn_list l m)%N.
Proof.
elim: l m=> [|p l ihl m] //=.
apply: or_ind.
  move<-.
  apply: leq_trans; last exact: dflt_le_maxn_list.
  exact: leq_maxr.
exact: ihl.
Qed.

Lemma compact_bounded (K : AbsRing) (U : NormedModule K) (A : set U) :
  compact A -> is_bounded A.
Proof.
move/compactP=> Aco.
have covA : cover A (mkfamily (@setT nat) (fun n p => norm p < n)).
  move=> p Ap.
  have /nfloor_ex [n [_]] := norm_ge_0 p.
  by rewrite -S_INR; exists n.+1.
have /Aco [] := covA.
  move=> n _ p npltn.
  have dltgt0 : 0 < (n - norm p) / (@norm_factor _ U).
    by apply: Rdiv_lt_0_compat norm_factor_gt_0; apply: Rlt_Rminus.
  exists (mkposreal _ dltgt0); move=> q /norm_compat2 /=.
  rewrite -Rmult_assoc Rinv_r_simpl_m; last first.
    exact/Rgt_not_eq/Rlt_gt/norm_factor_gt_0.
  move=> hpq.
  rewrite -[q]minus_zero_r (minus_trans p) minus_zero_r
          -[_ n](Rplus_minus (norm p)) Rplus_comm.
  apply: Rle_lt_trans; first exact: norm_triangle.
  exact: Rplus_lt_compat_r.
move=> f [[sfi sf] fcov].
have [l fil] := finfam f.
exists (fold_left maxn l 0%N).
move=> p /fcov [n fin] /sf /= /(_ fin) npltn.
apply: Rlt_le_trans; first exact: npltn.
apply/le_INR/leP.
by move/fil: fin; apply: le_maxn_list.
Qed.

Section Continuity.

Variables (T U : UniformSpace).

Lemma locally_preimage (x : T -> U) p A :
  continuous x p -> locally (x p) A -> locally p (x @^-1` A).
Proof. by move=> xcontp locxpA; apply: xcontp locxpA. Qed.

Lemma continuous_compact (x : T -> U) A :
  continuous_on A x -> compact A -> compact (x @` A).
Proof.
move=> xcont compactA F FxA Fproper.
set G := [set B | exists2 C, F C & A `&` x @^-1` C `<=` B].
have Gproper : ProperFilter G.
  split.
    move=> B [C FC hC].
    have [q [[p Ap <-] Cq]]: x @` A `&` C !=set0.
      apply: filter_ex; exact: filter_and.
    exists p; exact: hC.
  split.
  - by exists (x @` A).
  - move=> B1 B2 [C1 FC1 hC1] [C2 FC2 hC2].
    exists (C1 `&` C2); first by exact: filter_and.
    move=> p [Ap [C1xp C2xp]].
    split; [exact: hC1 | exact: hC2].
  - move=> B B' subBB' [C FC hC].
    exists C => //.
    exact: subset_trans subBB'.
case: (compactA _ _ Gproper); first by exists (x @` A) => // ? [].
move=> p [Ap hp].
exists (x p).
split; first by apply/imageP.
move=> B C hB hC.
move/xcont: hC=> /(_ Ap) hpC.
have : G (A `&` x @^-1` B) by exists B.
move/hp=> /(_ _ hpC) [q [[Aq Bxq]]] /(_ Aq).
by exists (x q).
Qed.

End Continuity.

Lemma derive_ext_ge0 f g x :
  0 <= x -> (forall y, 0 <= y -> f y = g y) -> Derive f x = Derive g x.
Proof.
move=> xge0 feqg.
rewrite /Derive /Lim.
apply/congr1/Lim_seq_ext_loc.
exists O=> n _.
rewrite !feqg // /Rbar_loc_seq Rplus_0_l.
apply: Rplus_le_le_0_compat=> //.
exact/Rlt_le/RinvN_pos.
Qed.

Section Monotonicity.

Lemma ub_finlub (A : set R) :
  A !=set0 -> (exists M, A `<=` Rlt ^~ M) ->
  exists l, is_lub_Rbar A (Finite l).
Proof.
move=> [p Ap] [M hM].
have lubAlub := Lub_Rbar_correct A.
have lubleM : Rbar_le (Lub_Rbar A) M.
  apply: (proj2 lubAlub).
  move=> q Aq /=.
  exact/Rlt_le/hM.
case: (Lub_Rbar A) lubAlub lubleM=> //; first by move=> l; exists l.
by move=> [] hA; have := hA p Ap.
Qed.

Lemma ndecr_ub_cvg (f : R -> R) :
  (forall x y, 0 <= x <= y -> f x <= f y) ->
  (exists M, f @` Rle 0 `<=` Rlt^~ M) -> [cvg f @ +oo].
Proof.
have fRn0 : f @` Rle 0 !=set0 by exists (f 0); apply/imageP/Rle_refl.
move=> fndecr /(ub_finlub fRn0) [l [ubl lubl]].
exists l=> A [eps heps].
suff [x [xge0 hx]] : exists x, 0 <= x /\ l - (f x) < eps.
  exists x=> y ltxy.
  apply: heps.
  rewrite /ball /= /AbsRing_ball abs_minus /abs /= Rabs_pos_eq -?Rminus_le_0.
    apply/(Rle_lt_trans _ _ _ _ hx)/Rplus_le_compat_l/Ropp_le_contravar.
    by apply: fndecr; split=> //; apply: Rlt_le.
  apply/ubl/imageP/Rlt_le.
  exact: Rle_lt_trans ltxy.
apply: NNPP.
move/not_ex_all_not=> hf.
have : Rbar_le l (l - eps).
  apply: lubl.
  move=> _ [x xge0 <-] /=.
  apply/Rle_minus_r.
  rewrite Rplus_comm.
  apply/Rle_minus_r/Rnot_lt_le.
  have /not_and_or /or_to_imply := hf x.
  by move=> /(_ xge0).
move/Rle_not_lt=> hleps.
apply/hleps/Rminus_lt.
rewrite /Rminus Rplus_comm -Rplus_assoc [- _ + _]Rplus_comm Rplus_opp_r
        Rplus_0_l.
by apply: Ropp_lt_gt_0_contravar; case: eps heps hf hleps.
Qed.

Lemma nincr_lb_cvg (f : R -> R) :
  (forall x y, 0 <= x <= y -> f y <= f x) ->
  (exists M, f @` Rle 0 `<=` Rlt M) -> [cvg f @ +oo].
Proof.
move=> fnincr [M MlbfR].
suff [l oppfcvl] : [cvg (fun x => - f x) @ +oo].
  exists (- l).
  apply: (filterlim_ext (fun x => - -f x)).
    by move=> x; exact: Ropp_involutive.
  by apply: filterlim_comp oppfcvl _; apply: filterlim_opp.
apply: ndecr_ub_cvg.
  move=> x y xley.
  exact/Ropp_le_contravar/fnincr.
exists (- M).
move=> _ [x xge0 <-].
apply/Ropp_lt_contravar/MlbfR.
exact: imageP.
Qed.

Lemma nincr_function_le (f : R -> R) (a b : Rbar) (df : R -> R) :
  (forall x : R, Rbar_le a x -> Rbar_le x b -> is_derive f x (df x)) ->
  (forall x : R, Rbar_le a x -> Rbar_le x b -> df x <= 0) ->
  forall x y : R, Rbar_le a x -> x <= y -> Rbar_le y b -> f y <= f x.
Proof.
move=> Df dfle0 x y alex xley yleb.
apply/Rminus_le_0.
have hbet z : Rmin y x <= z -> z <= Rmax y x -> Rbar_le a z /\ Rbar_le z b.
  move=> minlez zlemax.
  split.
    apply: Rbar_le_trans; first exact: alex.
    apply: Rle_trans minlez.
    by rewrite Rmin_right //; apply: Rle_refl.
  apply: Rbar_le_trans yleb.
  apply: Rle_trans; first exact: zlemax.
  by rewrite Rmax_left //; apply: Rle_refl.
case: (MVT_gen f y x df).
- move=> z [/Rlt_le minlez /Rlt_le zlemax].
  by apply: Df; have /hbet [] := zlemax.
- move=> z [minlez zlemax].
  apply: derivable_continuous_pt.
  exists (df z).
  by apply/is_derive_Reals/Df; have /hbet [] := zlemax.
- move=> z [[minlez zlemax] ->].
  rewrite -(Rmult_0_l (df z)) Rmult_comm.
  apply: Rmult_le_compat_neg_l.
    by apply: dfle0; have /hbet [] := zlemax.
  exact: Rle_minus.
Qed.

End Monotonicity.

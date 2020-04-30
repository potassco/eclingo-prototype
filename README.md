# eclingo
> Epistemic logic programming with `clingo`

## Description
`eclingo` contains 3 different solvers for epistemic logic programs following the semantics of these two publications:
* Michael Gelfond: Strong Introspection. AAAI 1991: 386-391
* Pedro Cabalar, Jorge Fandinno, Luis Fariñas del Cerro: Founded World Views with Autoepistemic Equilibrium Logic. LPNMR 2019: 134-147

The input to `eclingo` is a [`clingo`](https://potassco.org/clingo/) program, 
where the atoms of the predicate `k/1` have a special meaning.
The current implementation requires that there is a choice rule `{ k(A) }.`
for every atom `A` such that `k(A)` appears in the input program.
Furthermore, `k(A)` must be `#shown`, as well as the atoms `A` inside the `k`'s.

The 3 implementations are described and implemented in the files
`meta_main.lp`, `inc_meta.py`, and `egc.py` in the directory `eclingo`.
Some examples are available in the `eclingo/examples` directory.


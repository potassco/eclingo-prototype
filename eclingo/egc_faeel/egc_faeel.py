#
# Notes:
# * Usage: clingo --output=reify       files > out.tmp; python egc_faeel.py out.tmp [options]
#          clingo --output=reify example1.lp > out.tmp; python egc_faeel.py out.tmp  0 --project
# * It is more efficient if only the k(A) atoms and the As inside them are shown
# * It is more efficient projecting on the k(A) atoms
#

import sys
import clingo
import copy

GUESS_FILES = [ "main.lp", "main_guess.lp", "many.lp" ]
CHECK_FILES = [ "main.lp", "main_check.lp", "many.lp", "faeel.lp" ]

# options
files, options, max_models = [], [], 1
for i in sys.argv[1:]:
    if i[0] == "-":
        options.append(i)
    elif i.isdigit():
        max_models = i
    else:
        files.append(i)

# guess
guess = clingo.Control(options + ["0"])
for i in files:
    guess.load(i)
for i in GUESS_FILES:
    guess.load(i)
guess.ground([("base", [])])

# check
# check = copy.deepcopy(guess)?
check = clingo.Control(["0", "--enum-mode=cautious"])
for i in files:
    check.load(i)
for i in CHECK_FILES:
    check.load(i)
check.ground([("base", [])])

# gather knowledge predicates and atoms
k_preds, k_atoms = set(), []
for atom in guess.symbolic_atoms.by_signature("k", 1):
    k_preds.add((atom.symbol.arguments[0].name, len(atom.symbol.arguments[0].arguments)))
    k_atoms.append(atom.symbol)

# add to guess the constraint program for :- k(X), not X.
constraint = ""
for name, arity in k_preds:
    if arity == 0:
        atom = name
    else:
        atom = name + "(" + ",".join(["V"+str(idx) for idx in range(arity)]) + ")"
    constraint += ":- k({0}), not {0}.\n".format(atom) 
guess.add("constraint", [], constraint)
guess.ground([("constraint", [])])


# solve
models = 0
with guess.solve(yield_=True) as guess_handle:
    for guess_model in guess_handle:
        # print guess_model
        print("Guess Answer: ")
        print(" ".join([str(s) for s in guess_model.symbols(shown=True)]))
        # gather knowledge atoms true and false
        k_true, k_false = [], []
        for atom in k_atoms:
            if guess_model.contains(atom):
                k_true.append(atom)
            else:
                k_false.append(atom)
        # check guess_model
        ok, unsat = True, True
        a = [(k, True) for k in k_true] + [(k, False) for k in k_false]
        with check.solve(yield_=True, assumptions=a) as check_handle:
            for check_model in check_handle:
                unsat = False
                # print check_model
                print("Check Answer: ")
                print(" ".join([str(s) for s in check_model.symbols(shown=True)]))
                # check true knowledge atoms
                for atom in k_true:
                    if not check_model.contains(atom.arguments[0]):
                        ok = False
                        break
                if not ok:
                    break
            if ok and not unsat:
                # check false knowledge atoms
                for atom in k_false:
                    if check_model.contains(atom.arguments[0]):
                        ok = False
                        break
        if ok and not unsat:
            models += 1
            print("* Answer {}: ".format(models))
            print(" ".join([str(s) for s in guess_model.symbols(shown=True)]))
            if models == max_models:
                break

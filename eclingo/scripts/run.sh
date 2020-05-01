#
# Usage:
#   run.sh system files -- options
#
# Examples:
#   run.sh --meta           examples/example0.lp -- --project 0
#   run.sh --meta-faeel     examples/example0.lp -- --project 0
#   run.sh --inc-meta       examples/example0.lp
#   run.sh --inc-meta-faeel examples/example0.lp
#   run.sh --egc            examples/example0.lp -- --project 0
#   run.sh --egc-faeel      examples/example0.lp -- --project 0
#

META="--meta"
METAF="--meta-faeel"
INC_META="--inc-meta"
INC_METAF="--inc-meta-faeel"
EGC="--egc"
EGCF="--egc-faeel"

system=$1
shift

files=""
options=""
in_files=true
for i in $@; do
  if [ $i = "--" ]; then
    in_files=false
  elif [ $in_files = true ]; then
    files="${files} $i"
  else
    options="${options} $i"
  fi
done

if [ $system = $META ]; then
  clingo --output=reify --reify-sccs $files | \
  clingo -Wno-atom-undefined - meta_main.lp ktuple.lp meta_many.lp \
         metaD.lp $options
elif [ $system = $METAF ]; then
  clingo --output=reify --reify-sccs $files | \
  clingo -Wno-atom-undefined - meta_main.lp ktuple.lp meta_many.lp \
         metaD.lp level.lp meta_faeel.lp $options
elif [ $system = $INC_META ]; then
  clingo-banane --output=reify --reify-sccs $files | \
  clingo-banane -Wno-atom-undefined - inc_meta.py meta_main.lp \
    ktuple.lp metaD.lp $options
elif [ $system = $INC_METAF ]; then
  clingo-banane --output=reify --reify-sccs $files | \
  clingo-banane -Wno-atom-undefined - inc_meta.py meta_main.lp \
    ktuple.lp metaD.lp level.lp meta_faeel.lp $options
elif [ $system = $EGC ]; then
  python egc.py $files $options
elif [ $system = $EGCF ]; then
  clingo --output=reify $files > out.tmp; python egc.py out.tmp --faeel $options
fi


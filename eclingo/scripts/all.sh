#
# Usage:
#   all.sh examples/example0.lp
#

echo "###########################################"
echo "run.sh --meta           $@ -- --project 0"
run.sh --meta           $@ -- --project 0
echo "###########################################"
echo

echo "###########################################"
echo "run.sh --meta-faeel     $@ -- --project 0"
run.sh --meta-faeel     $@ -- --project 0
echo "###########################################"
echo

echo "###########################################"
echo "run.sh --inc-meta       $@"
run.sh --inc-meta       $@
echo "###########################################"
echo

echo "###########################################"
echo "run.sh --inc-meta-faeel $@"
run.sh --inc-meta-faeel $@
echo "###########################################"
echo

echo "###########################################"
echo "run.sh --egc            $@ -- --project 0"
run.sh --egc            $@ -- --project 0
echo "###########################################"
echo

echo "###########################################"
echo "run.sh --egc-faeel      $@ -- --project 0"
run.sh --egc-faeel      $@ -- --project 0
echo "###########################################"
echo

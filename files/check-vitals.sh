#!/bin/bash

################################################################################
# Config

MIN_CPU_FREQ_MHZ=400

################################################################################
# Common stuff

NUM_CPUS=$(grep -c ^processor /proc/cpuinfo)

EXIT_CODE=0
alert() {
  echo -n " ALERT"
  EXIT_CODE=1
}

################################################################################
# CPU Frequency
echo "Checking CPU Frequency..."

read -r -a CPU_FREQ <<< "$(
  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq \
    | tr "\n" " "
)"

for i in $(eval echo "{0..$((NUM_CPUS - 1))}"); do
  CPU_FREQ_IN_MHZ=$((${CPU_FREQ[$i]} / 1000))
  echo -n "CPU$i: $CPU_FREQ_IN_MHZ MHz"
  [ $CPU_FREQ_IN_MHZ -lt $MIN_CPU_FREQ_MHZ ] && alert
  echo ""
done
echo ""

echo "Exiting with code $EXIT_CODE"
exit $EXIT_CODE

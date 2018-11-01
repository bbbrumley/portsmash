#!/bin/bash

echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

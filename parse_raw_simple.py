#!/usr/bin/env python

import sys
import array
import warnings
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt

# tweakable parameter: signal clipping
CEIL = 511

def normalize(x):
    if x > CEIL: x = CEIL
    if x < 0: x = CEIL
    return x

def running_mean(x, N):
    cumsum = np.cumsum(np.insert(x, 0, 0)) 
    return (cumsum[N:] - cumsum[:-N]) / N

try:
    fp = open(sys.argv[1])
except:
    print "Usage: python %s <timings.bin>" % (sys.argv[0])
    sys.exit(1)

out = fp.read()
fp.close()

timings = array.array('I')
timings.fromstring(out)

lats = []

for i in range(0,len(timings),2):
    lats.append(timings[i+1]-timings[i])

lats = map(normalize, lats)
ma2 = running_mean(lats, 2)
ma4 = running_mean(lats, 4)
# (9,3) are tweakable parameters
ma8 = signal.savgol_filter(lats,9,3)

params = {'fillstyle':'full','markeredgewidth':0.0,'ms':4.0}
f, axarr = plt.subplots(4, sharex=True, sharey=True)
# plot the trace
axarr[0].plot(lats,**params)
# plot the filtered traces
axarr[1].plot(ma2,**params)
axarr[2].plot(ma4,**params)
axarr[3].plot(ma8,**params)
# try to plot the peaks
try:
    # (240,90) are tweakable parameters
    PEAK_MPH = 240
    PEAK_MPD = 90
    peaks, properties = signal.find_peaks(ma4, height=PEAK_MPH, distance=PEAK_MPD)
    axarr[2].scatter(peaks, [ma4[p] for p in peaks], color='red')
    peaks, properties = signal.find_peaks(ma8, height=PEAK_MPH, distance=PEAK_MPD)
    axarr[3].scatter(peaks, [ma8[p] for p in peaks], color='red')
except:
    warnings.warn("scipy.signal.find_peaks not found: Consult README.md")

plt.get_current_fig_manager().full_screen_toggle()
plt.show()


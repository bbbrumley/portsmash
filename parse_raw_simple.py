import sys
import array
import numpy as np
import matplotlib.pyplot as plt

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
ma8 = running_mean(lats, 8)

params = {'fillstyle':'full','markeredgewidth':0.0,'ms':4.0}
f, axarr = plt.subplots(4, sharex=True, sharey=True)
# plot the trace
axarr[0].plot(lats,**params)
# plot the moving average trade
axarr[1].plot(ma2,**params)
axarr[2].plot(ma4,**params)
axarr[3].plot(ma8,**params)

plt.get_current_fig_manager().full_screen_toggle()
plt.show()

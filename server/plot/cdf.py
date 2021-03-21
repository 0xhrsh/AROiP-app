import glob
import scipy
from matplotlib import pyplot
import numpy
import seaborn as sns
from numpy import hstack
from statsmodels.distributions.empirical_distribution import ECDF

path = 'data_udp/50/latencyViewer*'
files=glob.glob(path)   
total = 0
n = 0
fn = 0
ve = 0


sample = []
# print(files) 
for file in files:     
    f=open(file, 'r')  
    lines = f.readlines()   
    for line in lines:
        try:
            if(float(line)>10 or float(line) < 0.00000001 ):
                print("bad line:", line)
                # print(line)
                # input()
            else:
                total += float(line)
                n += 1
                sample.append(float(line)*1000)
        except ValueError:
            ve += 1
    f.close() 
    fn += 1
    # ecdf = scipy.stats.norm.cdf(sample)
    print(float(fn)*100.0/float(len(files)))
    # print(n)/
# sample.sort()
ecdf = ECDF(sample)
pyplot.plot(ecdf.x,ecdf.y)
pyplot.xlabel("Latency (ms)")
pyplot.title("50 Clients")
pyplot.xlim(0,300)
pyplot.ylabel("Cumulative Probability")
# pyplot.show()
pyplot.savefig('UDP_50.png')
print(ve)
print(n)
print(total*1000/n)
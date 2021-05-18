import glob   
import matplotlib.pyplot as plt


path = 'graph/data_{}/{}/latencyViewer*'

delays = ['10', '20', '50', '100', '150', '200']


udp = []
tcp = []
x = []
methods = ['tcp', 'udp']

for method in methods:
    for delay in delays:
        files=glob.glob(path.format(method, delay))   
        total = 0
        n = 0
        fn = 0
        ve = 0

        for file in files:     
            f=open(file, 'r')  
            lines = f.readlines()   
            for line in lines:
                try:
                    if(float(line)>10):
                        print("bad line:", line)
                        # print(line)
                        input()
                    else:
                        total += float(line)
                        n += 1
                except ValueError:
                    ve += 1
            f.close() 
            fn += 1
            # print(float(fn)*100.0/float(len(files)))
        # print(n)/
        # print(ve)
        # print(n)
        print(total*1000/n)
        if(method == 'udp'):
            udp.append(total*1000/n)
        else:
            tcp.append(total*1000/n)
            x.append(delay)

# print(avgs)
# print(x)
plt.title("Impact of update frequency on average latency (100 clients)")
plt.xlabel("Delay between updates (ms)")
plt.ylabel("Average Latency (ms)")

plt.plot(x, udp, label = "UDP")
plt.plot(x, tcp, label = "TCP")
plt.legend()
plt.savefig("output.jpg")

import glob   
path = 'data/latencyViewerTCP*'
files=glob.glob(path)   
total = 0
n = 0
fn = 0
ve = 0
# print(files) 
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
    print(float(fn)*100.0/float(len(files)))
    # print(n)/
print(ve)
print(n)
print(total*1000/n)
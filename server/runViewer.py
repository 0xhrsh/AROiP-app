import threading
# import viewerUDP as v
import viewerTCP as v

num = 100
for x in range(num):
    
    t = threading.Thread(target=v.run, args=([num]), daemon=True) 
    t.start()
    print("thread started", x)

x = input()


    
    
    

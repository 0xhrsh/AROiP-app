import threading
import viewerUDP as v

num = 40
for x in range(num):
    
    t = threading.Thread(target=v.run, args=([num]), daemon=True) 
    t.start()
    print("thread started", x)

x = input()


    
    
    
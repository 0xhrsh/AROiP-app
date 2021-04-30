import threading
import viewerUDP as v

for x in range(400):
    
    t = threading.Thread(target=v.run, args=(), daemon=True) 
    t.start()
    print("thread started", x)

x = input()


    
    
    
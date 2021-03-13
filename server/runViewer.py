import threading
import viewerTCP as v

for x in range(50):
    
    t = threading.Thread(target=v.run, args=(), daemon=True) 
    t.start()
    print("thread started", x)

x = input()


    
    
    
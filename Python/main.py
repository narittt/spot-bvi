from estop_nogui import EstopNoGui
from movement import Movement
import time 
import socket
import os 
import subprocess
import sys

#create socket 
sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

#Host IP: Put the server's IP here
udp_host = "192.168.80.100"	

#Port to connect to 
udp_port = 12345			                

#bind socket
sock.bind((udp_host,udp_port))

#create Spot object
spot = Movement("user", "vd87k7o35nrs", "192.168.80.3")


while True:
    print ("Waiting for instructions...")
    #receive data from client
    data, addr = sock.recvfrom(1024)	        
    data = data.decode()
    print ("Received Command: ", data," from iPhone with IP address: ",addr)
    if data == "launch": 
        spot.auth()
        print("authenticated")
        spot.toggle_power()
        print("powered on")
        spot.stand()
        print("standing")
    elif data == "forward":
        spot.move_forward()
        print("forward")
    elif data == "backwards":
        spot.move_backward()
    elif data == "sit":
        spot.sit()
    elif data == "left":
        spot.turn_left()
    elif data == "right":
        spot.turn_right()
    elif data == "off":
        spot.sit()
        spot.toggle_power()
        spot.toggle_estop()
        spot.toggle_lease()
    else:
        print("Received sample data from iPhone!")
    
        


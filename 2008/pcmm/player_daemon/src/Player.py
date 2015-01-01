# Player
# Uses utilities: flac, aplay, mpg123
# Player runs in its own thread
#
# Raivo Laanemets, rlaanemt@ut.ee, 05.01.2007

import logging
import random
import subprocess
import sys
import threading
import time

player_log = logging.getLogger("Player")

class PlayerException(Exception): pass

class Mp3Player:
    
    def __init__(self, song):
        self.song = song
        
    def play(self):
        self.mpg123 = subprocess.Popen(["mpg123", self.song])
        self.mpg123.wait()
        
    def stop(self):
        kill = subprocess.Popen(["kill", str(self.mpg123.pid)])
        kill.wait()

class FlacPlayer:
    
    def __init__(self, song):
        self.song = song
        
    def play(self):
        self.flac = subprocess.Popen(["flac", "-s", "-d", "-c", self.song], stdout=subprocess.PIPE)
        self.aplay = subprocess.Popen(["aplay", "-q"], stdin=self.flac.stdout)
        self.flac.wait()
        self.aplay.wait()
        
    def stop(self):
        kill1 = subprocess.Popen(["kill", str(self.flac.pid)])
        kill2 = subprocess.Popen(["kill", str(self.aplay.pid)])
        kill1.wait()
        kill2.wait() 
        

class ListPlayer(threading.Thread):
    
    def __init__(self, playlist):
        threading.Thread.__init__(self)
        self.playlist = playlist
        self.running = 0
        self.random = 0
        self.position = 0
        player_log.debug("initialized")
    
    def run(self):
        logging.debug("started")
        if (len(self.playlist) == 0):
            raise PlayerException("The playlist is empty!")
        self.running = 1
        while(self.running):
            if (self.random == 0):
                if (self.position >= len(self.playlist)):
                    self. position = 0
                self.play(self.playlist[self.position])
                self.position += 1
            else:
                i = random.randint(0, len(self.playlist)-1)
                self.position = i
                self.play(self.playlist[i])
        
    def play(self, song):
        if (song.type == "flac"):
            self.player = FlacPlayer(song.url)
            self.player.play()
        elif (song.type == "mp3"):
            self.player = Mp3Player(song.url)
            self.player.play()
        
    def current_item(self):
        return self.player.song
    
    def next(self):
        self.player.stop()
        
    def stop(self):
        if (self.running == 1):
            self.running = 0
            self.player.stop()
            
    def random_on(self):
        self.random = 1
        
    def random_off(self):
        self.random = 0
        
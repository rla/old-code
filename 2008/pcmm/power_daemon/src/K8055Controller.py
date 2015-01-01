import sys
import subprocess
import os

class K8055Controller:
    def __init__(self):
        self.reset()
        
    def do_command(self):
        sum = 0
        exp = 0
        for i in self.digital:
            sum += i * (2 ** exp)
            exp += 1
        command = 'k8055 -A1:%d -A2:%d -D:%d' % (self.analog1, self.analog2, sum)
        os.system(command)
            
    def reset(self):
        self.digital = [0, 0, 0, 0, 0, 0, 0, 0]
        self.analog1 = 0
        self.analog2 = 0
        self.do_command()
        
    def turn_on(self, i):
        self.digital[i-1] = 1
        self.do_command()
        
    def turn_off(self, i):
        self.digital[i-1] = 0
        self.do_command()
        
    def set_analog1(self, level):
        self.analog1 = level
        self.do_command()
        
    def set_analog2(self, level):
        self.analog2 = level
        self.do_command()
        
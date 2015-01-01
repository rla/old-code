import SimpleXMLRPCServer
import sys

import logging
from Player import ListPlayer
from PlaylistDAO import PlaylistDAO

logging.basicConfig()

controller_log = logging.getLogger("Controller")

# TODO:
#
# Server shutdown does not work yet.

class Controller:
    def __init__(self):
        self.playlistDAO = PlaylistDAO()
        self.player = ListPlayer(self.playlistDAO.currentPlaylist())
        controller_log.debug("initialized")
        
    def reload(self):
        logging.debug("fetching playlist")
        self.stop()
        self.player = ListPlayer(self.playlistDAO.currentPlaylist())
        return 0
    
    def shutdown(self):
        logging.debug("shutting down")
        raise SystemExit
        
    def next(self):
        logging.debug("next")
        self.player.next()
        return 0
        
    def previous(self):
        logging.debug("previous")
        
    def stop(self):
        logging.debug("stopping")
        self.player.stop()
        
    def play(self):
        try:
            logging.debug("starting playing")
            self.stop()
            self.player.start()
        except:
            return 1
        else:
            return 0
        
    def next10(self):
        logging.debug("next10")
        
    def previous10(self):
        logging.debug("previous10")
        
    def random_play_on(self):
        self.player.random_on()
        logging.debug("random play on")
        return 0
        
    def random_play_off(self):
        self.player.random_off()
        logging.debug("random play off")
        return 0     

controller = Controller()        
server = SimpleXMLRPCServer.SimpleXMLRPCServer(("d6349.mysql.zone.ee", 9000))
server.register_instance(controller)
server.serve_forever()
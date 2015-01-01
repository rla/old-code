# Playlisti elementi esindav klass
# Raivo Laanemets, rlaanemt@ut.ee, 05.01.2007

class PlaylistItem:
    
    def __init__(self, url, type = "flac"):
        self.url = url
        self.type = type
        
    def toString(self):
        return self.url

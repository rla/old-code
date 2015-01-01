# PlaylistDAO
# Vastutab hetke listi laadimise eest andmebaasist.
# Raivo Laanemets, rlaanemt@ut.ee, 05.01.2007

import logging
from playlist_item import PlaylistItem
import MySQLdb

playlist_dao_log = logging.getLogger("PlaylistDAO")

class PlaylistDAO:
    
    def __init__(self):
        self.db = MySQLdb.connect(
                                  host = "d6349.mysql.zone.ee",
                                  user = "root",
                                  passwd = "",
                                  db = "openfts_frontend"
                                  )
        playlist_dao_log.debug("initialized")
        
    def currentPlaylist(self):
        cursor = self.db.cursor()
        cursor.execute("SELECT url, type FROM current_playlist")
        result = cursor.fetchall()
        list = []
        for row in result:
            item = PlaylistItem(row[0], row[1])
            list.append(item)
        playlist_dao_log.debug("got ", len(list), " items")
        return list
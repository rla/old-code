/** <module> Describes WebMp3 domain objects.
@author Raivo Laanemets, rlaanemt@ut.ee, 12.11.06
*/

:-module(domain, [
	entity/2
]).

entity(playlist, [
	(id, int),
	(name, int)
]).

entity(stream, [
	(id, int),
	(name, char),
	(url, char)
]).
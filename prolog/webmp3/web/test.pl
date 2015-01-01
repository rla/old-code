/** <module> The test module for the Prolog web server.
@author Raivo Laanemets, rlaanemt@ut.ee, 12.11.06
*/

:-module(web_test, [
	echo/1
]).

:-use_module(templates).

echo(_):-
	writeln('Tere6').


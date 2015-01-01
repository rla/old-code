#include <stdlib.h>

#define Network struct t_network
#define NodeList struct t_nodelist

NodeList {
	Node *node;
	NodeList *next;
};

Network {
	NodeList *nodes;
	Node *output;
	NodeList *inputs;
};

/*
Tippude listile uue tipu lisamine.
Lisatakse listi peaks, tagastatakse saadud uus list.
*/
NodeList *add_node(NodeList *nodes, Node *node) {
	NodeList *newNodeList = malloc(sizeof(NodeList));
	newNodeList -> next = nodes;
	newNodeList -> node = node;
	return newNodeList;
}

/*
Tippude listi elementide lugemine.
*/
int count_nodes(NodeList *nodes) {
	int count = 0;
	NodeList *current = nodes;
	while (current != NULL) {
		count++;
		current = current -> next;
	}
	return count-1;
}

/*
Seoste arvu lugemine.
*/
int count_relations(NodeList *nodes) {
	int count = 0;
	NodeList *current = nodes;
	Subnode *subnode;
	Node *node;
	while (current != NULL) {
		node = current -> node;
		if (node == NULL) break;
		subnode = node -> subnode;
		while (subnode != NULL) {
			count++;
			subnode = subnode -> next;
		}
		current = current -> next;
	}
	return count;
}

/*
Uue tippude listi loomine.
*/
NodeList *new_nodelist() {
	NodeList *nodeList = malloc(sizeof(NodeList));
	nodeList -> next = NULL;
	nodeList -> node = NULL;
	return nodeList;
}

/*
Uue tipu loomine.
*/
Node *new_node() {
	Node *node = malloc(sizeof(Node));
	node -> subnode = NULL;
	return node;
}

/*
Tipule alamtipu lisamine.
*/
void add_subnode(Node *node, Node *sub, float weight) {
	Subnode *subnode = malloc(sizeof(Subnode));
	subnode -> node = sub;
	subnode -> weight = weight;
	subnode -> next = node -> subnode;
	node -> subnode = subnode;
}

/*
Võrgu kasvatamine ühe sisendite kihi võrra.
*/
void grow(Network *network) {
	NodeList *newInputs = new_nodelist();
	Node *node;
	Node *input1;
	Node *input2;
	NodeList *nodes;
	
	int inputCount = count_nodes(network -> inputs);
	int i = 0;
	for (i = 0; i < inputCount; i++) {
		input1 = new_node();
		input2 = new_node();
		newInputs = add_node(newInputs, input1);
		newInputs = add_node(newInputs, input2);
		//lisame igale teisele tipule alluvaks
		nodes = network -> nodes;
		while (nodes != NULL) {
			node = nodes -> node;
			if (node == NULL) break;
			add_subnode(node, input1, 0.0);
			add_subnode(node, input2, 0.0);
			nodes = nodes -> next;
		}
	}
	//lisame juurde tulnud sisendtipud tippude hulka
	NodeList *currentInput = newInputs;
	while (currentInput != NULL) {
		node = currentInput -> node;
		if (node == NULL) break;
		network -> nodes = add_node(network -> nodes, node);
		currentInput = currentInput -> next;
	}
	//määrame võrgu sisenditeks uued sisendid
	NodeList *temp = network -> inputs;
	network -> inputs = newInputs;
	//vabastame eelmiste sisendite alt mälu (kaduma
	//läheb lististruktuur, aga mitte sellega seotud võrgutipud).
	while (temp != NULL) {
		nodes = temp -> next;
		free(temp);
		temp = nodes;
	}
}

/*
Uue neurovõrgu loomine.
*/
Network *new_network() {
	Network *network = malloc(sizeof(Network));
	
	//Kõikide tippude list
	NodeList *nodes = new_nodelist();
	
	//Sisendtippude list.
	NodeList *inputs = new_nodelist();
	
	//Väljundtipp
	Node *output = new_node();

	nodes = add_node(nodes, output);
	
	//Kaks sisendtippu, väljundtipu alamtipud.
	Node *input1 = new_node();
	Node *input2 = new_node();
	add_subnode(output, input1, 0.0);
	add_subnode(output, input2, 0.0);
	nodes = add_node(nodes, input1);
	nodes = add_node(nodes, input2);
	inputs = add_node(inputs, input1);
	inputs = add_node(inputs, input2);
	
	network -> inputs = inputs;
	network -> output = output;
	network -> nodes = nodes;
	
	return network;
}



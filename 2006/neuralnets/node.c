#define Node struct t_node
#define Subnode struct t_subnode

Subnode {
	Subnode *next; //ahelas järgmine
	float weight;  //kaare kaal
	Node *node;    //tipp, milleni viitab
};

Node {
	Subnode *subnode; //alamtippude ahel
};

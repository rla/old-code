#include <stdlib.h>
#include <string.h>

#define TOKEN struct t_token
#define MAX_WORD_LENGTH 10
#define MIN_WORD_LENGTH 3

char characters[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'z'};
int char_count = sizeof(characters);

int is_char(char ch) {
	int i;
	for (i = 0; i < char_count; i++) {
		if (ch == characters[i]) {
			return 1;
		}
	}
	return 0;
}

TOKEN {
	char *word;
	TOKEN *next;
};

TOKEN *new_token() {
	TOKEN *token = malloc(sizeof(TOKEN));
	token -> next = NULL;
	return token;
}

TOKEN *token_append(TOKEN *tail, char *word) {
	TOKEN *head = new_token();
	head -> next = tail;
	head -> word = word;
	return head;
}

TOKEN *tokenize_text(char *text) {
	char buffer[MAX_WORD_LENGTH];
	int i;
	int l = strlen(text);
	int b = 0;
	int discard = 0;
	int j;
	TOKEN *tokens = NULL;
	for (i = 0; i <= l; i++) {
		if (is_char(text[i])) {
			buffer[b] = text[i];
			b++;
			if (b == MAX_WORD_LENGTH) {
				b = 0;
				discard = 1;
			}
		} else {
			if (discard == 1) {
				b = 0;
				discard = 0;
			} else {
				if (b >= MIN_WORD_LENGTH) {
					char *word = malloc(b+1);
						for (j = 0; j < b; j++) {
							word[j] = buffer[j];
						}
						word[b] = '\0';
					tokens = token_append(tokens, word);
				}
				b = 0;
			}
		}
	}
	return tokens;
}

void debug_enumerate_tokens(TOKEN *tokens) {
	while (tokens != NULL) {
		printf("%s\n", tokens -> word);
		tokens = tokens -> next;
	}
}

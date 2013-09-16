#ifndef DELIMITER_BRACKETED_STRINGS_H_
#define DELIMITER_BRACKETED_STRINGS_H_

#include "stdint.h"
#include "token_node.h"

typedef enum bracket_delimiter_type {
 	OPEN_BRACKETS = 0, CLOSED_BRACKETS, CLOSED_BRACKETS_NOT_RBRACK_RBRACK, CLOSED_BRACKETS_IN_STRING, CLOSED_BRACKETS_IN_SINGLECOMMENT, END_DOUBLE_LIST_NEWLINE, END_DOUBLE_LIST, ERROR_STRING_CHAR_MAX
} bracket_delimiter_type;

typedef union delim_type {
		gr_token token;
		int32_t comment;	/*The value for each type of comment is:
							Singleline comment -- has value 0
							Starting multiline comment with n symbols '=' has value n+1
							Ending multiline comment with n symbols '=' has value -n-1*/
		bracket_delimiter_type bracket_delimiter;
	} delimiter_type;

typedef struct delimiter {
  /*token delimiters: LBRACE, RBRACE, EQ, SEMI, FUNCTION
  comment delimiters: SINGLECOMMENT --, LMULTICOMMENT --[=*[, RMULTICOMMENT ]=*]\n
  bracketed strings delimiters:	OPEN_BRACKETS [[, CLOSED_BRACKETS ]], CLOSED_BRACKETS_NOT_RBRACK_RBRACK, CLOSED_BRACKETS_IN_STRING, CLOSED_BRACKETS_IN_SINGLECOMMENT, END_DOUBLE_LIST_NEWLINE, END_DOUBLE_LIST, ERROR_STRING_CHAR_MAX */
	delimiter_type type;
	int8_t type_class; 			/*0 if the union field is a token; 1 if it is a comment, 2 if it is a bracket_delimiter*/
	uint32_t number_tokens_from_last_comment_string[2];
	token_node *last_token[2]; /*Token within the token list 0 and the token list 1 which corresponds to the delimiter in the paired delimiter list: 
								if the delimiter is a comment, last_token is the last token in the token list preceding the occurrence of the comment delimiter in the code.*/
	uint8_t error[2];
	struct delimiter* next[2]; /*Next delimiter in the delimiter list 0 and in the delimiter list 1*/
} delimiter;


delimiter *new_delimiter(delimiter_type type, int8_t type_class);

#endif
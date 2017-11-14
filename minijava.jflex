/*
* A primeira se??o da especifica??o vai at? o primeiro %%,
* e consiste de c?digo Java que ? copiado ao p? da letra
*
*/
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;

%%

/*
* A segunda se??o vai at? o pr?ximo %%, e s?o diversos par?metros
* de configura??o, al?m de c?digo Java copiado para o corpo da
* classe do analisador l?xico
*
*/

%class Scanner          // nome da classe do analisador
%public                 // classe deve ser p?blica
%line                   // guarde n?mero da linha em yyline
%column                 // guarde n?mero da coluna em yycolumn
%function nextToken     // nome do m?todo que vai fornecer um token
%type Token             // classe usado para tokens

// C?digo Java entre %{ e %} ? copiado pro corpo da classe
// do analisador
%{

	public Scanner() { }

	public void input(String input) {
	    // inicializa entrada pro analisador
		yyreset(new StringReader(input));
	}

	public List<Token> tokens() throws IOException {
		List<Token> tokens = new ArrayList<Token>();
		Token tok = nextToken();
		while(tok.getTipo() != Token.EOF) {
			tokens.add(tok);
			tok = nextToken();
		}
		tokens.add(tok);
		return tokens;
	}

%}

%%

/*
* A ?ltima se??o cont?m as regras l?xicas, cada regra ? um
* par com uma express?o regular e um trecho de c?digo Java
* entre { e }.
*
*/

/*========= Padr?es Utilizados ===========*/
word = [a-zA-Z]
digit = [0-9]
NUM = 0|[1-9][0-9]*
ID = [a-zA-Z_][a-zA-Z0-9_]*

/*======== Coment?rios ==============*/

//Pelo regex, esse de baixo funcionou, mas ? t?o complexo que eu to na d?vida
// general_coment = \/\*[\s\S]*?\*\/|([^\\:]|^)\/\/.*$

//Aparentemente usando o site de regex esse de baixo funciona para /*qualquer coisa escrita*/
block_coment = \/\*(\*(?!\/)|[^*])*\*\/


// Espa?os s?o ignorados
// EOL -> de acordo com o doc no drive. Possivelmente a mesma coisa
[ \r\n\t\f]    { }

//Express?es em geral, ser?o modificadas ainda

/*Palavras reservadas para linguagem*/
"return"      		{ return new Token(Token.RETURN, yytext(), yyline, yycolumn); }
"this"      		{ return new Token(Token.THIS, yytext(), yyline, yycolumn); }
"class"		    	{ return new Token (Token.CLASS, yytext(), yyline, yycolumn); }
"public"			{ return new Token (Token.PUBLIC, yytext(), yyline, yycolumn); }
"static"      		{ return new Token(Token.STATIC, yytext(), yyline, yycolumn); }
"void"		    	{ return new Token (Token.VOID, yytext(), yyline, yycolumn); }
"main"		    	{ return new Token (Token.MAIN, yytext(), yyline, yycolumn); }
"extends"      		{ return new Token(Token.EXTENDS, yytext(), yyline, yycolumn); }
"new"			    { return new Token (Token.NEW, yytext(), yyline, yycolumn); }
"length"			{ return new Token (Token.LENGTH, yytext(), yyline, yycolumn); }
"System.Out.Println"	{ return new Token (Token.PRINTLN, yytext(), yyline, yycolumn); }

/*Tipo dos dados*/
"boolean"      		{ return new Token(Token.BOOLEAN, yytext(), yyline, yycolumn); }
"int"			{ return new Token (Token.INT, yytext(), yyline, yycolumn); }
"string"			{ return new Token (Token.STRING, yytext(), yyline, yycolumn); }

/*Operadores*/
"if"			{ return new Token (Token.IF, yytext(), yyline, yycolumn); }
"else"			{ return new Token (Token.ELSE, yytext(), yyline, yycolumn); }
"while"			{ return new Token (Token.WHILE, yytext(), yyline, yycolumn); }

/*Valores booleanos*/
"true"			{ return new Token (Token.TRUE, yytext(), yyline, yycolumn); }
"false"			{ return new Token (Token.FALSE, yytext(), yyline, yycolumn); }

/*Tipos de identificadores*/
{ID}			{ return new Token(Token.ID, yytext(), yyline, yycolumn); }
{NUM}			{ return new Token(Token.NUM, yytext(), yyline, yycolumn); }

/*Espacos em branco e comentarios*/
{BRANCO}+		{ /*ignorar espa?os em branco*/ }
{COMENTARIO}		{ /*ignorar comentarios*/ }

/*Operadores*/
"+"    		  	{ return new Token(Token.PLUS, yytext(), yyline, yycolumn); }
"-"		    	{ return new Token (Token.MINUS, yytext(), yyline, yycolumn); }
"="		    	{ return new Token (Token.EQ, yytext(), yyline, yycolumn); }
"!"    		  	{ return new Token(Token.NOT, yytext(), yyline, yycolumn); }
"*"		    	{ return new Token (Token.MULT, yytext(), yyline, yycolumn); }
"&&"			{ return new Token (Token.AND, yytext(), yyline, yycolumn); }
"<"    		  	{ return new Token(Token.LT, yytext(), yyline, yycolumn); } // LT -less than

/*Separadores*/
"("      			{ return new Token(Token.LPAREN, yytext(), yyline, yycolumn); }
")"		          	{ return new Token (Token.RPAREN, yytext(), yyline, yycolumn); }
";"		    	    { return new Token (Token.SEMICOLON, yytext(), yyline, yycolumn); }
","     		 	{ return new Token(Token.COMMA, yytext(), yyline, yycolumn); }
"."			        { return new Token (Token.DOT, yytext(), yyline, yycolumn); }
"{"			        { return new Token (Token.LBRACE, yytext(), yyline, yycolumn); }
"}"      			{ return new Token(Token.RBRACE, yytext(), yyline, yycolumn); }
"["		        	{ return new Token (Token.LBRACK, yytext(), yyline, yycolumn); }
"]"		        	{ return new Token (Token.RBRACK, yytext(), yyline, yycolumn); }


// Identificadores e numerais devem ser retornados com
// return new Token(Token.ID, yytext(), yyline, yycolumn)
// e return new Token(Token.NUM, yytext(), yyline, yycolumn)

// Regra para EOF
<<EOF>>      { return new Token(Token.EOF, "<<EOF>>", yyline, yycolumn); }

// Erros l?xicos
.            { throw new RuntimeException("erro l?xico, linha: " +
               (yyline+1) + ", coluna : " + (yycolumn+1) + ", char: " +
               yytext()); }

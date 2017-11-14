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
"null"			    { return new Token (Token.NULL, yytext(), yyline, yycolumn); }
"System.out.println"	{ return new Token (Token.PRINTLN, yytext(), yyline, yycolumn); }

/*Tipo dos dados*/
"boolean"      		{ return new Token(Token.BOOLEAN, yytext(), yyline, yycolumn); }
"int"			    { return new Token (Token.INT, yytext(), yyline, yycolumn); }
"String"			{ return new Token (Token.STRING, yytext(), yyline, yycolumn); }

/*Operadores*/
"if"			{ return new Token (Token.IF, yytext(), yyline, yycolumn); }
"else"			{ return new Token (Token.ELSE, yytext(), yyline, yycolumn); }
"while"			{ return new Token (Token.WHILE, yytext(), yyline, yycolumn); }

/*Valores booleanos*/
"true"			{ return new Token (Token.TRUE, yytext(), yyline, yycolumn); }
"false"			{ return new Token (Token.FALSE, yytext(), yyline, yycolumn); }

/*Tipos de identificadores*/
[a-zA-Z][a-zA-Z0-9_]*			{ return new Token(Token.ID, yytext(), yyline, yycolumn); }
[0-9]+			        { return new Token(Token.NUM, yytext(), yyline, yycolumn); }

/*Espacos em branco e comentarios*/
\/\*(.|[\r\n])*?\*\/	{ /*ignorar comentarios bloco*/ }
\/\/[^\r\n]*		{ /*ignorar comentarios //*/ }


/*Operadores*/
"+"    		  	{ return new Token('+', yytext(), yyline, yycolumn); }
"-"		    	{ return new Token ('-', yytext(), yyline, yycolumn); }
"="		    	{ return new Token ('=', yytext(), yyline, yycolumn); }
"=="		    { return new Token (Token.EQ, yytext(), yyline, yycolumn); }
"!="		    { return new Token (Token.NEQ, yytext(), yyline, yycolumn); }
"!"    		  	{ return new Token('!', yytext(), yyline, yycolumn); }
"*"		    	{ return new Token ('*', yytext(), yyline, yycolumn); }
"&&"			{ return new Token (Token.AND, yytext(), yyline, yycolumn); }
"<"    		  	{ return new Token('<', yytext(), yyline, yycolumn); }

/*Separadores*/
"("      			{ return new Token('(', yytext(), yyline, yycolumn); }
")"		          	{ return new Token (')', yytext(), yyline, yycolumn); }
";"		    	    { return new Token (';', yytext(), yyline, yycolumn); }
","     		 	{ return new Token(',', yytext(), yyline, yycolumn); }
"."			        { return new Token ('.', yytext(), yyline, yycolumn); }
"{"			        { return new Token ('{', yytext(), yyline, yycolumn); }
"}"      			{ return new Token('}', yytext(), yyline, yycolumn); }
"["		        	{ return new Token ('[', yytext(), yyline, yycolumn); }
"]"		        	{ return new Token (']', yytext(), yyline, yycolumn); }


// Identificadores e numerais devem ser retornados com
// return new Token(Token.ID, yytext(), yyline, yycolumn)
// e return new Token(Token.NUM, yytext(), yyline, yycolumn)

// Regra para EOF
<<EOF>>      { return new Token(Token.EOF, "<<EOF>>", yyline, yycolumn); }

// Erros l?xicos
.            { throw new RuntimeException("erro lexico, linha: " +
               (yyline+1) + ", coluna : " + (yycolumn+1) + ", char: " +
               yytext()); }

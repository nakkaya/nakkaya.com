#+title: A micro-manual for LISP Implemented in C
#+tags: lisp c
#+TAGS: noexport(e)
#+EXPORT_EXCLUDE_TAGS: noexport

Recently I had to go through some code that uses the [[http://www.sics.se/~adam/uip/index.php/Main_Page][uIP]] TCP/IP stack,
which reminded me, it has been a long time since I did something in C
so I ended up spending the weekend implementing the 10 rules [[http://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist)][John
McCarthy]] described in his paper [[https://docs.google.com/fileview?id=0B0ZnV_0C-Q7IOTRkNzVjZjMtMWE1NC00YzQ3LTgzMWEtM2UwY2I1YzdmNmM5&hl=en][A Micro-Manual for Lisp - not the
whole Truth]].

This is a literate program, the code in this document is the
executable source, in order to extract it, open this [[https://github.com/nakkaya/nakkaya.com/tree/master/resources/posts/2010-08-24-a-micro-manual-for-lisp-implemented-in-c.org][raw file]] with
emacs and run,

#+begin_example
  M-x org-babel-tangle
#+end_example

#+srcname: lisp-objects
#+begin_src c
  enum type {CONS, ATOM, FUNC, LAMBDA};
  
  typedef struct{
    enum type type;
  } object;
  
  typedef struct {
    enum type type;
    char *name;
  } atom_object;
  
  typedef struct {
    enum type type;
    object *car;
    object *cdr;
  } cons_object;
  
  typedef struct {
    enum type type;
    object* (*fn)(object*,object*);
  } func_object;
  
  typedef struct {
    enum type type;
    object* args;
    object* sexp;
  } lambda_object;
#+end_src

We begin by defining four types of objects we will be using. CONS is
what we use to hold lists, ATOMs are letters or digits anything that is
not used by LISP, a FUNC holds a reference to a C function and a LAMBDA
holds a lambda expression.

#+srcname: lisp-read
#+begin_src c
  object *read_tail(FILE *in) {
    object *token = next_token(in);
  
    if(strcmp(name(token),")") == 0)
      return NULL;
    else if(strcmp(name(token),"(") == 0) {
      object *first = read_tail(in);
      object *second = read_tail(in);
      return cons(first, second);
    }else{
      object *first = token;
      object *second = read_tail(in);
      return cons(first, second);
    }
  }
  
  object *read(FILE *in) {
    object *token = next_token(in);
  
    if(strcmp(name(token),"(") == 0)
      return read_tail(in);
  
    return token;
  }
#+end_src

/read/ gets the next token from the file, if it is a left parentheses it
calls /read_tail/ to parse the rest of the list, otherwise returns the
token read. A list (LIST e1 ... en) is defined for each n to be (CONS
e1 (CONS ... (CONS en NIL))) so *read_tail* will keep calling itself
concatenating cons cells until it hits a right parentheses.

#+srcname: lisp-env
#+begin_src c
  object* init_env(){
    object *env = cons(cons(atom("QUOTE"),cons(func(&fn_quote),NULL)),NULL);
    append(env,cons(atom("CAR"),cons(func(&fn_car),NULL)));
    append(env,cons(atom("CDR"),cons(func(&fn_cdr),NULL)));
    append(env,cons(atom("CONS"),cons(func(&fn_cons),NULL)));
    append(env,cons(atom("EQUAL"),cons(func(&fn_equal),NULL)));
    append(env,cons(atom("ATOM"),cons(func(&fn_atom),NULL)));
    append(env,cons(atom("COND"),cons(func(&fn_cond),NULL)));
    append(env,cons(atom("LAMBDA"),cons(func(&fn_lambda),NULL)));
    append(env,cons(atom("LABEL"),cons(func(&fn_label),NULL)));
  
    tee = atom("#T");
    nil = cons(NULL,NULL);
  
    return env;
  }
#+end_src

Now that we have a list to execute, we need to define the environment we
will be evaluating the expressions in. Environment is a list of pairs
during evaluation we replace those atoms with their values, we also
define tee to be the atom *#T* and nil to be the empty list.

#+srcname: lisp-eval
#+begin_src c
  object *eval_fn (object *sexp, object *env){
    object *symbol = car(sexp);
    object *args = cdr(sexp);
  
    if(symbol->type == LAMBDA)
      return fn_lambda(sexp,env);
    else if(symbol->type == FUNC)
      return (((func_object *) (symbol))->fn)(args, env);
    else
      return sexp;
  }
  
  object *eval (object *sexp, object *env) {
    if(sexp == NULL)
      return nil;
  
    if(sexp->type == CONS){
      if(car(sexp)->type == ATOM && strcmp(name(car(sexp)), "LAMBDA") == 0){
        object* largs = car(cdr(sexp));
        object* lsexp = car(cdr(cdr(sexp)));
  
        return lambda(largs,lsexp);
      }else{
        object *accum = cons(eval(car(sexp),env),NULL);
        sexp = cdr(sexp);
  
        while (sexp != NULL && sexp->type == CONS){
          append(accum,eval(car(sexp),env));
          sexp = cdr(sexp);
        }
  
        return eval_fn(accum,env);
      }
    }else{
      object *val = lookup(name(sexp),env);
      if(val == NULL)
        return sexp;
      else
        return val;
    }
  }
#+end_src

When we pass an S-Expression to eval, first we need to check if it is a
lambda expression if it is we don't evaluate it we just return a lambda
object, if it is a list we call eval for each cell, this allows us to
iterate through all the atoms in the list when we hit an atom we lookup
its value in the environment if it has a value associated with it we
return that otherwise we return the atom, at this point,

#+begin_example
  (QUOTE A)
#+end_example

is transformed into,

#+begin_example
  (func-obj atom-obj)
#+end_example

all eval\_fn has to do is check the type of the car of the list, if it is
a function\_object it will call the function pointed by the
function\_object passing cdr of the list as argument, if it is a
lambda\_object we call the fn\_lambda which executes the lambda
expression else we return the S-Expression.

Each function_object holds a pointer to a function that takes two
arguments, arguments to the function and the environment we are executing
it in and returns an object.

#+srcname: lisp-lambda
#+begin_src c
  object *fn_lambda (object *args, object *env) {
    object *lambda = car(args);
    args = cdr(args);
  
    object *list = interleave((((lambda_object *) (lambda))->args),args);
    object* sexp = replace_atom((((lambda_object *) (lambda))->sexp),list);
    return eval(sexp,env);
  }
#+end_src

A lambda_object holds two lists,

#+begin_example
  (LAMBDA (X Y) (CONS (CAR X) Y))
  args -> (X Y)
  sexp -> (CONS (CAR X) Y))
#+end_example

to execute it first thing we do is interleave the args list with the
arguments passed so while executing following,

#+begin_example
  ((LAMBDA (X Y) (CONS (CAR X) Y)) (QUOTE (A B)) (CDR (QUOTE (C D))))
#+end_example

list will be,

#+begin_example
  ((X (A B)) (Y (D)))
#+end_example

then we iterate over the sexp and replace every occurrence of X with (A
B) and every occurrence of Y with (D) then call eval on the resulting
expression.

This covers everything we need to interpret the LISP defined in the
paper passing a file containing the following,

#+begin_example
  (QUOTE A)
  (QUOTE (A B C))
  (CAR (QUOTE (A B C)))
  (CDR (QUOTE (A B C)))
  (CONS (QUOTE A) (QUOTE (B C)))
  (EQUAL (CAR (QUOTE (A B))) (QUOTE A))
  (EQUAL (CAR (CDR (QUOTE (A B)))) (QUOTE A))
  (ATOM (QUOTE A))
  (COND ((ATOM (QUOTE A)) (QUOTE B)) ((QUOTE T) (QUOTE C)))
  ((LAMBDA (X Y) (CONS (CAR X) Y)) (QUOTE (A B)) (CDR (QUOTE (C D))))
  (LABEL FF (LAMBDA (X Y) (CONS (CAR X) Y)))
  (FF (QUOTE (A B)) (CDR (QUOTE (C D))))
  (LABEL XX (QUOTE (A B)))
  (CAR XX)
#+end_example

should produce,

#+begin_example
  lisp/ $ gcc -Wall lisp.c && ./a.out test.lisp 
  > A
  > (A B C)
  > A
  > (B C)
  > (A B C)
  > #T
  > ()
  > #T
  > B
  > (A D)
  > #T
  > (A D)
  > #T
  > A
#+end_example

* Files                                                            :noexport:

#+begin_src c :exports none :tangle lisp.c :noweb yes
  /* Copyright 2010 Nurullah Akkaya */
  
  /* lisp.c is free software: you can redistribute it and/or modify it */
  /* under the terms of the GNU General Public License as published by the */
  /* Free Software Foundation, either version 3 of the License, or (at your */
  /* option) any later version. */
  
  /* lisp.c is distributed in the hope that it will be useful, but WITHOUT */
  /* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or */
  /* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License */
  /* for more details. */
  
  /* You should have received a copy of the GNU General Public License */
  /* along with lisp.c. If not, see http://www.gnu.org/licenses/. */
  
  #include <stdio.h>
  #include <stdlib.h>
  #include <ctype.h>
  #include <string.h>
  
  <<lisp-objects>>
  
  #define car(X)           (((cons_object *) (X))->car)
  #define cdr(X)           (((cons_object *) (X))->cdr)
  
  char *name(object *o){
    if(o->type != ATOM) exit(1);
    return ((atom_object*)o)->name;
  }
  
  object *atom (char *n) {
    atom_object *ptr = (atom_object *) malloc (sizeof (atom_object));
    ptr->type = ATOM;
    char *name;
    name = malloc(strlen(n) + 1);
    strcpy(name, n);
    ptr->name = name;
    return (object *) ptr;
  }
  
  object *cons (object *first, object *second) {
    cons_object *ptr = (cons_object *) malloc (sizeof (cons_object));
    ptr->type = CONS;
    ptr->car = first;
    ptr->cdr = second;
    return (object *) ptr;
  }
  
  object *func (object* (*fn)(object*, object*)) {
    func_object *ptr = (func_object *) malloc (sizeof (func_object));
    ptr->type = FUNC;
    ptr->fn = fn;
    return (object *) ptr;
  }
  
  void append (object *list, object *obj) {
    object *ptr;
    for (ptr = list; cdr(ptr) != NULL; ptr = cdr(ptr));
    cdr(ptr) = cons(obj, NULL);
  }
  
  object *lambda (object *args, object *sexp) {
    lambda_object *ptr = (lambda_object *) malloc (sizeof (lambda_object));
    ptr->type = LAMBDA;
    ptr->args = args;
    ptr->sexp = sexp;
    return (object *) ptr;
  }
  
  object *tee,*nil;
  
  //
  //
  //
  //
  
  object *eval (object *sexp, object *env);
  
  object *fn_car (object *args, object *env) {
    return car(car(args));
  }
  
  object *fn_cdr (object *args, object *env) {
    return cdr(car(args));
  }
  
  object *fn_quote (object *args, object *env) {
    return car(args);
  }
  
  object *fn_cons (object *args, object *env) {
    object *list = cons(car(args),NULL);
    args = car(cdr(args));
  
    while (args != NULL && args->type == CONS){
      append(list,car(args));
      args = cdr(args);
    }
  
    return list;
  }
  
  object *fn_equal (object *args, object *env) {
    object *first = car(args);
    object *second = car(cdr(args));
    if(strcmp(name(first),name(second)) == 0)
      return tee;
    else
      return nil;
  }
  
  object *fn_atom (object *args, object *env) {
    if(car(args)->type == ATOM)
      return tee;
    else
      return nil;
  }
  
  object *fn_cond (object *args, object *env) {
  
    while (args != NULL && args->type == CONS){
      object *list = car(args);
      object *pred = nil;
  
      if (car(list) != nil)
        pred = eval(car(list), env);
  
      object *ret = car(cdr(list));
  
      if(pred != nil)
        return eval(ret,env);
  
      args = cdr(args);
    }
  
    return nil;
  }
  
  object *interleave (object *c1, object *c2) {
    object *list = cons(cons(car(c1),cons(car(c2),NULL)),NULL);
    c1 = cdr(c1);
    c2 = cdr(c2);
  
    while (c1 != NULL && c1->type == CONS){
      append(list,cons(car(c1),cons(car(c2),NULL)));
      c1 = cdr(c1);
      c2 = cdr(c2);
    }
  
    return list;
  }
  
  object *replace_atom (object *sexp, object *with) {
  
    if(sexp->type == CONS){
  
      object *list = cons(replace_atom(car(sexp), with),NULL);
      sexp = cdr(sexp);
  
      while (sexp != NULL && sexp->type == CONS){
        append(list,replace_atom(car(sexp), with));
        sexp = cdr(sexp);
      }
  
      return list;
    }else{
      object* tmp = with;
  
      while (tmp != NULL && tmp->type == CONS) {
        object *item = car(tmp);
        object *atom = car(item);
        object *replacement = car(cdr(item));
  
        if(strcmp(name(atom),name(sexp)) == 0)
          return replacement;
  
        tmp = cdr(tmp);
      }
  
      return sexp;
    }
  }
  
  <<lisp-lambda>>
  
  object *fn_label (object *args, object *env) {
    append(env,cons(atom(name(car(args))),cons(car(cdr(args)),NULL)));
    return tee;
  }
  
  object* lookup(char* n, object *env){
    object *tmp = env;
  
    while (tmp != NULL && tmp->type == CONS) {
      object *item = car(tmp);
      object *nm = car(item);
      object *val = car(cdr(item));
  
      if(strcmp(name(nm),n) == 0)
        return val;
      tmp = cdr(tmp);
    }
    return NULL;
  }
  
  <<lisp-env>>
  
  <<lisp-eval>>
  
  //
  // I/O
  //
  void print(object *sexp){
    if(sexp == NULL)
      return;
  
    if(sexp->type == CONS){
      printf ("(");
      print(car(sexp));
      sexp = cdr(sexp);
      while (sexp != NULL && sexp->type == CONS) {
        printf (" ");
        print(car(sexp));
        sexp = cdr(sexp);
      }
      printf ( ")");
    }else if(sexp->type == ATOM){
      printf ("%s", name(sexp));
    }else if(sexp->type == LAMBDA){
      printf ("#");
      print((((lambda_object *) (sexp))->args));
      print((((lambda_object *) (sexp))->sexp));
    }else
      printf ("Error.");
  }
  
  object *next_token(FILE *in) {
    int ch = getc(in);
  
    while(isspace(ch)) ch = getc(in);
  
    if(ch == '\n')
      ch = getc(in);
    if(ch == EOF)
      exit(0);
  
    if(ch == ')')
      return atom(")");
    if(ch == '(')
      return atom("(");
  
    char buffer[128];
    int index = 0;
  
    while(!isspace(ch) && ch != ')'){
      buffer[index++] = ch;
      ch = getc (in);
    }
  
    buffer[index++] = '\0';
    if (ch == ')') 
      ungetc (ch, in);
  
    return atom(buffer);
  }
  
  <<lisp-read>>
  
  //
  // REPL
  //
  int main(int argc, char *argv[]){
    object *env = init_env();
    FILE* in;
  
    if(argc > 1)
      in = fopen(argv[1], "r");
    else
      in = stdin;
  
    do {
      printf ("> ");
      print(eval(read(in), env));
      printf ("\n");
    } while (1);
  
    return 0;
  }
  
#+end_src

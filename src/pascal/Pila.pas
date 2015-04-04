Unit Pila;

Interface

Uses ListaDoble,Datos;{ListaDoble es la unidad base para la pila, y Datos contiene la forma de los datos}

Type
	TPila=Record
		Contenido:TListaDoble;
		End;

{Inicializa la pila a Lista Vacia. "P" es la pila}
Procedure InicializarPila (Var P:TPila);

{Devuelve True si la pila está vacía. "P" es la pila}
Function EsPilaVacia(P:TPila):Boolean;

{Inserta un elemento como primer elemento de la lista. "P" es la pila y "e" la información a apilar}
Procedure Apilar (Var P:TPila; e:TInformacion);

{Devuelve la información del primer nodo de la lista y luego lo borra. "P" es la pila}
Function Desapilar (Var P:TPila):TInformacion;

{Devuelve la información del primer nodo de la lista sin borrarlo. "P" es la pila}
Function Cima (P:TPila):TInformacion;

Implementation

{Inicializa la pila a Lista Vacia. "P" es la pila}
Procedure InicializarPila (Var P:TPila);
	Begin
		InicializarListaDoble(P.Contenido);
	End;

{Devuelve True si la pila está vacía. "P" es la pila}
Function EsPilaVacia(P:TPila):Boolean;
	Begin
		If (EsListaDobleVacia(P.Contenido))
			Then EsPilaVacia:=True
			Else EsPilaVacia:=False;
	End;

{Inserta un elemento como primer elemento de la lista. "P" es la pila y "e" la información a apilar}
Procedure Apilar(Var P:TPila; e:TInformacion);
	Begin
		InsertarPrimero(P.Contenido,e);
	End;

{Devuelve la información del primer nodo de la lista y luego lo borra. "P" es la pila}
Function Desapilar(Var P:TPila):TInformacion;
	Begin
		Desapilar:=PrimerElemento(P.Contenido);
		EliminarPrimero(P.Contenido);
	End;

{Devuelve la información del primer nodo de la lista sin borrarlo. "P" es la pila}
Function Cima(P:TPila):TInformacion;
	Begin
		Cima:=PrimerElemento(P.Contenido);
	End;

Begin
End.	

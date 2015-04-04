Unit ListaDobleDeLetras;

Interface

Type
	TNexo=^TNodo;
	TListaDobleOrdenada=Record
		Primero:TNexo;
		Ultimo:TNexo;
	End;
	TDatos=Record
		Letra:Char;
		Cantidad:Cardinal;
	End;
	TNodo=Record
		Info:TDatos;
		Siguiente:TNexo;
		Anterior:TNexo;
	End;

{Inicializa la lista a NIL. "L" es la lista}
Procedure InicializarListaDobleOrdenada(Var L:TListaDobleOrdenada);

{Mete la letra en la lista. Si ya está se incrementa en uno su cantidad, de lo contrario se la introduce en la posición que le corresponde
Funciona como un array disperso. "L" es la lista y "C" es la letra}
Procedure InsertarLetra(Var L:TListaDobleOrdenada; C:Char);

{Devuelve la cantidad de veces que se repite la letra más repetida. "L" es la lista}
Function CantidadLetraMasRepetida(L:TListaDobleOrdenada):Cardinal;

{Borra toda la lista. "L" es la lista}
Procedure VaciarListaDobleOrdenada(Var L:TListaDobleOrdenada);

Implementation

{Inicializa la lista a NIL. "L" es la lista}
Procedure InicializarListaDobleOrdenada(Var L:TListaDobleOrdenada);
	Begin
		L.Primero:=NIL;
		l.Ultimo:=NIL;
	End;

{Devuelve True si la lista está vacía. "L" es la lista}
Function EsListaDobleOrdenadaVacia(L:TListaDobleOrdenada):Boolean;
	Begin
		If(L.Primero=NIL)
			Then EsListaDobleOrdenadaVacia:=True
			Else EsListaDobleOrdenadaVacia:=False;
	End;

{Devuelve un puntero que apunta al siguiente nodo de la lista. "U" es un puntero que apunta a un nodo de la lista}
Function SiguienteLetra(U:TNexo):TNexo;
	Begin
		If(U<>NIL)
			Then SiguienteLetra:=U^.Siguiente
			Else SiguienteLetra:=NIL;
	End;

{"Siguiente" es el puntero de la ListaDoble que apunta al que va a ser el siguiente elemento, y "Anterior" es el que apunta al anterior. "C" es el caracter que introduce.
Crea un nodo entre ambos e introduce en él la información}
Procedure InsertarElementoEntre(Var Siguiente,Anterior:TNexo; C:Char);
	Var
		NuevoNodo:TNexo;
	Begin
		New(NuevoNodo);
		NuevoNodo^.Info.Letra:=C;
		NuevoNodo^.Info.Cantidad:=1;
		NuevoNodo^.Siguiente:=Siguiente;
		NuevoNodo^.Anterior:=Anterior;
		Siguiente:=NuevoNodo;
		Anterior:=NuevoNodo;
	End;

{Devuelve un puntero que apunta al nodo que contiene la letra que se le pasa o al que contiene la primera mayor que ella. "L" es la lista y "C", la letra}
Function BuscaPosicionElemento(L:TListaDobleOrdenada; C:Char):TNexo;
	Var
		Aux:TNexo;
	Begin
		Aux:=L.Primero;
		While(Aux<>NIL)And(Aux^.Info.Letra<C) Do{Sale si se acaba la lista o si la letra pasada es menor o igual que la del nodo apuntado por Aux}
			Aux:=Aux^.Siguiente;
		If(Aux=NIL){Si es NIL es porque todas las letras que hay son menores que la pasada}
			Then BuscaPosicionElemento:=NIL
			Else BuscaPosicionElemento:=Aux;
	End;

{Mete la letra en la lista. Si ya está se incrementa en uno su cantidad, de lo contrario se la introduce en la posición que le corresponde
Funciona como un array disperso. "L" es la lista y "C" es la letra}
Procedure InsertarLetra(Var L:TListaDobleOrdenada; C:Char);
	Var
		Aux:TNexo;
	Begin
		If(EsListaDobleOrdenadaVacia(L))
			Then InsertarElementoEntre(L.Primero,L.Ultimo,C)
			Else 
				Begin
					Aux:=BuscaPosicionElemento(L,C);{Aux queda apuntando al nodo que se debe considerar}
					If(Aux=NIL) Then InsertarElementoEntre(L.Ultimo^.Siguiente,L.Ultimo,C){Si la letra es mayor que todas las de la lista}
					Else If(Aux^.Info.Letra=C) Then Aux^.Info.Cantidad:=Aux^.Info.Cantidad+1{Si la letra ya está en la lista}
					Else If(Aux^.Anterior=NIL) Then InsertarElementoEntre(L.Primero,Aux^.Anterior,C){Si la letra es menor que todas las de la lista}
					Else InsertarElementoEntre(Aux^.Anterior^.Siguiente,Aux^.Anterior,C);{En cualquier otro caso}
				End;
	End;	

{Devuelve la cantidad de veces que se repite la letra más repetida. "L" es la lista}
Function CantidadLetraMasRepetida(L:TListaDobleOrdenada):Cardinal;
	Var
		Aux:TNexo;
		Max:Cardinal;
	Begin
		If(EsListaDobleOrdenadaVacia(L))
			Then CantidadLetraMasRepetida:=0{No hay letras}
			Else
				Begin
					Max:=0;{Cantidad más repetida}
					Aux:=L.Primero;
					While(Aux<>NIL) Do{Sale cuando se acaba de recorrer la lista}
						Begin
							If (Aux^.Info.Cantidad>Max) 
								Then Max:=Aux^.Info.Cantidad;{Si la cantidad es mayor que el máximo guardado, se actualiza el máximo}
							Aux:=SiguienteLetra(Aux);
						End;
					CantidadLetraMasRepetida:=Max;
				End;
	End;


{"Siguiente" es el puntero de la ListaDoble que proviene del siguiente elemento, y "Anterior" es el que proviene del anterior
Borra el nodo que hay entre ambos}
Procedure EliminarElementoEntre(Var Siguiente,Anterior:TNexo);
	Var
		Aux:TNexo;
	Begin
		Aux:=Siguiente;
		Anterior:=Aux^.Siguiente;
		Siguiente:=Aux^.Anterior;
		Dispose(Aux);
		Aux:=NIL;
	End;

{Borra toda la lista. "L" es la lista}
Procedure VaciarListaDobleOrdenada(Var L:TListaDobleOrdenada);
	Begin
		If(Not(EsListaDobleOrdenadaVacia(L)))
			Then Begin
				While(L.Primero^.Siguiente<>NIL) Do{Hasta que solo quede un elemento}
					EliminarElementoEntre(L.Primero^.Siguiente^.Anterior,L.Primero);
				EliminarElementoEntre(L.Ultimo,L.Primero);{Borra el único que queda}
				End;
	End;

Begin
End.

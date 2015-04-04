Unit ListaDoble;

Interface

Uses Datos;{Unidad que contiene la forma de los datos}

Procedure InicializarListaDoble(Var L:TListaDoble);

Procedure InsertarUltimo(Var L:TListaDoble; e:TInformacion);

Procedure InsertarPrimero(Var L:TListaDoble; e:TInformacion);

Procedure EliminarPrimero(Var L:TListaDoble);

Procedure EliminarUltimo(Var L:TListaDoble);

Function EsListaDobleVacia(L:TListaDoble):Boolean;

Function HaySiguienteElemento(U:TUnion):Boolean;

Function BuscaElemento(L:TListaDoble; e:TInformacion):TUnion;

Function ObtenerSiguienteElemento(L:TListaDoble; e:TInformacion):TInformacion;

Function PrimerElemento(L:TListaDoble):TInformacion;

Function UltimoElemento(L:TListaDoble):TInformacion;

Implementation

{Inicializa la lista a NIL. "L" es la lista a inicializar}
Procedure InicializarListaDoble(Var L:TListaDoble);
	Begin
		L.Primero:=NIL;
		l.Ultimo:=NIL;
	End;

{Comprueba si la lista está vacia. "L" es la lista a comprobar}
Function EsListaDobleVacia(L:TListaDoble):Boolean;
	Begin
		If(L.Primero=NIL)
			Then EsListaDobleVacia:=True
			Else EsListaDobleVacia:=False;
	End;		

{"Siguiente" es el puntero de la ListaDoble que apunta al siguiente elemento, y "Anterior" es el que apunta al anterior. "e" es el elemento que inserta.
Crea un nodo entre ambos punteros y guarda en él la información}
Procedure InsertarElementoEntre(Var Siguiente,Anterior:TUnion; e:TInformacion);
	Var
		NuevoNodo:TUnion;
	Begin
		New(NuevoNodo);
		NuevoNodo^.Info:=e;
		NuevoNodo^.Siguiente:=Siguiente;
		NuevoNodo^.Anterior:=Anterior;
		Siguiente:=NuevoNodo;
		Anterior:=NuevoNodo;
	End;

{Inserta un elemento como primer elemento de la lista. "L" es la lista y "e" el elemento}
Procedure InsertarPrimero(Var L:TListaDoble; e:TInformacion);
	Begin
		If(e<>NIL)
			Then If (EsListaDobleVacia(L))
				Then InsertarElementoEntre(L.Primero,L.Ultimo,e){L.Primero y L.Ultimo apuntan a NIL}
				Else InsertarElementoEntre(L.Primero,L.Primero^.Anterior,e);{L.primero apunta al primer nodo, y el otro apunta a NIL}
	End;

{Inserta un elemento como ultimo elemento de la lista. "L" es la lista y "e" el elemento}
Procedure InsertarUltimo(Var L:TListaDoble; e:TInformacion);
	Begin
		If(e<>NIL)
			Then If (EsListaDobleVacia(L))
				Then InsertarElementoEntre(L.Primero,L.Ultimo,e){L.Primero y L.Ultimo apuntan a NIL}
				Else InsertarElementoEntre(L.Ultimo^.Siguiente,L.Ultimo,e);{El primero apunta a NIL, y L.Ultimo al ultimo nodo}
	End;

{"Siguiente" es el puntero de la ListaDoble que proviene del siguiente elemento y "Anterior" es el que proviene del anterior.
Mueve los punteros y luego borra el nodo, pero NO LA INFORMACION A LA QUE APUNTA EL NODO}
Procedure EliminarElementoEntre(Var Siguiente,Anterior:TUnion);
	Var
		Aux:TUnion;
	Begin
		If(Siguiente<>NIL)And(Anterior<>NIL)
			Then Begin
				Aux:=Siguiente;
				Anterior:=Aux^.Siguiente;
				Siguiente:=Aux^.Anterior;
				Dispose(Aux);
				Aux:=NIL;
				End;
	End;

{Elimina el primer elemento de la lista. "L" es la lista}
Procedure EliminarPrimero(Var L:TListaDoble);
	Begin
		If(Not(EsListaDobleVacia(L)))
			Then If(L.Primero=L.Ultimo){Si solo hay un elemento}
				Then EliminarElementoEntre(L.Ultimo,L.Primero){Ambos apuntan al único nodo que hay}
				Else EliminarElementoEntre(L.Primero^.Siguiente^.Anterior,L.Primero);{Ambos apuntan al primer nodo}
	End;

{Elimina el ultimo elemento de la lista. "L" es la lista}
Procedure EliminarUltimo(Var L:TListaDoble);
	Begin
		If(Not(EsListaDobleVacia(L)))
			Then If(L.Primero=L.Ultimo){Si solo hay un elemento}
					Then EliminarElementoEntre(L.Ultimo,L.Primero){Ambos apuntan al único nodo que hay}
					Else EliminarElementoEntre(L.Ultimo,L.Ultimo^.Anterior^.Siguiente);{Ambos apuntan al último nodo}
	End;	

{Devuelve True si "U" no apunta a NIL o al ultimo nodo de la lista}
Function HaySiguienteElemento(U:TUnion):Boolean;
	Begin
		If(U<>NIL)
			Then If(U^.Siguiente=NIL)
				Then HaySiguienteElemento:=False
				Else HaySiguienteElemento:=True
			Else HaySiguienteElemento:=True;
	End;

{Recorre la lista y devuelve un puntero que apunta al nodo que contiene la información. "L" es la lista y "e" la información que busca}
Function BuscaElemento(L:TListaDoble; e:TInformacion):TUnion;
	Var
		Aux:TUnion;
	Begin
		Aux:=L.Primero;
		While(Aux<>NIL)And(Aux^.Info<>e) Do{Sale si Aux es NIL o apunta al nodo que contiene la informacion}
			Aux:=Aux^.Siguiente;
		If(Aux=NIL){Si Aux no es NIL es porque ha encontrado la informacion}
			Then BuscaElemento:=NIL
			Else BuscaElemento:=Aux;
	End;

{Busca el nodo de la lista "L" que contiene la información "e" y devuelve la información del nodo siguiente}
Function ObtenerSiguienteElemento(L:TListaDoble; e:TInformacion):TInformacion;
	Var
		Aux:TUnion;
	Begin
		Aux:=BuscaElemento(L,e);
		If(Aux<>NIL)
			Then If(Aux^.Siguiente=NIL){No hay siguiente elemento si la informacion a buscar no está en la lista o si es el ultimo elemento}
				Then ObtenerSiguienteElemento:=NIL
				Else ObtenerSiguienteElemento:=Aux^.Siguiente^.Info
			Else ObtenerSiguienteElemento:=NIL;
	End;

{Devuelve la información del primer nodo de la lista. "L" es la lista}
Function PrimerElemento(L:TListaDoble):TInformacion;
	Begin
		If(EsListaDobleVacia(L))
			Then PrimerElemento:=NIL
			Else PrimerElemento:=L.Primero^.Info;
	End;

{Devuelve la información del último nodo de la lista. "L" es la lista}
Function UltimoElemento(L:TListaDoble):TInformacion;
	Begin
		If(EsListaDobleVacia(L))
			Then UltimoElemento:=NIL
			Else UltimoElemento:=L.Ultimo^.Info;
	End;

Begin
End.

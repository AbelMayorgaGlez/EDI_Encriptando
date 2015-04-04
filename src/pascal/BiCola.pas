Unit BiCola;

Interface

Uses Datos,ListaDoble;{Datos es la unidad que contiene la forma de los datos, y ListaDoble es la unidad en la que se basa la BiCola}

Type
	TBiCola=Record
		Contenido:TListaDoble;
		End;

{Inicializa la cola a Lista Vacía. "C" es la cola a inicializar}
Procedure InicializarBiCola(Var C:TBiCola);

{Devuelve True si la cola está vacía. "C" es la cola a comprobar}
Function EsBiColaVacia(C:TBiCola):Boolean;

{Inserta un elemento como primer elemento de la lista. "C" es la cola y "e" es el elemento}
Procedure EncolarPrincipio(Var C:TBiCola; e:TInformacion);

{Inserta un elemento como ultimo elemento de la lista. "C" es la cola y "e" es el elemento}
Procedure EncolarFinal(Var C:TBiCola; e:TInformacion);

{Devuelve la información del primer nodo de la lista y lo borra. "C" es la cola}
Function DesencolarPrincipio(Var C:TBiCola):TInformacion;

{Devuelve la información del ultimo nodo de la lista y lo borra. "C" es la cola}
Function DesencolarFinal(Var C:TBiCola):TInformacion;

Implementation

{Inicializa la cola a Lista Vacía. "C" es la cola a inicializar}
Procedure InicializarBiCola(Var C:TBiCola);
	Begin
		InicializarListaDoble(C.Contenido);
	End;

{Devuelve True si la cola está vacía. "C" es la cola a comprobar}
Function EsBiColaVacia(C:TBiCola):Boolean;
	Begin
		EsBiColaVacia:=EsListaDobleVacia(C.Contenido);
	End;

{Inserta un elemento como primer elemento de la lista. "C" es la cola y "e" es el elemento}
Procedure EncolarPrincipio(Var C:TBiCola; e:TInformacion);
	Begin
		InsertarPrimero(C.Contenido,e);
	End;

{Inserta un elemento como ultimo elemento de la lista. "C" es la cola y "e" es el elemento}
Procedure EncolarFinal(Var C:TBiCola; e:TInformacion);
	Begin
		InsertarUltimo(C.Contenido,e);
	End;

{Devuelve la información del primer nodo de la lista y lo borra. "C" es la cola}
Function DesencolarPrincipio(Var C:TBiCola):TInformacion;
	Begin
		DesencolarPrincipio:=PrimerElemento(C.Contenido);
		EliminarPrimero(C.Contenido);
	End;

{Devuelve la información del ultimo nodo de la lista y lo borra. "C" es la cola}
Function DesencolarFinal(Var C:TBicola):TInformacion;
	Begin
		DesencolarFinal:=UltimoElemento(C.Contenido);
		EliminarUltimo(C.Contenido);
	End;

Begin
End.

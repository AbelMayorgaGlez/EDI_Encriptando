Unit unitA;
{$H+}

Interface

Uses Pila,ListaDobleDeLetras,Datos;{Pila es la unidad en la que se basa la unidad. ListaDobleDeLetras es la unidad que contiene las operaciones para trabajar con la lista de caracteres de los ficheros, y Datos es la unidad que contiene la forma de los datos}

Type
	TListadoDeFicheros=TPila;
	TContenido=TListaDobleOrdenada;
	TElemento=TInformacion;

{Inicializa la lista a Pila Vacía. "L" es la lista}
Procedure InicializarListaDeFicheros(Var L:TListadoDeFicheros);

{Comprueba si la lista está vacía. "L" es la lista}
Function EsListadoVacio(L:TListadoDeFicheros):Boolean;

{Devuelve la ruta del nombre de fichero que se le pasa. Vale tanto para Windows como para Linux. "Nombre" es todo el nombre:ruta+nombre+extension}
Function ObtenerRuta(Nombre:String):String;

{Llama a los procedimientos que procesan el nombre y lo introducen en la lista. "L" es la lista, "Nombre" contiene el nombre entero y "Ruta" la ruta de los archivos}
Procedure InsertarNombreFicheroEnListado(Var L:TListadoDeFicheros; Nombre,Ruta:String);

{Procedimiento recursivo que cambia el campo Ultimo del último fichero de la lista. "L" es la lista}
Procedure MarcarUltimoFichero(Var L:TListadoDeFicheros);

{Funcion que devuelve el primer elemento de la lista. "L" es el listado}
Function PrimerFichero(L:TListadoDeFicheros):TElemento;

{Modifica el campo Opcion del elemento. "E" es el elemento y "Opcion" la opcion introducida}
Procedure GuardarOpcionEnFichero(E:TElemento; Opcion:Integer);

{Devuelve True si hay siguiente elemento en la lista. "L" es la lista, y "e" es el elemento a comprobar}
Function HaySiguienteFichero(L:TListadoDeFicheros; e:TElemento):Boolean;

{Función recursiva que devuelve el siguiente fichero del que se le pasa. "L" es la lista, y "e" el elemento del que quiere el siguiente}
Function ObtenerSiguienteFichero(Var L:TListadoDeFicheros; e:TElemento):TElemento;

{Procedimiento recursivo que busca un elemento de la lista y lo borra. "L" es el listado y "e" el elemento a borrar}
Procedure EliminarFicheroDeListado(Var L:TListadoDeFicheros; Var e:TElemento);

{Procedimiento recursivo que borra los ficheros a los que no se les ha asignado una opción. "L" es el listado}
Procedure EliminarSobrantes(Var L:TListadoDeFicheros);

{Cuenta cada una de las letras del fichero QUE YA ESTÁ ABIERTO y las introduce en la lista de letras C. 
Las funciones a las que llama esta función están en ListaDobleDeLetras. "E" es el archivo a analizar y "C" es la lista de letras}
Procedure CalcularFrecuenciaDeCaracteres(E:TElemento;Var C:TContenido);

{Devuelve True si la opcion se corresponde con la extensión del fichero. "E" es el elemento}
Function OpcionValida(E:TElemento):Boolean;

{Devuelve True si el fichero se ha podido abrir. Si se abre no lo cierra. "E" es el elemento para abrir}
Function AbiertoConExito(E:TElemento):Boolean;

{Busca en la lista de letras C la cantidad máxima y lo guarda en el campo clave del elemento. Luego vacía la lista de letras C}
Procedure CalcularClaveEncriptacion(E:TElemento;Var C:TContenido);

{Decide que se debe hacer con el elemento que se le pasa. "E" es el elemento}
Procedure ProcesarArchivo(E:TElemento);

{Cierra el archivo. "E" es el elemento a cerrar}
Procedure CerrarArchivo(E:TElemento);

{Crea un informe vacío en la ruta en la que están los ficheros. "Ruta" es la ruta de los ficheros y "F" es el informe}
Procedure CrearInforme(Ruta:String;Var F:Text);

{Inserta la información del elemento en el informe. "E" es el elemento y "F" es el informe}
Procedure InsertarEnInforme(E:TElemento;Var F:Text);

{Cierra el informe. "F" es el informe}
Procedure CerrarInforme(Var F:Text);
Implementation

{Inicializa la lista a Pila Vacía. "L" es la lista}
Procedure InicializarListaDeFicheros(Var L:TListadoDeFicheros);
	Begin
		InicializarPila(L);
	End;

{Comprueba si la lista está vacía. "L" es la lista}
Function EsListadoVacio(L:TListadoDeFicheros):Boolean;
	Begin
		EsListadoVacio:=EsPilaVacia(L);
	End;

{Devuelve True si hay siguiente elemento en la lista. "L" es la lista, y "e" es el elemento a comprobar}
Function HaySiguienteFichero(L:TListadoDeFicheros; e:TElemento):Boolean;
	Begin
		If (EsPilaVacia(L) Or e^.Ultimo){Si el elemento es el ultimo, entonces no hay más}
			Then HaySiguienteFichero:=False
			Else HaySiguienteFichero:=True;
	End;

{Devuelve la ruta del nombre de fichero que se le pasa. Vale tanto para Windows como para Linux. "Nombre" es todo el nombre:ruta+nombre+extension}
Function ObtenerRuta(Nombre:String):String;
	Var
		i,Comienzo:Word;
	Begin
		Comienzo:=0;
        For i:=1 To Length(Nombre) Do{Busca la posición de la última barra. '\' para windows y '/' para linux}
            If(Nombre[i]='\') Or (Nombre[i]='/') Then Comienzo:=i;
        If Comienzo>0{Si comienzo es 0 es porque no hay ruta}
			Then ObtenerRuta:=Copy(Nombre,1,Comienzo){Extrae la ruta del nombre. Desde la posición 1 el número de caracteres que indica Comienzo}
			Else ObtenerRuta:='';
	End;

{Quita la ruta y separa el nombre de la extensión. "Ruta" es la ruta en la que deben estar todos los ficheros. 
"Nombre" es todo el nombre(con ruta y extension) al principio,pero al salir contiene solo en nombre, y "Extension" al principio es '' y al salir contiene la extension}
Procedure ProcesarNombre(Ruta:String; Var Nombre,Extension:String);
	Begin
		If(Pos(Ruta,Nombre)<>0){Si el archivo está en la ruta, quita el la ruta del nombre}
			Then Delete(Nombre,1,length(Ruta));
		Extension:=Copy(Nombre,Pos('.',Nombre)+1,Length(Nombre));{Separa el nombre de la extensión}
		While(Pos('.',Extension)<>0)Do{Por si acaso hay varios '.' en el nombre del archivo}
			Delete(Extension,1,Pos('.',Extension));
		Extension:='.'+Extension;{Añade el '.' a la extensión}
		Delete(Nombre,Pos(Extension,Nombre),Length(Extension));{Borra del nombre la extension}
	End;

{Devuelve True si el nombre y la extensión son válidos}
Function EsNombreValido(Nombre,Extension:String):Boolean;
	Var
		Valido:Boolean;
	Begin
		Valido:=True;
		If(Length(Nombre)>8){Si el nombre tiene más de 8 caracteres no es válido}
			Then Valido:=False
			Else If(Length(Extension)<>4){Si la extensión no tiene 3 caracteres más el punto, no es válido}
				Then Valido:=False;
		EsNombreValido:=Valido;
	End;

{Crea la información del nuevo archivo y lo introduce en la lista. "L" es la lista, y "Ruta", "Nombre" y "Extension" componen el nombre del archivo}
Procedure NuevoNombreEn(Var L:TListadoDeFicheros;Ruta,Nombre,Extension:String);
	Var
		Aux:TElemento;
	Begin
		New(Aux);
		Aux^.Ruta:=Ruta;
		Aux^.Nombre:=Nombre;
		Aux^.Extension:=Extension;
		Aux^.Opcion:=2;{Indica que no se le ha asignado una opción}
		Aux^.Ultimo:=False;{Indica si es el último fichero. Al introducirlos, para todos vale False, pero luego se modifica}
		Apilar(L,Aux);{Lo mete en el listado}
	End;

{Procedimiento recursivo que busca en la lista si ya existe el nombre en la lista. De lo contrario, lo introduce, pero como último elemento de la pila.
Así quedan colocados para su tratamiento. "L" es el listado, y "Ruta", "Nombre" y "Extension" componen el nombre del archivo}
Procedure BuscarCoincidenciasEInsertar(Var L:TListadoDeFicheros; Ruta,Nombre,Extension:String);
	Var
		Aux:TElemento;
	Begin
		If(EsPilaVacia(L))
			Then NuevoNombreEn(L,Ruta,Nombre,Extension){Caso base. Si la pila es vacía es porque no está ese nombre y lo pone}
			Else Begin{Caso recursivo. Desapila y pasa la pila sobrante para ver si en ella está el nombre, y en caso negativo, introducirlo}
				Aux:=Desapilar(L);
				If(Aux^.Nombre+Aux^.Extension<>Nombre+Extension)
					Then BuscarCoincidenciasEInsertar(L,Ruta,Nombre,Extension);
				Apilar(L,Aux);{Vuelve a colocar el elemento en la lista}
				End;
	End;

{Llama a los procedimientos que procesan el nombre y lo introducen en la lista. "L" es la lista, "Nombre" contiene el nombre entero y "Ruta" la ruta de los archivos}
Procedure InsertarNombreFicheroEnListado(Var L:TListadoDeFicheros; Nombre,Ruta:String);
	Var
		Extension:String;
	Begin
		ProcesarNombre(Ruta,Nombre,Extension);{Deja por separado la ruta, el nombre y la extensión}
		If (EsNombreValido(Nombre,Extension)){Si es un nombre válido, se puede insertar en la lista}
			Then BuscarCoincidenciasEInsertar(L,Ruta,Nombre,Extension);
	End;

{Procedimiento recursivo que cambia el campo Ultimo del último fichero de la lista. "L" es la lista}
Procedure MarcarUltimoFichero(Var L:TListadoDeFicheros);
	Var
		Final:TElemento;
	Begin
		If(Not EsListadoVacio(L))
			Then Begin
				Final:=Desapilar(L);{Extrae un elemento de la lista}
				If(EsPilaVacia(L)){Si queda la lista vacía, es porque ese elemento era el último}
					Then Begin
						Final^.Ultimo:=True;
						End
					Else MarcarUltimoFichero(L);{Si no, busca el último elemento en la lista sobrante}
				Apilar(L,Final);{Vuelve a poner el elemento en la lista}
				End;
	End;

{Funcion que devuelve el primer elemento de la lista. "L" es el listado}
Function PrimerFichero(L:TListadoDeFicheros):TElemento;
	Begin
		If (Not EsPilaVacia(L))
			Then PrimerFichero:=Cima(L){Gracias a la forma de introducir los ficheros, el primer elemento de la lista es el que está en la cima}
			Else PrimerFichero:=NIL;
	End;

{Modifica el campo Opcion del elemento. "E" es el elemento y "Opcion" la opcion introducida}
Procedure GuardarOpcionEnFichero(E:TElemento; Opcion:Integer);
	Begin
		If (E<>NIL)Then E^.Opcion:=Opcion;
	End;

{Función recursiva que devuelve el siguiente fichero del que se le pasa. "L" es la lista, y "e" el elemento del que quiere el siguiente}
Function ObtenerSiguienteFichero(Var L:TListadoDeFicheros; e:TElemento):TElemento;
	Var
		Aux:TElemento;
	Begin
		If (HaySiguienteFichero(L,e))
			Then Begin{Caso recursivo}
				Aux:=Desapilar(L);{Extrae un elemento de la lista}
				If(Aux=e){Si es igual que el que le he pasado, el siguiente es el de la cima de la pila resultante}
					Then ObtenerSiguienteFichero:=Cima(L)
					Else ObtenerSiguienteFichero:=ObtenerSiguienteFichero(L,e);{Si no, busca el siguiente en la pila resultante}
				Apilar(L,Aux);{Vuelve a poner el elemento en la lista}
				End
			Else ObtenerSiguienteFichero:=NIL;{Caso Base}
	End;

{Procedimiento recursivo que busca un elemento de la lista y lo borra. "L" es el listado y "e" el elemento a borrar}
Procedure EliminarFicheroDeListado(Var L:TListadoDeFicheros; Var e:TElemento);
	Var
		Aux:TElemento;
	Begin
		If (Not EsPilaVacia(L)){Caso base implícito. Si la pila está vacía no se puede borrar nada}
			Then Begin{Caso recursivo}
				Aux:=Desapilar(L);{Extrae un elemento de la lista}
				If(Aux=e){Si es el que buscaba, lo borra}
					Then Dispose(Aux)
					Else Begin{De lo contrario, lo busca en la pila resultante}
						EliminarFicheroDeListado(L,e);
						Apilar(L,Aux);{Vuelve a poner el elemento en la lista}
						End;
				End;	
	End;

{Procedimiento recursivo que borra los ficheros a los que no se les ha asignado una opción. "L" es el listado}
Procedure EliminarSobrantes(Var L:TListadoDeFicheros);
	Var
		Aux:TElemento;
	Begin
		If(Not EsPilaVacia(L)){Caso base implicito. Si la pila está vacía no tiene que hacer nada}
			Then Begin
				Aux:=Desapilar(L);{Extrae un elemento de la lista}
				EliminarSobrantes(L);{Comprueba el resto de la lista}
				If(Aux^.Opcion=2){Si la opción es 2 es porque no se le ha asignado ninguna opción}
					Then Dispose(Aux)
					Else Apilar(L,Aux);
				End;
	End;

{Devuelve True si la opcion se corresponde con la extensión del fichero. "E" es el elemento}
Function OpcionValida(E:TElemento):Boolean;
	Var
		Valido:Boolean;
	Begin
		Valido:=True;
		If(((E^.Opcion=0)And(E^.Extension='.enc'))Or((E^.Opcion=1)And(E^.Extension<>'.enc'))) Then Valido:=False;
		OpcionValida:=Valido;
	End;

{Devuelve True si el fichero se ha podido abrir. Si se abre no lo cierra. "E" es el elemento para abrir}
Function AbiertoConExito(E:TElemento):Boolean;
	Begin
        Assign(E^.Fichero,E^.Ruta+E^.Nombre+E^.Extension);
		{$I-} Reset(E^.Fichero);
		If(IOResult<>0){Si IOResult no es 0 es porque se ha producido un error}
			Then AbiertoConExito:=False
			Else AbiertoConExito:=True;
		{$I+}
	End;

{Cuenta cada una de las letras del fichero QUE YA ESTÁ ABIERTO y las introduce en la lista de letras C. 
Las funciones a las que llama esta función están en ListaDobleDeLetras. "E" es el archivo a analizar y "C" es la lista de letras}
Procedure CalcularFrecuenciaDeCaracteres(E:TElemento;Var C:TContenido);
	Var
		i:Cardinal;
		Buffer:Char;
	Begin
		InicializarListaDobleOrdenada(C);{Inicializa la lista de letras}
		For i:=1 To Filesize(E^.Fichero) Do{Recorre todo el archivo leyendo los caracteres y los introduce en la lista}
			Begin
				Read(E^.Fichero,Buffer);
				InsertarLetra(C,Buffer);
			End;
		Seek(E^.Fichero,0);{Deja el cabezal de lectura/escritura a la primera posición del fichero}
    End;

{Busca en la lista de letras C la cantidad máxima y lo guarda en el campo clave del elemento. Luego vacía la lista de letras C}
Procedure CalcularClaveEncriptacion(E:TElemento;Var C:TContenido);
	Begin
		E^.Clave:=CantidadLetraMasRepetida(C);
		VaciarListaDobleOrdenada(C);
	End;

{Encripta el fichero que se le pasa. "E" es el elemento a encriptar}
Procedure EncriptarFichero(E:TElemento);
	Var
		FicheroEncriptado:File Of Char;
		Buffer:Char;
		i:Cardinal;
	Begin
		Assign(FicheroEncriptado,E^.Ruta+E^.Nombre+'.enc');
		Rewrite(FicheroEncriptado);{Crea el fichero encriptado}
		For i:=1 To Filesize(E^.Fichero) Do{Recorre todo el fichero}
			Begin
				Read(E^.Fichero,Buffer);{Lee una letra del fichero}
				Write(FicheroEncriptado,Chr((Ord(Buffer)+E^.Clave) mod 256));{Guarda el carácter codificado correspondiente al leido}
			End;
		Close(FicheroEncriptado);{Cierra el fichero encriptado}
	End;

{Desencripta el fichero que se le pasa. "E" es el elemento a desencriptar}
Procedure DesencriptarFichero(E:TElemento);
	Var
		FicheroDesencriptado:File Of Char;
		Buffer:Char;
		i:Cardinal;
	Begin
		Assign(FicheroDesencriptado,E^.Ruta+E^.Nombre+'.des');
		Rewrite(FicheroDesencriptado);{Crea el fichero desencriptado}
		For i:=1 To Filesize(E^.Fichero) Do{Recorre el fichero}
			Begin
				Read(E^.Fichero,Buffer);{Lee un carácter del fichero}
				Write(FicheroDesencriptado,Chr((Ord(Buffer)-E^.Clave) mod 256));{Guarda el carácter decodificado correspondiente al leido}
			End;
		Close(FicheroDesencriptado);{Cierra el fichero desencriptado}
	End;

{Decide que se debe hacer con el elemento que se le pasa. "E" es el elemento}
Procedure ProcesarArchivo(E:TElemento);
	Begin
		Case E^.Opcion Of
			0:EncriptarFichero(E);
			1:DesencriptarFichero(E);
		End;
	End;

{Cierra el archivo. "E" es el elemento a cerrar}
Procedure CerrarArchivo(E:TElemento);
	Begin
		Close(E^.Fichero);
	End;


{Crea un informe vacío en la ruta en la que están los ficheros. "Ruta" es la ruta de los ficheros y "F" es el informe}
Procedure CrearInforme(Ruta:String;Var F:Text);
	Begin
		Assign(F,Ruta+'Informe.txt');
		Rewrite(F);
	End;

{Inserta la información del elemento en el informe. "E" es el elemento y "F" es el informe}
Procedure InsertarEnInforme(E:TElemento;Var F:Text);
	Begin
		Write(F,E^.Ruta+E^.Nombre+E^.Extension,' ', E^.Opcion,' ',E^.Ruta+E^.Nombre);{Escribe la información fija}
		If(E^.Opcion=0){Dependiendo de la opción, pone una extensión u otra}
			Then Write(F,'.enc')
			Else Write(F,'.des');
		Writeln(F,' ',E^.Clave);{Termina de escibir la información}
	End;
			
{Cierra el informe. "F" es el informe}
Procedure CerrarInforme(Var F:Text);
	Begin
		Close(F);
	End;
	
Begin
End.

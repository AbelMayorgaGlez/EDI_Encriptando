Program EncriptadoDelCesar;
{$H+}
Uses unitA;
Var
	ListadoDeFicheros:TListadoDeFicheros;
	Elemento:TElemento;
	Contenido:TContenido;{Contenido de los ficheros}
	Nombre,Ruta:String;
	Opcion:ShortInt;
	Informe:Text;
Begin
	InicializarListaDeFicheros(ListadoDeFicheros);
//PEDIR FICHEROS
	Writeln('Introduzca el nombre de todos los ficheros a tratar...(0 para terminar)');
	Readln(Nombre);
	Ruta:=ObtenerRuta(Nombre);{La ruta del primer fichero introducido será la que se asignará a los demás}
    While(Nombre<>'0') Do
		Begin
			InsertarNombreFicheroEnListado(ListadoDeFicheros,Nombre,Ruta);
			Readln(Nombre);
		End;
	MarcarUltimoFichero(ListadoDeFicheros);{Marca el último fichero de la lista}
//PEDIR OPCION
	Elemento:=PrimerFichero(ListadoDeFicheros);{Empieza por el primero y asigna la opción a todos}
	Writeln('Elija la opcion deseada: 0 Encriptar, 1 Desencriptar y -1 para terminar.');
	{$I-}
	If(Not EsListadoVacio(ListadoDeFicheros))
		Then Begin{Si el listado no está vacío, mete las opciones}
			Opcion:=-1;
			Repeat
				If(IOResult=0)
					Then If(Opcion In [0,1]){Solo guarda la opción si es un valor válido}
						Then
							Begin
								GuardarOpcionEnFichero(Elemento,Opcion);
								Elemento:=ObtenerSiguienteFichero(ListadoDeFicheros,Elemento);
							End;
				Readln(Opcion);
			Until (Opcion=-1)Or(Not HaySiguienteFichero(ListadoDeFicheros,Elemento));
			If(Opcion<>-1) Then GuardarOpcionEnFichero(Elemento,Opcion);{Siempre queda el ultimo elemento sin introducir la opción, por lo que si es distinta de -1, se introduce}
			End
		Else ReadLn(Opcion);{Si el listado está vacío, lee una opcion pero no la guarda}
	While (Opcion<>-1) Do{Lee opciones hasta que se introduzca un -1}
    	Begin
        	If (IOResult=0) Then Readln(Opcion);
        End;
	{$I+};
	EliminarSobrantes(ListadoDeFicheros);{Borra los archivos que no tienen opción asignada}
	MarcarUltimoFichero(ListadoDeFicheros);{Vuelve a marcar el último fichero}
//PROCESAR FICHEROS
	CrearInforme(Ruta,Informe);{Crea el informe en la ruta del primer elemento}
    If(Not(EsListadoVacio(ListadoDeFicheros)))
	Then
		Begin
			Writeln('Procesando archivos...');
			Repeat
				Elemento:=PrimerFichero(ListadoDeFicheros);
				If ((OpcionValida(Elemento))And(AbiertoConExito(Elemento))){Si el fichero es válido lo procesa}
					Then
						Begin
				            CalcularFrecuenciaDeCaracteres(Elemento,Contenido);
							CalcularClaveEncriptacion(Elemento,Contenido);
							ProcesarArchivo(Elemento);
							CerrarArchivo(Elemento);
							InsertarEnInforme(Elemento,Informe);
						End;
				EliminarFicheroDeListado(ListadoDeFicheros,Elemento);{Elimina el fichero del listado una vez procesado o si no es válido}
			Until EsListadoVacio(ListadoDeFicheros);{Hasta que se acabe el listado}
		End;
	CerrarInforme(Informe);{Cierra el informe}
End.

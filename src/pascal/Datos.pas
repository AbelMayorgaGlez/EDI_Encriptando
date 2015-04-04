Unit Datos;{Contiene la estructura en la que se basan todas las unidades}

Interface

Type
	TUnion=^TNodo;
	TListaDoble=Record
		Primero:TUnion;
		Ultimo:TUnion;
	End;
	TDatos=Record
		Fichero:File Of Char;
		Ruta:String;
		Nombre:String;
		Extension:String;
		Opcion:Byte;
		Clave:Cardinal;
		Ultimo:Boolean;
	End;
	TInformacion=^TDatos;
	TNodo=Record
		Info:TInformacion;
		Siguiente:TUnion;
		Anterior:TUnion;
	End;

Implementation

Begin
End.

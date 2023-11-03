{
  
  const parsear_fichero = function(fichero) {
    const fs = require("fs");
    const path = require("path");
    const fichero_final = path.resolve(options.__source, "..", fichero);
    const contenido = fs.readFileSync(fichero_final).toString();
    const ast = options.__parser.parse(contenido, {
      __source: fichero_final,
      __parser: options.__parser
    });
    return ast.contenido;
  };

  const reducir_contenido = function(sentencias) {
    let resultado = [];
    for(let i=0; i<sentencias.length; i++) {
      const sentencia = sentencias[i];
      if(sentencia.tipo === "narrativa") {
        resultado.push(sentencia);
      } else if(sentencia.tipo === "diálogo") {
        resultado.push(sentencia);
      } else if(sentencia.tipo === "apunte") {
        resultado.push(sentencia);
      } else if(sentencia.tipo === "fragmento") {
        resultado = resultado.concat(sentencia.fragmento);
      }
    }
    return resultado;
  }

}

Lenguaje = 
  cabecera:Cabeceras?
  contenido:Sentencia* _*
    { return { cabecera, contenido: reducir_contenido(contenido) } }

Cabeceras = 
  token_1:Token_abrir_cabeceras
  cabeceras:Cabecera*
  token_2:Token_cerrar_cabeceras
    { return cabeceras }
    
Cabecera = 
  token_1:Token_abrir_cabecera_individual
  nombre:Token_cerrar_cabecera_individual_negado
  token_2:Token_cerrar_cabecera_individual
  valor:Token_salto_de_linea_negado
    { return { nombre, valor } }

Sentencia = 
  Sentencia_de_dialogo /
  Sentencia_de_fragmento /
  Sentencia_de_apunte /
  Sentencia_de_narrativa

Sentencia_de_apunte = 
  token_1:Token_arroba
  cosa:Token_dos_puntos_curly_negado
  token_2:Token_dos_puntos_curly
  valor:Token_curly_cerrado_negado
  token_3:Token_curly_cerrado
    { return { tipo: "apunte", cosa, valor } }

Sentencia_de_fragmento = 
  token_1:Token_de_fragmento
  fichero:Token_de_salto_de_linea_negado
    { return { tipo: "fragmento", fragmento: parsear_fichero(fichero) } }

Sentencia_de_narrativa = 
  token_1:Token_de_inicio_de_narrativa
  narrativa:Dialogo
    { return { tipo: "narrativa", narrativa } }

Sentencia_de_dialogo = 
  actores:Actores
  modo:Subsentencia_dicen
  dialogo:Dialogo
    { return { tipo: "diálogo", actores, modo, dialogo } }

Sentencia_de_accion = 
  actores:Actores
  token_1:Token_dos_puntos
  dialogo:Dialogo
    { return { actores, dialogo } }

Actores = 
  actor_1:Actor_inicial
  actor_n:Otros_actores*
    { return [actor_1].concat(actor_n ? actor_n : []) }

Actor_inicial = 
  token_1:Token_abrir_actor_inicial
  actor:Token_cerrar_actor_negado
  token_2:Token_cerrar_actor
    { return actor }

Actor = 
  token_1:Token_abrir_actor
  actor:Token_cerrar_actor_negado
  token_2:Token_cerrar_actor
    { return actor }

Otros_actores = 
  token_1:("+")
  actor:Actor
    { return actor }

Dialogo = Token_de_fin_de_dialogo_negado / EOF { return text().trim() }

Subsentencia_dicen =
  token_1:(" dicen"/" dice")
  modo:Token_dos_puntos_negados
  token_2:(":")
    { return modo }

Token_de_fin_de_dialogo_negado = (!(___ ___+).)* { return text().trim() }
Token_dos_puntos_negados = (!(":").)* { return text().trim() }
Token_abrir_actor_inicial = (___ ___+)? "@{"
Token_abrir_actor = "@{"
Token_abrir_actor_negado = (!(Token_abrir_actor).)+ { return text().trim() }
Token_cerrar_actor = "}"
Token_abrir_cabecera_individual = EOL "["
Token_cerrar_cabecera_individual = "]"
Token_cerrar_cabecera_individual_negado = (!(Token_cerrar_cabecera_individual).)+ { return text().trim() }
Token_salto_de_linea_negado = (!(EOL).)+ { return text().trim() }
Token_cerrar_actor_negado = actor:(!(Token_cerrar_actor) .)+ { return text().trim() }
Token_dos_puntos = ":"
Token_abrir_cabeceras = "-"+
Token_cerrar_cabeceras = (EOL "-"+)
Token_de_inicio_de_narrativa = (___ ___+)? ("»"/">") { }
Token_de_fragmento = (___ ___+)? ("#" (" ")? ("fragmento:" / "Fragmento:")) {}
Token_de_salto_de_linea_negado = (!(___+).)* { return text().trim() }
Token_arroba = (___ ___+)? "@" {}
Token_dos_puntos_curly_negado = (!(Token_dos_puntos_curly) .)+ { return text().trim() }
Token_dos_puntos_curly = ":" __* "{" {}
Token_curly_cerrado_negado = (!(Token_curly_cerrado) .)+ { return text().trim() }
Token_curly_cerrado = ___ "}"

_ = ( __ / ___ )
__ = ( "\t" / " " )
___ = ( "\r\n" / "\r" / "\n" )
EOL = ___
EOF = !.
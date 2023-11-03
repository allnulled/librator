const fs = require("fs");
const parser = require(__dirname + "/../src/librator.nodejs.js");
const ficheros = fs.readdirSync(__dirname + "/samples");


for(let index = 0; index < ficheros.length; index++) {
    const fichero = ficheros[index];
    const ruta = __dirname + "/samples/" + fichero;
    const ruta_salida = __dirname + "/salida/" + fichero.replace(".lbt", ".json");
    const contenido = fs.readFileSync(ruta).toString();
    const salida = parser.parse(contenido, {
        __source: ruta,
        __parser: parser
    });
    fs.writeFileSync(ruta_salida, JSON.stringify(salida, null, 2), "utf8");
}
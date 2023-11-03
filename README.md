# librator

Lenguaje de programación para escribir novelas. Sí, otro más.

## Versión online

Puedes ir directamente a la versión online aquí:

 - [https://allnulled.github.io/librator/](https://allnulled.github.io/librator/)

## Instalación

```sh
npm i -s librator
```

## Uso

En node.js:

```js
require("librator").parse(texto);
```

En el browser:

```html
<script src="node_modules/librator/dist/librator.globals.js"></script>
<script>
window.Librator.parse(texto);
</script>
```

## Sintaxis

### 1. Cabeceras

```lbt
-----------------------------
[Título]    Título del libro
[Subtítulo] Subtítulo del libro
[Autor]     Autor del libro
-----------------------------
```

### 2. Sentencia de diálogo

```lbt
@{ Personaje 1 } dice: Hola, personaje 2.
¿Qué tal estás, personaje 2?

@{ Personaje 2 } dice:
Sí, así también puedes escribir.
```

### 3. Sentencia de narrativa

```lbt
> Primera narrativa directa.
También soporta múltiples líneas.

> Segunda narrativa directa.
```

### 4. Sentencia de fragmento

```lbt
# Fragmento: ../fragmentos/capitulo1.lbt

# Fragmento: ../fragmentos/capitulo2.lbt
```

Esta sentencia solo sirve en node.js, en el browser dará fallos porque lee en tiempo de parseo un fichero externo.

### 5. Sentencia de apunte

```lbt
@Tema: {
Aquí los apuntes sobre el tema.
Vale todo menos: salto de línea + cierre de paréntesis curvados.
}

@Otro tema: {
Aquí los apuntes sobre el otro tema.
}
```
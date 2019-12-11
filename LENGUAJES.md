### El arnés de test está preparado para multiples lenguajes
### Para añadir un nuevo lenguaje:

1. Crea una nueva carpeta dentro de app, ej: si vas a añadir soporte para **rust**, pues crea la carpeta **app/rust**. El único requerimiento para el contenido de esta carpeta es que contenga un **Dockerfile** para hacer el build de la aplicación

2. Añade una tarea en el Makefile con nombre **setup-rust**, ej:

```
setup-rust:
	echo "Seeting up [rust] stack..."
	@echo "rust" > .sabor	
``` 

3. Lo ideal es que el código base de la aplicación sea lo más básico posible para pasar el test inicial `test3`, y luego crear parches de git para ir añadiendo funcionalidades al código base a medida que se va avanzando en los ejercicios.Puedes ver un ejemplo en nodejs dentro de `test/patches/nodejs`

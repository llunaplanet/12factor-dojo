# Bienvenidos al dojo 🏯 de 12 factor

Aquí encontrarás algunos ejercicios, mezcla entre katas y koans con las que practicar tu DevOps-fu 🥋, mejorar tus habilidades y ganar experiencia. 

## The twelve-factor app

Se trata de una metodología para construir aplicaciones y no puede faltar en nuestra caja de herramientas DevOps. Pásate por https://12factor.net/es/ que lo explica muy bien

## Los ejercicios

Los ejercicios que aquí proponemos te ayudarán a entender de forma práctica los principios de **12 factor**

### Katas o Koans?

Los ejercicios tienen espíritu de Koan, ya que para cada principio existe un test que sólo va a pasar en verde una vez se ha comprendido y aplicado lo que el principio trata de enseñarnos.

Los ejercicios tienen también aire de Kata ya que no hay una sola solución para el problema, y hay una serie de restricciones al aplicar la solución.

A partir de aquí los llamaremos katakoan ( se aceptan sugerencias : )

## ¿Cómo funciona?

Tenemos por un lado una serie de tests que cubren cada uno de los principios de 12-factor, (uno o varios por cada principio ) y por otro lado tenemos una aplicación que deberemos modificar.

### El objetivo

Deberemos ir modificando la aplicación para hacerla compatible con **12 factor** de forma que los tests pasen.

Deberemos ir haciendo las katakoans de una en una por orden ( el orden es importante ya que hay algunos principios de **12 factor** son más fáciles de comprender/asimilar/aplicar cuando ya se han comprendido algunos otros primero )

### Entre bastidores

El arnés de test se va a encargar, para cada uno de los tests, de **construir una imagen de docker** con la aplicación, a esta imagen que llamaremos SUT se le pasarán una serie de tests ( de caja negra ) que validarán si el SUT es compatible con 12 factor.

Los tests corren sobre una un entorno de docker totalmente aislado usando DIND ( Docker In Docker ). 

Los tests usan docker-compose para declarar las dependencias del SUT en cada uno de los tests

Los tests están descritos con **rspec**

## ¿Qué nivel de DevOps-fu 🥋 hace falta?

Como en todo dojo, todos los niveles de DevOps-fu 🥋son bienvenidos, aunque hay algunos ejercicios en los que se manejan conceptos avanzados.

## ¿Qué necesito para empezar?

Para empezar sólo necesitas tener instalado Docker 🐳 en tu equipo para poder ejecutar y validar los ejercicios.

Bueno es interesante haber pegado una leída 🤓primero, aunque sea en diagonal, a los 12 principios antes de ponerse manos a la obra.

## Hajime!! ( o manos a la obra )

Clona el repositorio

```
git clone https://github.com/llunaplanet/12factor-dojo.git
```
El siguiente comando va a preparar el entorno de test, va a crear el servicio DIND y a construir la imagen docker con las herramientas necesarias para lanzar los tests ( docker-compose, rspec ), 

Ejecuta el siguiente comando:
```
cd 12factor-dojo
make setup
```
El siguiente comando va a iniciar el entorno de test, va a crear el contenedor desde el cual lanzaremos los tests

Ejecuta el siguiente comando:
```
make hajime
```
Por último, dado que estamos en un entorno DIND hemos de construir una ultima imagen y ya estaremos listos para empezar:

Ejecuta el siguiente comando desde la shell del dojo ( /dojo # ):

```
make prepare
```
En este momento ya estás listo para practicar las katakoans:

Empieza ejecutando el primer test, lee el resultado y piensa cómo puedes modificar la aplicación para que el test pase
```
make test3
```
### Listado de katakoans

Este es el listado de las katakoans que hay actualmente junto con el comando que ejecuta su test.

> IMPORTANTE: En algunas de las katakoans deberás ejecutar un comando extra para añadir a la aplicación nuevas funcionalidades con las que trabajar, puede que esto cause algún conflicto con tu git, pero esto también es bueno para practicar tu git-fu ;)

 - III. Store config in the environment    
	 - `make test3`
 - IV. Backing services
   -  `make patch4` ( Ejecuta sólo una vez )
   -  `make test4`
 - V. Strictly separate build and run stages
	 - `make test5`
 - XI. Treat logs as event streams
   - `make patch11` ( Ejecuta sólo una vez )
   - `make test11`
 - IX. Maximize robustness with fast startup and graceful shutdown
	 - `make test9`
   
Una vez hayas completado todos los ejercicios individualmente, ejecuta `make test-all` para pasar todos los tests en el mismo run

### Restricciones

- Lo único que se puede modificar es el contenido de la carpeta APP 
- Algunas de las katakoan tienen restricciones extra
- No se puede modificar ninguno de los archivos dentro de la carpeta "tests" 

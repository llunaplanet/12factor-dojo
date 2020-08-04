# Welcome to the **12 factor** dojo 🏯 !

Here you will find some exercises for practicing your DevOps-fu 🥋, improve your skills and gain experience.

## The twelve-factor app

It's a methodology for building software-as-a-service apps, and it's a must in your DevOps toolbox. Check https://12factor.net/ for more information, it has some background and a detailed explanation each one of the 12 practices.

## The exercises

The proposed exercises will help you to understand the practices desribed by **12 factor** in a practical way.

### Katas or Koans?

The exercices have kind of koan spirit, as for each **12 factor** there is a test that is going to pass once the the factor has been understood and applied to the code.

The exercices feels also like a kata, because there is not a single solution and there are some restrictions to take into consideration for solving the exercise.

From here, we are going to call the execises **katakoans** ( we accept sugerences on the name :) )

## How does this work?

Ok so, in one hand we have a very simple app, an http endpoint that it's not **12 factor** compliant, in the other hand we have a test harness, with a series of tests that covers each one of the **12 factors*, ( one or multiple tests for each factor ). 

The objective is to modify the provided application so all the tests are green, meaning that the app is then **12 factor** compliant.

It is important to do the katakoans in order and one by one, the order is important as there are some factors easier to undestan/assimilate/apply when you already completed some others first.

### Behind the scenes

The **12 factor** dojo's flow is managed by a test harness based on docker-compose and **RSpec**, it will build a docker image with the app, we will call this image the SUT ( Subject Under Test ), then the harness will spin up a docker test environment with all required dependencies and it will run a seires of tests against the SUT image that will validate if it's 12 factor compliant.

Tests run in an always fresh docker environment using DIND ( Docker In Docker )

## Which DevOps-fu 🥋 level is needed to complete the katakoans?

As in every dojo, all DevOps-fu 🥋 levels are welcomed, but there are some exercices that deals with advanced concepts, so don't hesitate to ask for help if you need to.

## What do I need to start?

You only need to have Docker 🐳 and some code editor installed in your machine to be able to execute and validate the exercises.

Also it's is highly recommended to have read 🤓 the **12 factor** first.

## Hajime!! ( let's go )

First clone this repository:

```
git clone https://github.com/llunaplanet/12factor-dojo.git
```

The following command is going to prepare the test environment, it's going to build some docker images with the tools needed to lauch the tests ( docker-compose, RSpec ):

```
cd 12factor-dojo
make setup
```
This command if going to start the test environment and prepare some helper tools:

```
make hajime
```

Finally, as we are inside a DIND environment, we need to build one last docker image and we will be ready to start.

Execute the following command from the dojo's shell ( /dojo # ):

```
make prepare
```
So now you are set to start practicing the katakoans:

Start by executing the first test with the following command:

```
$ make test3
```
El objetivo es que el test pase en verde, lee el resultado y piensa cómo puedes modificar la aplicación para conseguirlo, en algunos casos no hay una sola solución. 
Remeber that the objective is the tests to pass a go green, so read the test result and think how can you modify the app for the test to pass, in some cases there is not only one solution.

> You can explore the test environment ( docker-compose files ) in the `test/scenarios` folder, and the tests themselves in the `test/spec` folder

### Troubleshooting

You can use the built in `logs <factor number>` command to check the docker-compose output, sometimes you will see some errors in the test output that are not very friendly/descriptive and it's necesary to dig a little deeper, so this command will help you with that.

For cleaning the logs, use `clean <factor number>` command

### The katakoans list

This is the actual list of katakoans and the command that triggers each test:

> IMPORTANT: The exercises have been designed to be completed in order

> IMPORTANT: In some of the katakoans you will need to execute an extra command to add new functionality to the app's code, this may cause some git trouble, but this is also useful to pratice your git-fu ;)

 - III. Store config in the environment    
	 - `make test3`
 - IV. Backing services
   - `make patch4` ( Execute only once )
   - `make test4`
 - V. Strictly separate build and run stages
   - `make test5`
 - VI. Procceses
   - `make patch6` ( Execute only once )
   - `make test6`
 - XI. Treat logs as event streams
   - `make patch11` ( Execute only once )
   - `make test11`
 - IX. Maximize robustness with fast startup and graceful shutdown
   - `make patch9` ( Execute only once )
   - `make test9`
   
Once you have completed all the exercices individually you can execute `make test-all` to run the complete test suite in one run.

### Some restrictions

- The only code you can modify are the files in the `app` folder, if you modify any other file, you are cheating! 
- Some katakoans have aditional restrictions

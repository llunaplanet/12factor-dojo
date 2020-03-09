// index.js

/**
 * Required External Modules
 */

const express = require("express");
const session = require("express-session");
const path = require("path");
const redis = require("redis");
const winston = require('winston');
const nats = require('nats');

const error_logger = winston.createLogger({
  level: 'error',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log'})
  ]
});

/**
 * External services configuration
 */

redis_client = redis.createClient(process.env.REDIS_URI);

redis_client.on("error", function (err) {
  console.log("Error " + err);
});

redis_client.on("ready", function (err) {
  redis_client.set("masuno", 0);
});

var nc = nats.connect({
  'url': process.env.NATS_URI,
  'maxReconnectAttempts': -1,
  'reconnectTimeWait': 250,
  'waitOnFirstConnect': true
});

nc.on('error', function(err) {
	console.log(err);
});

/**
 * App Variables
 */

const app = express();
const port = process.env.PORT || "8000";

/**
 *  App Configuration
 */

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "pug");
app.use(express.static(path.join(__dirname, "public")));

app.set("mot", process.env.MOT)

app.use(
  session({
    resave: false,
    saveUninitialized: true,
    secret: '12factordojo'
  })
)

/**
 * Routes Definitions
 */

app.get("/saludos", (req, res) => {
  res.status(200).send(app.get("mot"));
});

/**
 * Rutas para el factor4
 */

app.get("/masuno", (req, res) => {
  redis_client.get("masuno", function(err, masuno) {
    masuno++
    redis_client.set("masuno", masuno);
    res.status(200).send("Contador: " + masuno);
  });
});

/**
 * Rutas para el factor6
 */
 
app.get("/diminombre", (req, res) => {
  req.session.user_name = req.query.nombre
  res.status(200).send("Hola " + req.query.nombre + ", encantado de conocerte");
});

app.get("/quiensoy", (req, res) => {
  res.status(200).send(req.session.user_name);
});

/**
* Rutas para el factor9
*/

app.get("/encolame", (req, res) => {

  nc.publish('foo', 'Hello World!', function() {
    res.status(200).send("Mensaje enviado a la cola");
  });

});

/**
* Rutas para el factor11
*/

app.get("/dameun500", (req, res) => {
  throw new Error('Toma un 500!');
});

app.use(function(err, req, res, next) {
  error_logger.error(err.stack);
  res.status(500).send('Toma 500!');
});

/**
 * Server Activation
 */

app.listen(port, () => {
  console.log(`Listening to requests on ${port}`);
});

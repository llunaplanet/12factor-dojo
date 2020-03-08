// index.js

/**
 * Required External Modules
 */

const express = require("express");
const session = require("express-session");
const path = require("path");
const redis = require("redis");

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
 
/**
* Rutas para el factor9
*/

/**
* Rutas para el factor11
*/

/**
 * Server Activation
 */

app.listen(port, () => {
  console.log(`Listening to requests on ${port}`);
});

// index.js

/**
 * Required External Modules
 */

const express = require("express");
const session = require("express-session");
const path = require("path");

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

app.set("mot", "Cheee nano!")

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
})

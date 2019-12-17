// index.js

/**
 * Required External Modules
 */

const express = require("express");
const express = require("express-session");
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
 * Routes para el factor6
 */

/**
 * Server Activation
 */

app.listen(port, () => {
  console.log(`Listening to requests on ${port}`);
});

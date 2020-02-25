package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	api := echo.New()
	api.Use(middleware.Logger())

	os.Setenv("mot", "Cheee go nano!")

	api.Static("/", "public")

	/**
	 * Routes Definitions
	 */

	api.GET("/saludos", func(c echo.Context) error {
		return c.String(http.StatusOK, os.Getenv("mot"))
	})

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

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	api.Logger.Fatal(api.Start(fmt.Sprintf(":%v", port)))
}

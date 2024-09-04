package main

import (
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/filesystem"
)

const (
	appName    = "Web"
	apiVersion = "v1"
	port       = ":3000"
)

func main() {

	app := fiber.New(fiber.Config{
		AppName: appName,
	})
	defer app.Shutdown()

	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowHeaders: "*",
	}))

	app.All("/*", filesystem.New(filesystem.Config{
		Root:         http.Dir("./dist"),
		NotFoundFile: "index.html",
		Index:        "index.html",
	}))

	if err := app.Listen(port); err != nil {
		panic(err)
	}
}

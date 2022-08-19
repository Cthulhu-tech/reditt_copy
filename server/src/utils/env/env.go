package env

import (
	"log"

	"github.com/joho/godotenv"
)

func Envload(_path string) {

	if err := godotenv.Load(_path); err != nil {
		log.Print("No .env file found")
	}

}

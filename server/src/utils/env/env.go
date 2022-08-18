package env

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

func Envload() {

	if err := godotenv.Load("../../.env"); err != nil {
		log.Print("No .env file found")
	}

	fmt.Println("env %s", os.Getenv("USERNAME"))

}

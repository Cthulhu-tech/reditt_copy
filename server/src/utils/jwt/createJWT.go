package jwt_server

import (
	"fmt"
	"os"
	"time"

	"github.com/dgrijalva/jwt-go"
)

func CreateJWT(duration int) (string, error) {

	token := jwt.New(jwt.SigningMethodHS256)

	claims := token.Claims.(jwt.MapClaims)

	claims["iat"] = time.Now().Unix()

	claims["exp"] = time.Now().Add(time.Hour * time.Duration(duration)).Unix()

	tokenStr, err := token.SignedString([]byte(os.Getenv("JWT_SECRET")))

	if err != nil {

		fmt.Println(err.Error())

		return "", err

	}

	return tokenStr, nil

}

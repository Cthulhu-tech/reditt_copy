package jwt_server

import (
	"net/http"
	"os"

	"github.com/dgrijalva/jwt-go"
)

func GetToken(r *http.Request) (*http.Cookie, error) {

	cookie, err := r.Cookie("refresh")

	return cookie, err

}

func CheckToken(r *http.Request) (bool, string) {

	claims := jwt.MapClaims{}

	cookie, err := GetToken(r)

	if err != nil {

		return false, ""

	}

	_token, _ := jwt.ParseWithClaims(cookie.Value, claims, func(token *jwt.Token) (interface{}, error) {

		return []byte(os.Getenv("JWT_SECRET")), nil

	})

	if claims, ok := _token.Claims.(jwt.MapClaims); ok {

		user := claims["user"].(string)

		return _token.Valid, user

	} else {

		return false, ""

	}

}

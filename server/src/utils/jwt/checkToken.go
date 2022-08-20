package jwt_server

import (
	"net/http"
	"os"

	"github.com/dgrijalva/jwt-go"
)

func CheckToken(r *http.Request) bool {

	cookie, err := r.Cookie("refresh")

	if err != nil {

		return false

	} else {

		_token, _ := jwt.Parse(cookie.Value, func(token *jwt.Token) (interface{}, error) {

			return []byte(os.Getenv("JWT_SECRET")), nil

		})

		return _token.Valid

	}

}

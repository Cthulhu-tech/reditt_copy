package jwt_server

import (
	"errors"
	"net/http"
	"os"
	"strings"

	"github.com/dgrijalva/jwt-go"
)

func GetRefreshToken(r *http.Request) (*http.Cookie, error) {

	cookie, err := r.Cookie("refresh")

	return cookie, err

}

func CheckToken(r *http.Request, tokenValue string) (bool, string) {

	claims := jwt.MapClaims{}

	_token, _ := jwt.ParseWithClaims(tokenValue, claims, func(token *jwt.Token) (interface{}, error) {

		return []byte(os.Getenv("JWT_SECRET")), nil

	})

	if claims, ok := _token.Claims.(jwt.MapClaims); ok {

		user := claims["user"].(string)

		return _token.Valid, user

	} else {

		return false, ""

	}

}

func GetBearerToken(r *http.Request) (string, error) {

	reqToken := r.Header.Get("Authorization")

	splitToken := strings.Split(reqToken, "Bearer ")

	reqToken = splitToken[1]

	if len(splitToken) != 2 {

		return "", errors.New("unavailable")

	} else {

		return reqToken, nil

	}

}

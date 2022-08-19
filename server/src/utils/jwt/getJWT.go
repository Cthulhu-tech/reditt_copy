package jwt_server

import (
	"fmt"
	"net/http"
)

var api_key = "1234"

func GetJwt(w http.ResponseWriter, r *http.Request) {

	if r.Header["Access"] != nil {

		if r.Header["Access"][0] != api_key {

			return

		} else {

			token, err := CreateJWT(168)

			if err != nil {

				return

			}

			fmt.Fprint(w, token)

		}
	}
}

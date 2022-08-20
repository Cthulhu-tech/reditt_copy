package jwt_server

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func SetAccessToken(w http.ResponseWriter, r *http.Request, duration int, user string) {

	accessToken, err := CreateJWT(duration, user)

	if err != nil {

		fmt.Println(err.Error())

	}

	token := &Token{Token: accessToken, User: user, Login: true}

	jwt_token, _ := json.Marshal(token)

	w.Header().Set("Content-Type", "application/json")

	w.WriteHeader(200)

	w.Write(jwt_token)

}

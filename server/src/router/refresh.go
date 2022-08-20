package routerHandler

import (
	"net/http"

	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
)

func refresh(w http.ResponseWriter, r *http.Request) {

	var user = ""
	var duration = 168

	refreshToken, err := jwt_server.CreateJWT(duration, "user")

	if err != nil {
		ErrorHandler(w, "Server Error", 500)
		return
	}

	jwt_server.SetRefreshToken(w, r, duration, refreshToken)
	jwt_server.SetAccessToken(w, r, 1, user)

}

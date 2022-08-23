package middelwear

import (
	"net/http"

	errorHTTP "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/errorHandler"
	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
	"github.com/gorilla/context"
)

func CheckAuth(next http.Handler) http.HandlerFunc {

	return func(w http.ResponseWriter, r *http.Request) {

		token, err := jwt_server.GetBearerToken(r)

		if err != nil {

			errorHTTP.ErrorHandler(w, "Need authorization", 403)

			return

		}

		check, name := jwt_server.CheckToken(r, token)

		if check {

			context.Set(r, "username", name)

			next.ServeHTTP(w, r)

		} else {

			errorHTTP.ErrorHandler(w, "Need authorization", 403)

			return

		}

	}

}

package routerHandler

import (
	"net/http"

	errorHTTP "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/errorHandler"
)

func serverError(w http.ResponseWriter) {

	errorHTTP.ErrorHandler(w, "Need refresh token", 400)

}

func allFields(w http.ResponseWriter){

	errorHTTP.ErrorHandler(w, "Please fill in all fields", 400)

}
package routerHandler

import "net/http"

func ErrorHandler(w http.ResponseWriter, _error string, _status int) {

	http.Error(w, _error, _status)

}

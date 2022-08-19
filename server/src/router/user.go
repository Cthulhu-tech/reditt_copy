package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func user(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	login := vars["login"]

	response := fmt.Sprintf("user login: %s", login)

	fmt.Fprint(w, response)

}

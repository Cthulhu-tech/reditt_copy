package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func UserSaved(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	page := vars["page"]

	login := vars["login"]

	response := fmt.Sprintf("user login: %s, page: %s. saved", login, page)

	fmt.Fprint(w, response)

}

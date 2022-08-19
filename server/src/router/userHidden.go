package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func userHidden(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	page := vars["page"]

	login := vars["login"]

	response := fmt.Sprintf("user login: %s, page: %s. hidden", login, page)

	fmt.Fprint(w, response)

}

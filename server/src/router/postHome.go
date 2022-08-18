package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func PostHome(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	page := vars["page"]

	response := fmt.Sprintf("post page: %s", page)

	fmt.Fprint(w, response)

}

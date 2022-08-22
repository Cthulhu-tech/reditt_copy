package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func subredditPage(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	page := vars["page"]

	name := vars["name"]

	response := fmt.Sprintf("subredit page: %s, name: %s", page, name)

	fmt.Fprint(w, response)

}

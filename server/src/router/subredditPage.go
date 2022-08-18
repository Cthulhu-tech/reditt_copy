package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func SubredditPage(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	page := vars["page"]

	response := fmt.Sprintf("subredit page: %s", page)

	fmt.Fprint(w, response)

}

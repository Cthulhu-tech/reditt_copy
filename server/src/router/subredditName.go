package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func SubredditName(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	name := vars["name"]

	response := fmt.Sprintf("subredit name: %s", name)

	fmt.Fprint(w, response)

}

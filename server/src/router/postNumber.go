package routerHandler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func postNumber(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	id := vars["id"]

	response := fmt.Sprintf("post №%s", id)

	fmt.Fprint(w, response)

}

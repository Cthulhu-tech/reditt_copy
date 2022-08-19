package routerHandler

import (
	"fmt"
	"net/http"
)

func lagout(w http.ResponseWriter, r *http.Request) {

	response := fmt.Sprintf("lagout")

	fmt.Fprint(w, response)

}

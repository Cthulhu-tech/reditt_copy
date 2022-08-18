package routerHandler

import (
	"fmt"
	"net/http"
)

func Registration(w http.ResponseWriter, r *http.Request) {

	response := fmt.Sprintf("registration")

	fmt.Fprint(w, response)

}

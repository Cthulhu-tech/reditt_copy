package routerHandler

import (
	"fmt"
	"net/http"
)

func Login(w http.ResponseWriter, r *http.Request) {

	response := fmt.Sprintf("login")

	fmt.Fprint(w, response)

}

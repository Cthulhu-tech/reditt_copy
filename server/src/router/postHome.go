package routerHandler

import (
	"fmt"
	"net/http"
)

func postHome(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "PostHome")

}

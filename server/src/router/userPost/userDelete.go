package userPost

import (
	"fmt"
	"net/http"
)

func UserDelete(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user delete")

}

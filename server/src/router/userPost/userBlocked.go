package userPost

import (
	"fmt"
	"net/http"
)

func UserBlocked(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user blocked")

}

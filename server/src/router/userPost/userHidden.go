package userPost

import (
	"fmt"
	"net/http"
)

func UserHidden(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user hidden")

}

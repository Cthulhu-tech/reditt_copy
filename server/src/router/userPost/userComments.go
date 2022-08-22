package userPost

import (
	"fmt"
	"net/http"
)

func UserComments(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user comments")

}

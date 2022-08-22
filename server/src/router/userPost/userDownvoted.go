package userPost

import (
	"fmt"
	"net/http"
)

func UserDownvoted(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user downvoted")

}

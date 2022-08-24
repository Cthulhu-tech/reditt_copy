package userPost

import (
	"fmt"
	"net/http"
)

func UserDislikePost(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user like message")

}

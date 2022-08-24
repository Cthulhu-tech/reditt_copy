package userPost

import (
	"fmt"
	"net/http"
)

func UserLikePost(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user like message")

}

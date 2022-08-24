package userPost

import (
	"fmt"
	"net/http"
)

func UserLikeMessage(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user like")

}

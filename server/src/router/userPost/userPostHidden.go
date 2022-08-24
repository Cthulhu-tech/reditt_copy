package userPost

import (
	"fmt"
	"net/http"
)

func UserHiddenPost(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user hidden post")

}

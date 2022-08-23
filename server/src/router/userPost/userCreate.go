package userPost

import (
	"fmt"
	"net/http"
)

func UserCreatePost(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user create post")

}

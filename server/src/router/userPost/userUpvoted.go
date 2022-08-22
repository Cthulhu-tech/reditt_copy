package userPost

import (
	"fmt"
	"net/http"
)

func UserUpvoted(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user upvoted")

}

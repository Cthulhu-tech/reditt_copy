package userPost

import (
	"fmt"
	"net/http"
)

func UserDislikeMessage(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user dislike message")

}

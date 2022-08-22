package userPost

import (
	"fmt"
	"net/http"
)

func UserSubmited(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user submited")

}

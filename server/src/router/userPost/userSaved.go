package userPost

import (
	"fmt"
	"net/http"
)

func UserSaved(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user saved")

}

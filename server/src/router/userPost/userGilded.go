package userPost

import (
	"fmt"
	"net/http"
)

func UserGilded(w http.ResponseWriter, r *http.Request) {

	fmt.Fprint(w, "user gilded")

}

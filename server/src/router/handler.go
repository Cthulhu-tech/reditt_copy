package routerHandler

import (
	"fmt"
	"net/http"
)


func ProductsHandler(w http.ResponseWriter, r *http.Request) {


    response := fmt.Sprintf("Product");

    fmt.Fprint(w, response);

}

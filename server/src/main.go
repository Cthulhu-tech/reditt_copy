package main

import (
    "fmt"
    "net/http"
    "github.com/gorilla/mux"
    "github.com/Cthulhu-tech/router"

)
 
func main() {
      
    router := mux.NewRouter();

    router.HandleFunc("/", routerHandler.ProductsHandler)

    http.Handle("/",router)
 
    http.ListenAndServe(":8181", nil)
}

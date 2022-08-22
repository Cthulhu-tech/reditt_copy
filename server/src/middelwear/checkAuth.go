package middelwear

import (
	"log"
	"net/http"
)

func CheckAuth(next http.Handler) http.HandlerFunc {

	return func(w http.ResponseWriter, r *http.Request) {

		log.Printf("userHandler")

		next.ServeHTTP(w, r)

	}

}

package routerHandler

import (
	"net/http"

	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/middelwear"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/router/userGet"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/router/userPost"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

func HandlerRouter() {

	router := mux.NewRouter()

	jwtHandler := router.PathPrefix("/").Subrouter()

	jwtHandler.HandleFunc("/post/create", userPost.UserCreatePost).Methods("POST")
	jwtHandler.HandleFunc("/post/hidden", userPost.UserHiddenPost).Methods("POST")

	jwtHandler.HandleFunc("/likeMessage", userPost.UserLikeMessage).Methods("POST")
	jwtHandler.HandleFunc("/dislikeMessage", userPost.UserDislikeMessage).Methods("POST")

	jwtHandler.HandleFunc("/likePost", userPost.UserLikePost).Methods("POST")
	jwtHandler.HandleFunc("/dislikePost", userPost.UserDislikePost).Methods("POST")

	jwtHandler.HandleFunc("/saved/update", userPost.UserSaved).Methods("POST")
	jwtHandler.HandleFunc("/delete/update", userPost.UserDelete).Methods("POST")
	jwtHandler.HandleFunc("/hidden/update", userPost.UserHidden).Methods("POST")
	jwtHandler.HandleFunc("/gilded/update", userPost.UserGilded).Methods("POST")
	jwtHandler.HandleFunc("/blocked/update", userPost.UserBlocked).Methods("POST")
	jwtHandler.HandleFunc("/upvoted/update", userPost.UserUpvoted).Methods("POST")
	jwtHandler.HandleFunc("/comments/update", userPost.UserComments).Methods("POST")
	jwtHandler.HandleFunc("/submited/update", userPost.UserSubmited).Methods("POST")
	jwtHandler.HandleFunc("/downvoted/update", userPost.UserDownvoted).Methods("POST")

	router.HandleFunc("/login", login).Methods("POST")               // end
	router.HandleFunc("/lagout", lagout).Methods("POST")             // end
	router.HandleFunc("/refresh", refresh).Methods("POST")           // end
	router.HandleFunc("/registration", registration).Methods("POST") // end

	router.HandleFunc("/user/{login:[a-zA-Z]+}", userGet.User).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/{page:[0-9]+}", userGet.UserPost).Methods("GET")

	router.HandleFunc("/user/{login:[a-zA-Z]+}/delete", userGet.UserDelete).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/saved/{page:[0-9]+}", userGet.UserSaved).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/hidden/{page:[0-9]+}", userGet.UserHidden).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/gilded/{page:[0-9]+}", userGet.UserGilded).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/blocked/{page:[0-9]+}", userGet.UserBlocked).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/upvoted/{page:[0-9]+}", userGet.UserUpvoted).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/comments/{page:[0-9]+}", userGet.UserComments).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/submited/{page:[0-9]+}", userGet.UserSubmited).Methods("GET")
	router.HandleFunc("/user/{login:[a-zA-Z]+}/downvoted/{page:[0-9]+}", userGet.UserDownvoted).Methods("GET")

	router.HandleFunc("/post/{id:[0-9]+}", postNumber).Methods("GET") // end

	router.HandleFunc("/subreddit/{name:[a-zA-Z_]+}", subredditName).Methods("GET")
	router.HandleFunc("/subreddit/{name:[a-zA-Z_]+}/{page:[0-9]+}", subredditPage).Methods("GET") // end

	handler := cors.New(cors.Options{
		AllowCredentials: true,
		AllowedOrigins:   []string{"http://localhost:3000", "http://localhost", "http://localhost:3000/"},
		AllowedMethods: []string{
			http.MethodGet,
			http.MethodPost,
			http.MethodPut,
			http.MethodPatch,
			http.MethodDelete,
			http.MethodOptions,
			http.MethodHead,
		},
		AllowedHeaders: []string{"*"},
	}).Handler(router)

	middelwear.CheckAuth(jwtHandler)

	http.Handle("/", handler)

	http.ListenAndServe(":4000", nil)

}

package main

import (
	"net/http"

	"github.com/gorilla/mux"
)

func main() {

	router := mux.NewRouter()

	router.HandleFunc("/user/{login:[a-zA-Z]+}/comments/{page:[0-9]+}", routerHandler.UserComments)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/submited/{page:[0-9]+}", routerHandler.UserSubmited)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/gilded/{page:[0-9]+}", routerHandler.UserGilded)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/upvoted/{page:[0-9]+}", routerHandler.UserUpvoted)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/downvoted/{page:[0-9]+}", routerHandler.UserDownvoted)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/hidden/{page:[0-9]+}", routerHandler.UserHidden)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/saved/{page:[0-9]+}", routerHandler.UserSaved)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/delete", routerHandler.UserDelete)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/blocked/{page:[0-9]+}", routerHandler.UserBlocked)

	router.HandleFunc("/user/{login:[a-zA-Z]+}", routerHandler.User)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/{page:[0-9]+}", routerHandler.UserPost)

	router.HandleFunc("/login", routerHandler.Login)
	router.HandleFunc("/lagout", routerHandler.Lagout)
	router.HandleFunc("/registration", routerHandler.Registration)

	router.HandleFunc("/post/{id:[0-9]+}", routerHandler.PostNumber)
	router.HandleFunc("/post/home/{page:[0-9]+}", routerHandler.PostHome)

	router.HandleFunc("/subreddit/{page:[0-9]+}", routerHandler.SubredditPage)
	router.HandleFunc("/subreddit/{name:[a-zA-Z]+}", routerHandler.SubredditName)

	http.Handle("/", router)

	http.ListenAndServe(":4000", nil)
}

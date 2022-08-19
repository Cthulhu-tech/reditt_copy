package routerHandler

import (
	"net/http"

	"github.com/gorilla/mux"
)

func HandlerRouter() {

	router := mux.NewRouter()

	router.HandleFunc("/user/{login:[a-zA-Z]+}/comments/{page:[0-9]+}", userComments)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/submited/{page:[0-9]+}", userSubmited)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/gilded/{page:[0-9]+}", userGilded)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/upvoted/{page:[0-9]+}", userUpvoted)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/downvoted/{page:[0-9]+}", userDownvoted)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/hidden/{page:[0-9]+}", userHidden)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/saved/{page:[0-9]+}", userSaved)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/delete", userDelete)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/blocked/{page:[0-9]+}", userBlocked)

	router.HandleFunc("/user/{login:[a-zA-Z]+}", user)
	router.HandleFunc("/user/{login:[a-zA-Z]+}/{page:[0-9]+}", userPost)

	router.HandleFunc("/login", login)
	router.HandleFunc("/lagout", lagout)
	router.HandleFunc("/refresh", refresh)
	router.HandleFunc("/registration", registration)

	router.HandleFunc("/post/{id:[0-9]+}", postNumber)
	router.HandleFunc("/post/home/{page:[0-9]+}", postHome)

	router.HandleFunc("/subreddit/{page:[0-9]+}", subredditPage)
	router.HandleFunc("/subreddit/{name:[a-zA-Z]+}", subredditName)

	http.Handle("/", router)

	http.ListenAndServe(":4000", nil)

}

package routerHandler

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
	"github.com/gorilla/mux"
)

func subredditName(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	name := vars["name"]

	db := mysql.GetDB()

	rows, err := db.Query("SELECT * FROM group_reddit WHERE title = ?", name)

	if err != nil {

		log.Print(err.Error())

	}

	subreddits := []SubRedditConvert{}

	for rows.Next() {

		var subreddit = SubReddit{}

		if err := rows.Scan(&subreddit.Id, &subreddit.Avatar, &subreddit.Title, &subreddit.Description, &subreddit.Backround); err != nil {

			log.Println(err.Error())

		}

		var conver = SubRedditConvert{
			Id:          subreddit.Id.Int64,
			Avatar:      subreddit.Avatar.String,
			Title:       subreddit.Title.String,
			Description: subreddit.Description.String,
			Backround:   subreddit.Backround.String,
		}

		subreddits = append(subreddits, conver)

	}

	_subreddit, _ := json.Marshal(subreddits)

	w.Header().Set("Content-Type", "application/json")

	w.WriteHeader(200)

	w.Write(_subreddit)

}

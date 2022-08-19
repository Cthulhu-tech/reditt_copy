package routerHandler

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
	"github.com/gorilla/mux"
)

func postHome(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	page := vars["page"]

	var db = mysql.GetDB()

	rows, err := db.Query("CALL sp_get_all_message_in_post(?)", page)

	if err != nil {

		panic(err.Error())

	}

	posts := []PostDataConvert{}

	for rows.Next() {

		var post PostData

		if err := rows.Scan(&post.Message_ID, &post.User, &post.Message, &post.Prev, &post.Next, &post.Reward); err != nil {

			log.Println(err.Error())

		}

		var convertPostData PostDataConvert

		convertPostData.Message_ID = post.Message_ID
		convertPostData.User = post.User
		convertPostData.Message = post.Message.String
		convertPostData.Prev = post.Prev.Int64
		convertPostData.Next = post.Next.Int64

		posts = append(posts, convertPostData)

	}

	if err != nil {

		log.Println(err.Error())

	}

	db.Close()

	w.Header().Set("Content-Type", "application/json")

	_posts, _ := json.Marshal(posts)

	w.Write(_posts)

}

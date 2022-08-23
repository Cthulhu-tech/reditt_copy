package routerHandler

import (
	"encoding/json"
	"log"
	"net/http"

	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
	"github.com/gorilla/mux"
)

func postNumber(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)

	id := vars["id"]

	var db = mysql.GetDB()

	valid, user := jwt_server.CheckToken(r)

	if !valid {

		user = ""

	}

	rows, err := db.Query("CALL sp_get_all_message_in_post(?, ?)", id, user)

	if err != nil {

		panic(err.Error())

	}

	posts := []PostDataConvert{}

	for rows.Next() {

		var post PostData

		if err := rows.Scan(&post.Message_ID, &post.User, &post.Message, &post.Prev, &post.Next, &post.Reward, &post.Value, &post.Rating); err != nil {

			log.Println(err.Error())

		}

		var convertPostData PostDataConvert

		convertPostData.Message_ID = post.Message_ID
		convertPostData.User = post.User
		convertPostData.Message = post.Message.String
		convertPostData.Value = post.Value.Int64
		convertPostData.Rating = post.Rating.Int64

		var arrayNumber []int

		if post.Next.Valid {

			err := json.Unmarshal([]byte(post.Next.String), &arrayNumber)

			if err != nil {

				log.Print(err.Error())

			}

			convertPostData.Next = arrayNumber

		}

		if post.Prev.Valid {

			err := json.Unmarshal([]byte(post.Prev.String), &arrayNumber)

			if err != nil {

				log.Print(err.Error())

			}

			convertPostData.Prev = arrayNumber

		}

		var reward []Reward

		if post.Reward.Valid {

			err := json.Unmarshal([]byte(post.Reward.String), &reward)

			if err != nil {

				log.Print(err.Error())

			}

			convertPostData.Reward = reward

		}

		posts = append(posts, convertPostData)

	}

	if err != nil {

		log.Println(err.Error())

	}

	defer rows.Close()

	w.Header().Set("Content-Type", "application/json")

	_posts, _ := json.Marshal(posts)

	w.Write(_posts)

}

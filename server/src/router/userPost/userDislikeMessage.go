package userPost

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	errorHTTP "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/errorHandler"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
	"github.com/gorilla/context"
)

func UserDislikeMessage(w http.ResponseWriter, r *http.Request) {

	var userId string = ""

	valueCtx, ok := context.GetOk(r, "userId")

	if ok {

		userId = fmt.Sprintf("%v", valueCtx)

	}

	body, err := ioutil.ReadAll(r.Body)

	defer r.Body.Close()

	if err != nil {
		errorHTTP.ErrorHandler(w, "Server Error", 500)
		return
	}

	var idMessage BodyDataLikeOrDislike

	err = json.Unmarshal(body, &idMessage)

	var db = mysql.GetDB()

	rows, err := db.Query(`sp_dislike_message(?, ?)`, userId, idMessage.Id)

	defer rows.Close()

	if err != nil {
		errorHTTP.ErrorHandler(w, "Login or Password is not valid", 401)
		return
	}

	defer context.Clear(r)

}

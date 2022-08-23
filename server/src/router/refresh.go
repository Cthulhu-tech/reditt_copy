package routerHandler

import (
	"log"
	"net/http"

	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/errorHandler"
	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
)

func refresh(w http.ResponseWriter, r *http.Request) {

	var duration = 168

	cookie, err := jwt_server.GetRefreshToken(r)

	if err != nil {

		serverError(w)

		return
	}

	find, user := jwt_server.CheckToken(r, cookie.Value)

	if find {

		db := mysql.GetDB()

		rows, err := db.Query("CALL `sp_find_user_in_login`(?)", user)

		if err != nil {

			serverError(w)

			return
		}

		defer rows.Close()

		counts := CountUsersId{}

		for rows.Next() {

			var count CountUsersId

			if err := rows.Scan(&count.Count, &count.Id); err != nil {
				log.Println(err.Error())
			}

			counts.Id = count.Id
			counts.Count = count.Count

		}

		if counts.Count == 0 {
			errorHTTP.ErrorHandler(w, "User not found", 403)
			return
		}

		refreshToken, err := jwt_server.CreateJWT(duration, user)

		if err != nil {
			serverError(w)
			return
		}

		if err != nil {
			serverError(w)
			return
		}

		_, err = db.Query("DELETE FROM token WHERE token = ?", cookie.Value)

		if err != nil {
			serverError(w)
			return
		}

		_, err = db.Query("INSERT INTO token (user_id, token) VALUES (?, ?)", counts.Id, refreshToken)

		if err != nil {
			serverError(w)
			return
		}

		jwt_server.SetRefreshToken(w, r, duration, refreshToken)
		jwt_server.SetAccessToken(w, r, 1, user)

	}

	errorHTTP.ErrorHandler(w, "Cookie not found", 403)
	return

}

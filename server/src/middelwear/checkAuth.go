package middelwear

import (
	"log"
	"net/http"

	errorHTTP "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/errorHandler"
	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"

	"github.com/gorilla/context"
)

func CheckAuth(next http.Handler) http.HandlerFunc {

	return func(w http.ResponseWriter, r *http.Request) {

		token, err := jwt_server.GetBearerToken(r)

		if err != nil {

			errorHTTP.ErrorHandler(w, "Need authorization", 403)

			return

		}

		check, name := jwt_server.CheckToken(r, token)

		if check {

			context.Set(r, "username", name)

			db := mysql.GetDB()

			rows, err := db.Query(`SELECT * FROM user WHERE login = ?`, name)

			defer rows.Close()

			if err != nil {
				errorHTTP.ErrorHandler(w, "Login or Password is not valid", 401)
				return
			}

			posts := User{}

			for rows.Next() {

				var _user User

				if err := rows.Scan(&_user.Id, &_user.Login, &_user.Password, &_user.Create, &_user.Confirmed, &_user.Mail); err != nil {

					log.Println(err.Error())

				}

				posts.Id = _user.Id
				posts.Login = _user.Login
				posts.Password = _user.Password
				posts.Create = _user.Create
				posts.Confirmed = _user.Confirmed
				posts.Mail = _user.Mail

			}

			context.Set(r, "userId", posts.Id)

			next.ServeHTTP(w, r)

		} else {

			errorHTTP.ErrorHandler(w, "Need authorization", 403)

			return

		}

	}

}

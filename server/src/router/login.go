package routerHandler

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	errorHTTP "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/errorHandler"
	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
	passwordHash "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/password"
	"github.com/go-playground/validator/v10"
)

func login(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)

	defer r.Body.Close()

	if err != nil {
		allFields(w)
		return
	}

	var userInfo BodyDataLogin

	err = json.Unmarshal(body, &userInfo)

	if err != nil {
		allFields(w)
		return
	}

	validate := validator.New()

	err = validate.Struct(userInfo)

	if err != nil {
		allFields(w)
		return
	}

	err = validate.Var(strings.ReplaceAll(userInfo.Login, " ", ""), "required,max=18,min=2")

	if err != nil {
		allFields(w)
		return
	}

	err = validate.Var(strings.ReplaceAll(userInfo.Password, " ", ""), "required,min=4")

	if err != nil {
		allFields(w)
		return
	}

	var db = mysql.GetDB()

	rows, err := db.Query(`SELECT * FROM user WHERE login = ?`, userInfo.Login)

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

	check := passwordHash.CheckPasswordHash(userInfo.Password, posts.Password.String)

	if posts.Login.Valid && posts.Password.Valid && posts.Login.String == userInfo.Login && check && posts.Confirmed.Int64 == 1 {

		var duration = 168

		refreshToken, err := jwt_server.CreateJWT(duration, posts.Login.String)

		if err != nil {
			serverError(w)
			return
		}

		db.Query("INSERT INTO token (user_id, token) VALUES (?, ?)", posts.Id.Int64, refreshToken)

		jwt_server.SetRefreshToken(w, r, duration, refreshToken)
		jwt_server.SetAccessToken(w, r, 1, posts.Login.String)

		return

	} else if check && posts.Confirmed.Int64 == 0 {

		errorHTTP.ErrorHandler(w, "Please confirm your account", 401)
		return

	} else {

		errorHTTP.ErrorHandler(w, "Login or Password is not valid", 401)
		return

	}

}

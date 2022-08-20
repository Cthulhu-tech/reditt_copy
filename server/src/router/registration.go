package routerHandler

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
	passwordHash "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/password"
	"github.com/go-playground/validator/v10"
)

func registration(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)

	defer r.Body.Close()

	if err != nil {
		ErrorHandler(w, "Need login or password", 400)
		return
	}

	var userInfo BodyDataRegistration

	err = json.Unmarshal(body, &userInfo)

	if err != nil {
		ErrorHandler(w, "Need login or password", 400)
		return
	}

	validate := validator.New()

	err = validate.Var(strings.ReplaceAll(userInfo.Login, " ", ""), "required,max=18,min=2")

	if err != nil {
		ErrorHandler(w, "Need login or password, mail", 400)
		return
	}

	err = validate.Var(strings.ReplaceAll(userInfo.Password, " ", ""), "required,min=4")

	if err != nil {
		ErrorHandler(w, "Need login or password, mail", 400)
		return
	}

	err = validate.Var(strings.ReplaceAll(userInfo.Mail, " ", ""), "required,min=4")

	if err != nil {
		ErrorHandler(w, "Need login or password, mail", 400)
		return
	}

	var db = mysql.GetDB()

	rows, err := db.Query(`SELECT COUNT(*) count FROM user WHERE login = ?`, userInfo.Login)

	defer rows.Close()

	counts := CountUsers{}

	for rows.Next() {

		var count CountUsers

		if err := rows.Scan(&count.Count); err != nil {

			log.Println(err.Error())

		}

		counts.Count = count.Count

	}

	if counts.Count > 0 {

		ErrorHandler(w, "Login or Mail is already in use", 401)
		return

	} else {

		hashPassword, err := passwordHash.HashPassword(userInfo.Password)

		if err != nil {
			ErrorHandler(w, "Server Error", 500)
			return
		}

		_, err = db.Query(`INSERT INTO user (login, password, create_date, mail) VALUES (?, ?, ?, ?)`, userInfo.Login, hashPassword, time.Now(), userInfo.Mail)

		if err != nil {
			ErrorHandler(w, "Server Error", 500)
			return
		}

		userMessage := &UserCreate{Message: "User create"}

		_userMessage, _ := json.Marshal(userMessage)

		w.Header().Set("Content-Type", "application/json")

		w.WriteHeader(200)

		w.Write(_userMessage)

	}

}

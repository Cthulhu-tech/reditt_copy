package routerHandler

import (
	"net/http"

	jwt_server "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/jwt"
	"github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
)

func lagout(w http.ResponseWriter, r *http.Request) {

	db := mysql.GetDB()

	_cookie, err := jwt_server.GetToken(r)

	_, err = db.Query("DELETE FROM token WHERE token = ?", _cookie.Value)

	if err != nil {
		ErrorHandler(w, "Server Error", 500)
		return
	}

	cookie := &http.Cookie{
		Name:     "refresh",
		Value:    "",
		Path:     "/",
		MaxAge:   -1,
		HttpOnly: true,
	}

	http.SetCookie(w, cookie)

}

package jwt_server

import (
	"net/http"
	"time"
)

func SetRefreshToken(w http.ResponseWriter, r *http.Request, duration int, refreshToken string) {

	expires := time.Now().AddDate(0, 0, duration/24)

	cookie := http.Cookie{Expires: expires, Name: "refresh", HttpOnly: true, Secure: true, MaxAge: duration * 3600, Path: "/"}

	cookie.Value = refreshToken

	http.SetCookie(w, &cookie)

}

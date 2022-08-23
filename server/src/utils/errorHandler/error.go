package errorHTTP

import (
	"encoding/json"
	"net/http"
)

func ErrorHandler(w http.ResponseWriter, _error string, _status int) {

	var Message MessageError

	Message.Error = _error

	msg, _ := json.Marshal(Message)

	http.Error(w, string(msg), _status)

}

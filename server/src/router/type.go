package routerHandler

import (
	"database/sql"
)

type PostData struct {
	Message_ID int64          `json:"message_id"`
	User       string         `json:"user"`
	Message    sql.NullString `json:"message"`
	Prev       sql.NullString `json:"prev_message"`
	Next       sql.NullString `json:"next_message"`
	Reward     sql.NullString `json:"reward"`
}

type PostDataConvert struct {
	Message_ID int64    `json:"message_id"`
	User       string   `json:"user"`
	Message    string   `json:"message"`
	Prev       []int    `json:"prev_message"`
	Next       []int    `json:"next_message"`
	Reward     []Reward `json:"reward"`
}

type Reward struct {
	Reward   string `json:"reward"`
	AllCount int    `json:"all_count"`
}

type BodyDataLogin struct {
	Login    string `json:"login"`
	Password string `json:"password"`
}

type BodyDataRegistration struct {
	Login    string `json:"login"`
	Mail     string `json:"mail"`
	Password string `json:"password"`
}

type User struct {
	Id        sql.NullInt64  `json:"id"`
	Login     sql.NullString `json:"login"`
	Password  sql.NullString `json:"password"`
	Create    sql.NullString `json:"create_date"`
	Confirmed sql.NullInt64  `json:"confirm"`
	Mail      sql.NullString `json:"mail"`
}

type CountUsers struct {
	Count int64 `json:"count"`
}

type CountUsersId struct {
	Count int64 `json:"count"`
	Id    int64 `json:"id"`
}

type UserCreate struct {
	Message string
}

type MessageError struct {
	Error string
}

type SubReddit struct {
	Id          sql.NullInt64  `json:"id"`
	Avatar      sql.NullString `json:"avatars"`
	Title       sql.NullString `json:"title"`
	Description sql.NullString `json:"description"`
	Backround   sql.NullString `json:"backround"`
}

type SubRedditConvert struct {
	Id          int64  `json:"id"`
	Avatar      string `json:"avatars"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Backround   string `json:"backround"`
}

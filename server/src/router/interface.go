package routerHandler

import (
	"database/sql"
)

type PostData struct {
	Message_ID int64          `json:"description"`
	User       string         `json:"user"`
	Message    sql.NullString `json:"message"`
	Prev       sql.NullInt64  `json:"prev_message"`
	Next       sql.NullInt64  `json:"next_message"`
	Reward     sql.NullString `json:"reward"`
}

type PostDataConvert struct {
	Message_ID int64    `json:"description"`
	User       string   `json:"user"`
	Message    string   `json:"message"`
	Prev       int64    `json:"prev_message"`
	Next       int64    `json:"next_message"`
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

type User struct {
	Id        sql.NullInt64  `json:"id"`
	Login     sql.NullString `json:"login"`
	Password  sql.NullString `json:"password"`
	Create    sql.NullString `json:"create_date"`
	Confirmed sql.NullInt64  `json:"confirm"`
	Mail      sql.NullString `json:"mail"`
}

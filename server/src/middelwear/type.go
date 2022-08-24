package middelwear

import "database/sql"

type User struct {
	Id        sql.NullInt64  `json:"id"`
	Login     sql.NullString `json:"login"`
	Password  sql.NullString `json:"password"`
	Create    sql.NullString `json:"create_date"`
	Confirmed sql.NullInt64  `json:"confirm"`
	Mail      sql.NullString `json:"mail"`
}

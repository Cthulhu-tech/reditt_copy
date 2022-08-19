package mysql

import (
	"database/sql"
	"fmt"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

var (db *sql.DB)

func MysqlConnectPool() {

	database, err := sql.Open("mysql", os.Getenv("USERDB")+":"+os.Getenv("PASSWORD")+"@tcp("+os.Getenv("SERVER")+os.Getenv("PORT")+")/"+os.Getenv("DBNAME"))
	
	if err != nil {

		panic(err.Error());

	}else{

		fmt.Println("connecting ready");

	}

	database.SetConnMaxLifetime(time.Minute * 3)
	database.SetMaxOpenConns(10)
	database.SetMaxIdleConns(10)

	db = database;

}

func GetDB() *sql.DB {

    return db;

}

func CloseDB() error {

    return db.Close();

}
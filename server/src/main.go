package main

import (
	routerHandler "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/router"
	env "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/env"
	mysql "github.com/Cthulhu-tech/reditt_copy/tree/master/server/src/utils/mysql"
)

func main() {

	env.Envload(".env")

	mysql.MysqlConnectPool()

	routerHandler.HandlerRouter()

}

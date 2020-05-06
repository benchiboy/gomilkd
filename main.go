// gomilkd project gomilkd.go
package main

import (
	"flag"
	"gomilkd/control/business"
	"gomilkd/control/project"
	"gomilkd/service/dbcomm"
	"log"
	"net/http"

	goconf "github.com/pantsing/goconf"

	"io"
	"os"

	"gopkg.in/natefinch/lumberjack.v2"
)

var (
	http_srv   *http.Server
	dbUrl      string
	listenPort int
	idleConns  int
	openConns  int
)

func init() {
	log.Println("System Paras Init......")
	log.SetFlags(log.Ldate | log.Lshortfile | log.Lmicroseconds)
	log.SetOutput(io.MultiWriter(os.Stdout, &lumberjack.Logger{
		Filename:   "gomilkd.log",
		MaxSize:    500, // megabytes
		MaxBackups: 50,
		MaxAge:     90, //days
	}))
	envConf := flag.String("env", "config-ci.json", "select a environment config file")
	flag.Parse()
	log.Println("config file ==", *envConf)
	c, err := goconf.New(*envConf)
	if err != nil {
		log.Fatalln("读配置文件出错", err)
	}

	//填充配置文件
	c.Get("/config/LISTEN_PORT", &listenPort)
	c.Get("/config/DB_URL", &dbUrl)
	c.Get("/config/OPEN_CONNS", &openConns)
	c.Get("/config/IDLE_CONNS", &idleConns)

}

func go_WebServer() {
	log.Println("Listen Service start...")

	http.HandleFunc("/api/project_add", project.NewProject)
	http.HandleFunc("/api/project_list", project.GetProjectList)
	http.HandleFunc("/api/project_del", project.DelProject)

	http.HandleFunc("/api/business_add", business.NewBusiness)
	http.HandleFunc("/api/business_list", business.GetProjectList)

	http_srv = &http.Server{
		Addr: ":8080",
	}
	log.Printf("listen:")
	if err := http_srv.ListenAndServe(); err != nil {
		log.Printf("listen: %s\n", err)
	}
}

func main() {
	dbcomm.InitDB(dbUrl, idleConns, openConns)
	go_WebServer()
}

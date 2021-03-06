package main

import (
	"flag"
	"log"
	"net"
	"os"

	api "github.com/modoki-paas/modoki-k8s/api"
	"github.com/modoki-paas/modoki-k8s/yamler/config"
	"github.com/modoki-paas/modoki-k8s/yamler/handler"
	"google.golang.org/grpc"
)

type commandArg struct {
	Config string
	Help   bool
}

func (arg *commandArg) Init() {
	flag.BoolVar(&arg.Help, "help", false, "show usage")
	flag.StringVar(&arg.Config, "config", "/etc/modoki/apiserver.yaml", "path to config file")

	flag.Parse()

	if arg.Help {
		flag.Usage()

		os.Exit(1)
	}
}

func main() {
	carg := commandArg{}

	carg.Init()

	cfg, err := config.ReadConfig(carg.Config)

	if err != nil {
		panic(err)
	}

	listener, err := net.Listen("tcp", ":80")
	if err != nil {
		log.Fatalf("failed to listen on :80: %v", err)
	}

	server := grpc.NewServer()
	api.RegisterGeneratorServer(
		server,
		&handler.Handler{
			Config: cfg,
		},
	)

	if err := server.Serve(listener); err != nil {
		log.Fatalf("failed to start server on :80: %v", err)
	}
}

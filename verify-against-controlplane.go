package main

import (
	"io"
	"os"

	"sigs.k8s.io/testing_frameworks/integration"
)

func main() {
	cp := &integration.ControlPlane{}
	cp.Start()
	defer cp.Stop()
	kubeCtl := cp.KubeCtl()
	args := os.Args[1:]
	stdout, stderr, err := kubeCtl.Run(args...)
	if err != nil {
		panic(err)
	}
	io.Copy(os.Stdout, stdout)
	io.Copy(os.Stderr, stderr)
}

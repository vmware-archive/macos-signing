package main

import (
	"io"
	"os"

	"sigs.k8s.io/testing_frameworks/integration"
)

func main() {
	cp := &integration.ControlPlane{}
	cp.Start()
	kubeCtl := cp.KubeCtl()
	stdout, stderr, err := kubeCtl.Run("version")
	if err != nil {
		panic(err)
	}

	io.Copy(os.Stdout, stdout)
	io.Copy(os.Stderr, stderr)

	cp.Stop()
}

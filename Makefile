# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gecho android ios gecho-cross swarm evm all test clean
.PHONY: gecho-linux gecho-linux-386 gecho-linux-amd64 gecho-linux-mips64 gecho-linux-mips64le
.PHONY: gecho-linux-arm gecho-linux-arm-5 gecho-linux-arm-6 gecho-linux-arm-7 gecho-linux-arm64
.PHONY: gecho-darwin gecho-darwin-386 gecho-darwin-amd64
.PHONY: gecho-windows gecho-windows-386 gecho-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gecho:
	build/env.sh go run build/ci.go install ./cmd/gecho
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gecho\" to launch gecho."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gecho.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gecho.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

gecho-cross: gecho-linux gecho-darwin gecho-windows gecho-android gecho-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gecho-*

gecho-linux: gecho-linux-386 gecho-linux-amd64 gecho-linux-arm gecho-linux-mips64 gecho-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-*

gecho-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gecho
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep 386

gecho-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gecho
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep amd64

gecho-linux-arm: gecho-linux-arm-5 gecho-linux-arm-6 gecho-linux-arm-7 gecho-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep arm

gecho-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gecho
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep arm-5

gecho-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gecho
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep arm-6

gecho-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gecho
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep arm-7

gecho-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gecho
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep arm64

gecho-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gecho
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep mips

gecho-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gecho
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep mipsle

gecho-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gecho
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep mips64

gecho-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gecho
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gecho-linux-* | grep mips64le

gecho-darwin: gecho-darwin-386 gecho-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gecho-darwin-*

gecho-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gecho
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-darwin-* | grep 386

gecho-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gecho
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-darwin-* | grep amd64

gecho-windows: gecho-windows-386 gecho-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gecho-windows-*

gecho-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gecho
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-windows-* | grep 386

gecho-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gecho
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gecho-windows-* | grep amd64

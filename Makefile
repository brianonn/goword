.PHONY: all
all: goword

SRCS=$(filter-out %_test.go, $(wildcard *.go */*.go))
TESTSRCS=$(wildcard *_test.go */*_test.go)
EXE=goword

$(EXE): $(SRCS)
	go build -tags spell -v

.PHONY: test
test: test.out
	grep -- "--- PASS" test.out
	grep -- "--- FAIL" test.out || true

test.out: goword $(TESTSRCS)
	go test -tags spell -v >$@ 2>&1 || cat $@

clean:
	@ rm -rf $(EXE)

docker:
	docker build -t goword:latest .

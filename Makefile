.PHONY: all demo clean test

BUILD=dune build
CLEAN= dune clean
TEST=dune runtest -j1 --no-buffer
INSTALL=opam pin add cdds-lwt . 

all:
		${BUILD}

demo:
	make -C demo

test:
		${TEST}

install:
	${INSTALL}

clean:
	${CLEAN}
	make -C demo clean

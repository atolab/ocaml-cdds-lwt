.PHONY: all clean

TARGET=simple.exe
BUILD_DIR=_build/default
BUILD1=dune build ${TARGET}
CLEAN= dune clean

all:
		${BUILD1}

clean:
	${CLEAN}
	$(RM) -f ${TARGET}

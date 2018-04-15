.PHONY: all clean

TARGET=simple.exe
BUILD_DIR=_build/default
BUILD1=jbuilder build --dev ${TARGET}
CLEAN= jbuilder clean

all:
		${BUILD1}

clean:
	${CLEAN}
	$(RM) -f ${TARGET}

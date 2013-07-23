TEMPLATE = lib

RESOURCES = \
	../wolfzilla.qrc
	
isEmpty(QMAKE_RCC) {
    win32:QMAKE_RCC = $$[QT_INSTALL_BINS]\\rcc.exe
    else:QMAKE_RCC = $$[QT_INSTALL_BINS]/rcc
}
rccbinary.input = RESOURCES
rccbinary.output = ${QMAKE_FILE_BASE}.rcc
rccbinary.commands = $$QMAKE_RCC -binary ${QMAKE_FILE_IN} -o ${QMAKE_FILE_BASE}.rcc
rccbinary.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += rccbinary
PRE_TARGETDEPS += compiler_rccbinary_make_all

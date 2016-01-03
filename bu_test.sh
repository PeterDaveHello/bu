#!/usr/bin/env bash

pth="$(dirname $(readlink -f $0))"

. "$pth/config.sh" 2>/dev/null
. "$pth/bu_core.sh"
. "$pth/ColorEchoForShell/dist/ColorEcho.bash"

if [[ -z $BU_TESTS_PATH ]]; then
    if [[ ! -z $_BU_TESTS_PATH ]]; then
        BU_TESTS_PATH="`eval echo $_BU_TESTS_PATH`"
    else
        echo.Red 'no TESTS_PATH config detected'
        exit 1
    fi
fi

if [[ -d $BU_TESTS_PATH ]]; then
    bu_assert_return "ls $BU_TESTS_PATH/*.bu.sh" "0" "No file with extension with *.bu.sh been found under $BU_TESTS_PATH, no test to run!"
else
    echo.Purple 'TESTS_PATH invalid, no test to run!'
    exit 1
fi

bu_init
. "`command ls $BU_TESTS_PATH/*.bu.sh 2>/dev/null`" 2>/dev/null
bu_test_result
exit $(bu_return)

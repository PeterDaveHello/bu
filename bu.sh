pth="$(dirname $BASH_SOURCE)"
. "$pth/ColorEchoForShell/dist/ColorEcho.bash"

function bu_init()
{
    date="date"
    if [ "`uname`" = "FreeBSD" ] || [ "`uname`" = "Darwin" ]; then date="gdate" ; sed="gsed" ; fi
    bu_reset
}

function bu_unix_nano_time()
{
    echo "$(eval $date +%s%N)"
}

function bu_reset()
{
    _bu_time_passed_consumption=0
    _bu_time_failed_consumption=0
    _bu_assert_passed=0
    _bu_assert_failed=0
}

function bu_assert_expect_output()
{
    local expected=$1
    local got=$2
    echo "Expected \"$expected\" but got \"$got\" ..."
}

function bu_assert()
{
    local _bu_assert_start=$(bu_unix_nano_time)
    local _bu_assert_pass=false
    if [ $# -ne 2 ] && [ $# -ne 3 ]; then
        echo "You should give me 2 or 3 arguments!"
    else
        if [ "$(eval $1 2>&1)" = "$2" ]; then
            _bu_assert_passed=$((_bu_assert_passed + 1))
            _bu_assert_pass=true
        else
            _bu_assert_failed=$((_bu_assert_failed + 1))
            if [ -z "$3" ]; then
                bu_assert_expect_output "$2" "`eval $1 2>&1 | $sed ':a;N;$!ba;s/\n/ \\n /g'`"
            else
                echo "$3"
            fi
        fi
    fi
    local _bu_assert_end=$(bu_unix_nano_time)
    local _bu_assert_time_consumption=$((_bu_assert_end - _bu_assert_start))
    if [ "$_bu_assert_pass" = "true" ];then
        _bu_time_passed_consumption=$((_bu_time_passed_consumption + _bu_assert_time_consumption))
    else
        _bu_time_failed_consumption=$((_bu_time_failed_consumption + _bu_assert_time_consumption))
    fi
}

function bu_assert_return()
{
    local _bu_assert_start=$(bu_unix_nano_time)
    local _bu_assert_pass=false
    if [ $# -ne 2 ] && [ $# -ne 3 ]; then
        echo "You should give me 2 or 3 arguments!"
    else
        eval $1 &>/dev/null
        local _bu_assert_exit_code=$?
        if [ $_bu_assert_exit_code -eq $2 2> /dev/null ]; then
            _bu_assert_passed=$((_bu_assert_passed + 1))
            _bu_assert_pass=true
        else
            _bu_assert_failed=$((_bu_assert_failed + 1))
            if [ -z "$3" ]; then
                bu_assert_expect_output $2 $_bu_assert_exit_code
            else
                echo "$3"
            fi
        fi
    fi
    local _bu_assert_end=$(bu_unix_nano_time)
    local _bu_assert_time_consumption=$((_bu_assert_end - _bu_assert_start))
    if [ "$_bu_assert_pass" = "true" ];then
        _bu_time_passed_consumption=$((_bu_time_passed_consumption + _bu_assert_time_consumption))
    else
        _bu_time_failed_consumption=$((_bu_time_failed_consumption + _bu_assert_time_consumption))
    fi
}

function bu_test_result()
{
    echo.Yellow  "Total test ran: $((_bu_assert_failed + _bu_assert_passed))"
    echo.Magenta "Total time consumption: $(bu_nano_sec_to_sec $((_bu_time_passed_consumption + _bu_time_failed_consumption))) sec(s)"
    echo.Green   "Passed test ✓ $_bu_assert_passed"
    echo.Magenta "Time consumption on passed test: $(bu_nano_sec_to_sec $_bu_time_passed_consumption) sec(s)"
    echo.Red     "Failed test ✗ $_bu_assert_failed"
    echo.Magenta "Time consumption on failed test: $(bu_nano_sec_to_sec $_bu_time_failed_consumption) sec(s)"
    echo.Purple  "Passed this round $(bu_is_pass)"
}

function bu_is_pass()
{
    if [ $(bu_return) -eq 0 ]; then
        echo.Green "true"
    elif [ $(bu_return) -eq 2 ]; then
        echo.Orange "no test ran!"
    else
        echo.Red "false"
    fi
}

function bu_return()
{
    if [ $((_bu_assert_failed + _bu_assert_passed)) -eq 0 ]; then
        echo 2
    elif [ $_bu_assert_failed -eq 0 ]; then
        echo 0
    else
        echo 1
    fi
}

function bu_nano_sec_to_sec()
{
    if [ $1 -eq 0 ]; then
        echo 0
    else
        echo $(echo "$1 / 1000000000" | bc -l | $sed -E 's/0+$//g' | $sed 's/^\./0\./g' | $sed 's/\.$//g')
    fi
}

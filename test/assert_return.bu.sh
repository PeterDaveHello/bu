bu_assert_return "echo Hello" "0"

bu_assert_return "bash -c 'exit 1'" "1"

bu_assert_return "saglidfjhlijdfh" "127"

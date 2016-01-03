bu_assert "echo assertion test" "assertion test"

bu_assert "bu_assert 'echo bu_assert assertion test' 'bu_assert assertion test'" ""

bu_assert "bu_assert 'echo match' 'match'" ""

bu_assert "bu_assert 'echo match' 'matchhhh'" 'Expected "matchhhh" but got "match" ...'

bu_assert_ ""


bu_assert "bu_assert_expect_output 123 456" 'Expected "123" but got "456" ...'

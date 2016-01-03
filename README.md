# bu [![Build Status](https://travis-ci.org/PeterDaveHello/bu.svg)](https://travis-ci.org/PeterDaveHello/bu)
simple tool for bash script unit test

![Screenshot](bu.png)

## Usage

Put test scripts in a folder, then run:
```
BU_TESTS_PATH="path/of/folder/to/place/tests" /path/to/bu/bu_test.sh
```

## functions

### bu_assert

```sh
bu_assert "function or command to call" "expected result"
bu_assert "function or command to call" "expected result" "self defined error message"
```

### bu_assert_return

```sh
bu_assert_return "function or command to call" "expected exit code / return code"
bu_assert_return "function or command to call" "expected exit code / return code" "self defined error message"
```

### bu_todo_assert

```sh
bu_todo_assert "function or command to call, but not implmented or not finished yet" "expected result"
```

### bu_todo_assert_return

```sh
bu_todo_assert_return "function or command to call, but not implmented or not finished yet" "expected exit code / return code"
```

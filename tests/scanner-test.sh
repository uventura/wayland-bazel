#!/bin/sh

echo "srcdir: $srcdir"
echo "scanner: $WAYLAND_SCANNER"
echo "test_data_dir: $TEST_DATA_DIR"
echo "test_output_dir: $TEST_OUTPUT_DIR"
echo "pwd: $PWD"
echo "sed: $SED"

RETCODE=0

hard_fail() {
	echo "$@" "ERROR"
	exit 99
}

fail() {
	echo "$@" "FAIL"
	RETCODE=1
}

mkdir -p "$TEST_OUTPUT_DIR" || hard_fail "setup"

generate_and_compare() {
	echo
	echo "Testing $1 generation: $2 -> $3"

	"$WAYLAND_SCANNER" $1 < "$TEST_DATA_DIR/$2" > "$TEST_OUTPUT_DIR/$3" || \
		hard_fail "$2 -> $3"

	"$SED" -i -e 's/Generated by wayland-scanner [0-9.]*/SCANNER TEST/' \
		"$TEST_OUTPUT_DIR/$3" || hard_fail "$2 -> $3"

	diff -q "$TEST_DATA_DIR/$3" "$TEST_OUTPUT_DIR/$3" && \
		echo "$2 -> $3 PASS" || \
		fail "$2 -> $3"
}

verify_error() {
	echo
	echo "Checking that reading $1 gives an error on line $3"

	[ -f "$TEST_DATA_DIR/$1" ] || hard_fail "$1 not present"

	# Confirm failure error code
	"$WAYLAND_SCANNER" server-header < "$TEST_DATA_DIR/$1" >/dev/null 2>"$TEST_OUTPUT_DIR/$2" && \
		fail "$1 return code check"

	# Verify that an error is produced at the correct line
	grep -q "<stdin>:$3: error:" "$TEST_OUTPUT_DIR/$2" && echo "$1 PASS" || fail "$1 line number check"
}

generate_and_compare "code" "example.xml" "example-code.c"
generate_and_compare "client-header" "example.xml" "example-client.h"
generate_and_compare "server-header" "example.xml" "example-server.h"
generate_and_compare "enum-header" "example.xml" "example-enum.h"

generate_and_compare "code" "small.xml" "small-code.c"
generate_and_compare "client-header" "small.xml" "small-client.h"
generate_and_compare "server-header" "small.xml" "small-server.h"

generate_and_compare "-c code" "small.xml" "small-code-core.c"
generate_and_compare "-c client-header" "small.xml" "small-client-core.h"
generate_and_compare "-c server-header" "small.xml" "small-server-core.h"

# The existing "code" must produce result identical to "public-code"
generate_and_compare "code" "small.xml" "small-code.c"
generate_and_compare "public-code" "small.xml" "small-code.c"
generate_and_compare "private-code" "small.xml" "small-private-code.c"

generate_and_compare "code" "empty.xml" "empty-code.c"
generate_and_compare "client-header" "empty.xml" "empty-client.h"
generate_and_compare "server-header" "empty.xml" "empty-server.h"

verify_error "bad-identifier-arg.xml" "bad-identifier-arg.log" 7
verify_error "bad-identifier-entry.xml" "bad-identifier-entry.log" 8
verify_error "bad-identifier-enum.xml" "bad-identifier-enum.log" 6
verify_error "bad-identifier-event.xml" "bad-identifier-event.log" 6
verify_error "bad-identifier-interface.xml" "bad-identifier-interface.log" 3
verify_error "bad-identifier-protocol.xml" "bad-identifier-protocol.log" 2
verify_error "bad-identifier-request.xml" "bad-identifier-request.log" 6

exit $RETCODE

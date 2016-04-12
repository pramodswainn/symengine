#!/usr/bin/env bash

echo "Entering travis_clang.sh"
echo "TRAVIS_OS_NAME=${TRAVIS_OS_NAME}"
echo "CC=${CC}"
echo "TEST_CLANG_FORMAT=${TEST_CLANG_FORMAT}"

if [[ "${TRAVIS_OS_NAME}" == "linux" ]] && \
   [[ "${CC}" == "gcc-5" ]] && [[ "${TEST_CLANG_FORMAT}" == "yes" ]]; then

    RETURN=0
    CLANG="clang-format-3.7"

    if [ ! -f ".clang-format" ]; then
        echo ".clang-format file not found!"
        exit 1
    fi

    FILES=`git ls-files | grep -E "\.(cpp|h|hpp)$" | grep -Ev "symengine/utilities" | grep -Ev "cmake/"`

    echo "FILES="
    echo $FILES

    for FILE in $FILES; do
        echo "Processing: $FILE"

        $CLANG $FILE | cmp  $FILE >/dev/null

        if [ $? -ne 0 ]; then
            echo "[!] INCORRECT FORMATTING! $FILE" >&2
            RETURN=1
        fi

    done

    exit $RETURN
fi

exit 0

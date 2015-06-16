#! /bin/sh
#
# Run this script in the directory where finnish.dict.bz2 and
# the affix files are.
#

echo ""

# Parse command line options
if test $# -lt 1; then
    echo "Usage: build.sh <size>"
    echo ""
    echo "The <size> is either small, medium or large."
    echo ""
    exit 1;
fi

case "$1" in
  small|medium|large)
    AFF="finnish.$1.aff"
    ;;
  *)
    echo "Usage: build.sh <size>"
    echo ""
    echo "The <size> must be small, medium or large."
    echo ""
    exit 2;
    ;;
esac

# Needed files
DICT=finnish.dict

# Needed programs
ISPELL=ispell
BUILDHASH=buildhash
BZIP2=bzip2
SED=sed
GREP=grep

# Check the existence of needed programs.
#
# Oh, this is quite a bit overly cautious.
#
has_not_prog() {
    # Snipped from autoconf
    IFS="${IFS=   }"; save_ifs="$IFS"; IFS=":"
    dummy="$PATH"
    for dir in $dummy; do
        test -z "$dir" && dir=.
        if test -f "$dir/$@"; then
            return 1;
        fi
    done
    IFS="$save_ifs"
    return 0;
}

has_not_prog "$BZIP2" && BZIP2= # Error message shown later, if necessary.

if has_not_prog "$ISPELL"; then
    echo "Warning: Ispell doesn't seem to be installed."
    ISPELL=
fi

if has_not_prog "$BUILDHASH"; then
    echo "Error: buildhash from the ispell package doesn't seem to be"
    echo "       installed. You will not be able to build the hash file."
    echo ""
    exit 2;
fi

if has_not_prog "$SED"; then
    echo "Warning: sed doesn't seem to be installed."
    SED=
fi

if has_not_prog "$GREP"; then
    echo "Warning: grep doesn't seem to be installed."
    GREP=
fi

# Uncompress files, if needed
for F in $AFF $DICT; do
    if test -f "$F.bz2" && test ! -f "$F"; then
        if test -z "$BZIP2"; then
            echo "Error: You need the bzip2 utility to uncompress"
            echo "       the file $F.bz2"
            echo ""
            exit 2;
        fi

        echo "Uncompressing file $F.bz2 ...";
	if $BZIP2 -d "$F.bz2"; then
            echo "File $F.bz2 uncompressed."
        else 
            echo ""
            echo "Error: Uncompressing the file $F.bz2 failed.";
            echo "       You might need to redownload the file.";
            echo "";
            exit 2;
        fi
    fi
done

# Check the existence of the dictionary and the affix file
if test ! -f "$DICT"; then
    echo "Error: The dictionary file $DICT doesn't exist, so you cannot"; 
    echo "       build the hash file. Did you run this script in the";
    echo "       directory where the file $DICT or $DICT.bz2 is?";
    echo "";
    exit 2;
fi

if test ! -f "$AFF"; then
    echo "Error: The affix file $AFF doesn't exist, so you cannot build";
    echo "       the hash file. Did you run this script in the directory";
    echo "       where the file $AFF or $AFF.bz2 is?";
    echo "";
    exit 2;
fi


# Check for some temporary files
CNT_FILE=""
test -f "$DICT.cnt" || CNT_FILE="$DICT.cnt";

STAT_FILE=""
test -f "$DICT.stat" || STAT_FILE="$DICT.stat";


# Build the hash file
echo "Building the hash file using the affix file $AFF..."
if $BUILDHASH "$DICT" "$AFF" finnish.hash > /dev/null 2>&1 ; then
    echo ""
    echo "** Success: The hash file finnish.hash was built."

    if test -n "$ISPELL" && test -n "$SED" && test -n "$GREP"; then
	echo "Now copy it to the data directory of ispell, which seems to be"
	$ISPELL -vv | $GREP "LIBDIR" | $SED -e 's/.*LIBDIR.*=//'
    else
	echo "Now copy it to the data directory of ispell."
    fi

    # Clean up the temporary files, if they are to be deleted.
    if test -n "$CNT_FILE"; then
	rm -f "$CNT_FILE";
    fi
    if test -n "$STAT_FILE"; then
	rm -f "$STAT_FILE";
    fi

    echo ""
    exit 0;
else
    echo "Error: Unable to build the file finnish.hash."
    echo "       Do you have all the needed tools for building it?"
    echo ""
    exit 2;
fi

foreground() {
    if [ "$index" -eq "$active" ]; then
        echo blue
    else
        echo black
    fi
}

background() {
    if [ "$index" -eq "$size" ]; then
        echo colour238
    elif [ $(echo "$index + 1" | bc -l) -eq "$active" ]; then
        echo blue
    else
        echo black
    fi
}

size=$2
index=$3
active=$(echo $4 | sed 's/}//g' | cut -f1 -d,)

case $1 in
    fg)
        foreground
        ;;
    bg)
        background
        ;;
    *)
        echo black
esac

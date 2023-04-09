function xrun() {
    (
        "$@" &
        disown
    ) &>/dev/null
}

function git_commit_date() {
    git log -1 --format=format:%ad $1
}

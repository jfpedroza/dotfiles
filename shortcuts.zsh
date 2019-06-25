export dotfiles=~/dotfiles
export cloud=~/Cloud
export pcloud=~/pCloudDrive
export work=~/Work
export programming=~/Programming
export projects=~/Programming/Projects
export parques=$projects/Parques
export bmarks=$projects/BMarks

if [ -d $work/Peiky ]; then
    export peiky=$work/Peiky
elif [ -d ~/Peiky ]; then
    export peiky=~/Peiky
else
    echo Peiky folder not found
    exit 1
fi

export peiky_and=$peiky/peiky-android
export peiky_core=$peiky/peiky-core
export peiky_copy=$peiky/peiky-core-copy
export onyx=$projects/onyx

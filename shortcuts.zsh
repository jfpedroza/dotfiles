export dotfiles=~/dotfiles
export cloud=~/Cloud
export pcloud=~/pCloudDrive
export work=~/Work
export programming=~/Programming
export code=~/code

if [ -d $work/Peiky ]; then
    export peiky=$work/Peiky
elif [ -d ~/Peiky ]; then
    export peiky=~/Peiky
fi

if [ -d $work/Liftit ]; then
    export liftit=$work/Liftit
elif [ -d ~/Liftit ]; then
    export liftit=~/Liftit
fi

if [ "$peiky" != "" ]; then
    export peiky_and=$peiky/peiky-android
    export peiky_core=$peiky/peiky-core
    export peiky_copy=$peiky/peiky-core-copy
fi

if [ "$liftit" != "" ]; then
    export liftit_core=$liftit/core
    export liftit_copy=$liftit/core-copy
fi


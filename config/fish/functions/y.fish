function y --description "Yazi with shell integration"
    set tmp (mktemp -t yazi)
    yazi $argv --cwd-file $tmp
    if set cwd (cat $tmp); and test -n $cwd; and test $cwd != $PWD
        cd $cwd
    end
    rm -f $tmp
end

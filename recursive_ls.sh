#!/bin/bash
#
# Print out hadoop filesystem structure 

thresh_depth="$2"

function explore(){
    path="$1"
    cur_depth="$2"
    for _child in $(hdfs dfs -ls "$path" 2>/dev/null | awk '{if(NF==8)print $8}'); do
        stat=$(hdfs dfs -stat "$_child" 2>/dev/null)
        echo "$_child" "[$stat]"  \
            | xargs -n 1 -I folder bash -c "f=\$(echo folder | awk '{print \$1}'); \
                                            size=\$(hdfs dfs -du -s -h \$f 2>/dev/null | awk '{if(\$1!=0){print \$1\$2 } else print \"OM\"}' ); \
                                            echo folder \$size" \
            | sed -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'
        if [[ "$cur_depth" -lt "$thresh_depth" ]]; then
            explore "$_child" $(( cur_depth + 1 ))
            let cur_depth=cur_depth-1
        fi
    done
}

explore "$1" 1

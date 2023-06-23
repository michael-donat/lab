set -a DOCKER_CONTEXT_ALIAS lab
set -a DOCKER_CONTEXT_ENDPOINT tcp://ubuntu.lab.donat.im:2375

set -a DOCKER_CONTEXT_ALIAS mac
set -a DOCKER_CONTEXT_ENDPOINT unix:///Users/mikey/.docker/run/docker.sock

set -a DOCKER_CONTEXT_ALIAS colima
set -a DOCKER_CONTEXT_ENDPOINT unix:///Users/mikey/.colima/default/docker.sock

function dinit
    for i in (seq (count $DOCKER_CONTEXT_ALIAS))
        docker context create $DOCKER_CONTEXT_ALIAS[$i] --docker host="$DOCKER_CONTEXT_ENDPOINT[$i]"
    end
end

function dls
        echo
        echo "Available contexts aliases for docker:"
        echo
    for i in (seq (count $DOCKER_CONTEXT_ALIAS))
        printf '%20s => %s\n' $DOCKER_CONTEXT_ALIAS[$i] $DOCKER_CONTEXT_ENDPOINT[$i]
    end
        echo
        echo "Available contexts:"
        echo
        docker context ls
    echo
end

function dc
    for i in (seq (count $DOCKER_CONTEXT_ALIAS))
        if test "$argv[1]" = "$DOCKER_CONTEXT_ALIAS[$i]"
          set ENDPOINT $DOCKER_CONTEXT_ENDPOINT[$i]
          set CONTEXT $DOCKER_CONTEXT_ALIAS[$i]
          break
        end
        if test "$argv[1]" = "$DOCKER_CONTEXT_ENDPOINT[$i]"
          set ENDPOINT $DOCKER_CONTEXT_ENDPOINT[$i]
          set CONTEXT $DOCKER_CONTEXT_ALIAS[$i]
          break
        end
    end

    if not set -q ENDPOINT
        echo "Unknown context alias '$argv[1]'"
        return 1
    end

     docker context use $CONTEXT &> /dev/null
     set -xg DOCKER_HOST $ENDPOINT
#     set -xg DOCKER_CONTEXT $CONTEXT
end

dc lab

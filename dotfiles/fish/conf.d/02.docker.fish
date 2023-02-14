function docker_lab
	set -gx DOCKER_CONTEXT lab
end

function docker_local
	set -gx DOCKER_CONTEXT mac
end

docker_lab

function docker_context_setup
    docker context create lab --docker host=tcp://ubuntu.lab.donat.im:2375
    docker context create mac --docker host="unix:///Users/mikey/.docker/run/docker.sock"
end
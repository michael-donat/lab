function docker_remote
	set -gx DOCKER_HOST tcp://ubuntu.lab.donat.im:2375
end

function docker_local
	set -ge  DOCKER_HOST
end

docker_remote
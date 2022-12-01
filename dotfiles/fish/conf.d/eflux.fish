set -a K8S_CONTEXT_ALIAS staging
set -a K8S_CONTEXT_ID gke_eflux-staging_us-east1-c_standard-cluster-1

set -a K8S_CONTEXT_ALIAS stage
set -a K8S_CONTEXT_ID gke_eflux-staging_us-east1-c_standard-cluster-1

set -a K8S_CONTEXT_ALIAS prod
set -a K8S_CONTEXT_ID gke_eflux-production_us-east1-c_standard-cluster-1

function stage_mngo
    k port-forward --context=gke_eflux-staging_us-east1-c_standard-cluster-1 --namespace=default svc/mongo 27117:27017
end

function prod_mngo
    k port-forward --context=gke_eflux-production_us-east1-c_standard-cluster-1 --namespace=default svc/mongo 27217:27017
end

function mirror_mngo
    k port-forward --context=gke_eflux-production_us-east1-c_standard-cluster-1 --namespace=tools svc/mongo-for-mirror 27317:27017
end

function prod_switch
    cd /Users/mikey/Development/e-flux/e-flux && bedrock cloud authorize production
end

function stage_switch
    cd /Users/mikey/Development/e-flux/e-flux && bedrock cloud authorize staging
end

function eapi
	cd /Users/mikey/Development/e-flux/e-flux/services/api
	yarn install
	yarn start
end

function eweb
	/Users/mikey/Development/e-flux/e-flux/services/web
	yarn install
	yarn start
end

cd /Users/mikey/Development/e-flux
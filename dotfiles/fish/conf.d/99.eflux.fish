set -a K8S_CONTEXT_ALIAS staging
set -a K8S_CONTEXT_ID gke_eflux-staging_europe-west3_platform

set -a K8S_CONTEXT_ALIAS usstage
set -a K8S_CONTEXT_ID gke_eflux-staging_us-east1-c_standard-cluster-1

set -a K8S_CONTEXT_ALIAS usprod
set -a K8S_CONTEXT_ID gke_eflux-production_us-east1-c_standard-cluster-1

set -a K8S_CONTEXT_ALIAS stage
set -a K8S_CONTEXT_ID gke_eflux-staging_europe-west3_platform

set -a K8S_CONTEXT_ALIAS prod
set -a K8S_CONTEXT_ID gke_eflux-production_europe-west3_platform

set -a GCLOUD_CONFIGURATION_ALIAS staging
set -a GCLOUD_CONFIGURATION_ID staging

set -a GCLOUD_CONFIGURATION_ALIAS stage
set -a GCLOUD_CONFIGURATION_ID staging

set -a GCLOUD_CONFIGURATION_ALIAS production
set -a GCLOUD_CONFIGURATION_ID production

set -a GCLOUD_CONFIGURATION_ALIAS prod
set -a GCLOUD_CONFIGURATION_ID production

set -a GCLOUD_CONFIGURATION_ALIAS usprod
set -a GCLOUD_CONFIGURATION_ID usproduction

function stage_mngo
    k port-forward --context=gke_eflux-staging_europe-west3_platform --namespace=infra svc/mongo 27117:27017
end

function prod_mngo
    k port-forward --context=gke_eflux-production_europe-west3_platform --namespace=infra svc/mongo 27217:27017
end

function mirror_mngo
    k port-forward --context=gke_eflux-production_europe-west3_platform --namespace=tools svc/mongo-for-mirror 27317:27017
end

function _eflux_mongosh --description 'mongosh inside the mongodb-0 pod of a cluster'
    set -l context $argv[1]
    set -l database $argv[2]
    set -e argv[1..2]

    k exec --context=$context --namespace=infra -it mongodb-0 -- \
        mongosh "mongodb://localhost/$database?replicaSet=eflux&readPreference=secondary" $argv
end

function prod_mongosh --description 'mongosh into production eflux_production (secondary read)'
    _eflux_mongosh gke_eflux-production_europe-west3_platform eflux_production $argv
end

function stage_mongosh --description 'mongosh into staging eflux (secondary read)'
    _eflux_mongosh gke_eflux-staging_europe-west3_platform eflux $argv
end

function prod_switch
    cd /Users/mikey/Development/e-flux/e-flux && bedrock cloud authorize production
end

function stage_switch
    cd /Users/mikey/Development/e-flux/e-flux && bedrock cloud authorize staging
end

function eapi
	cd /Users/mikey/Development/e-flux/e-flux/services/api
	pnpm install
	pnpm run start | tee /tmp/dev.api.log
end

function eweb
	cd /Users/mikey/Development/e-flux/e-flux/services/web
	pnpm install
	pnpm run start
end

function ekube
	cd /Users/mikey/Development/e-flux/e-flux/deployment/environments/production
	kc prod
end

cd /Users/mikey/Development/e-flux

function setmongoenv
	set -xg MONGO_URI "mongodb://$MONGO_HOST/eflux_production?replicaSet=api"
	set -xg MONGO_OCPP_URI mongodb://$MONGO_HOST/eflux_ocpp_production
end

function mongodocker
	set -xg MONGO_HOST ubuntu.lab.donat.im
	setmongoenv
end

function mongolocal
        set -xg MONGO_HOST 0.0.0.0
        setmongoenv
end

setmongoenv

function show_config
    kcl
    echo "Mongo configuration"
    echo

    printf '%20s => %s\n' MONGO_HOST $MONGO_HOST
    printf '%20s => %s\n' MONGO_URI $MONGO_URI
    printf '%20s => %s\n' MONGO_OCPP_URI $MONGO_OCPP_URI

    echo
end

function elog --description 'Tail dev.api.log and extract codes + reset URLs'
    set -l logfile /tmp/dev.api.log
    test (count $argv) -gt 0; and set logfile $argv[1]

    tail -f $logfile | perl -nle '
        BEGIN { $| = 1 }
        if (/(?:<code[^>]*>|code is:\s*)(\d{6})/) {
            print $1;
        } elsif (/<a\s[^>]*?href=\S*?(https?:[^"\s]+[A-Za-z0-9])[^>]*>(.*?)<\/a>/) {
            my ($url, $txt) = ($1, $2);
            $url =~ s/&#x([0-9a-fA-F]+);/chr(hex($1))/ge;
            $url =~ s/&#(\d+);/chr($1)/ge;
            $url =~ s/&amp;/&/g;
            $url =~ s{^https://localhost}{http://localhost};
            $txt =~ s/^\s+|\s+$//g;
            print "$txt - $url";
        }
    '
end

set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True



function gcls
        echo
        echo "Available aliases for gcloud:"
        echo
    for i in (seq (count $GCLOUD_CONFIGURATION_ALIAS))
        printf '%20s => %s\n' $GCLOUD_CONFIGURATION_ALIAS[$i] $GCLOUD_CONFIGURATION_ID[$i]
    end
        echo
        echo "Available configurations:"
        echo
        gcloud config configurations list
    echo
end

# to switch context we will iterate over the array of 'registered' aliases
# registration happens by appending to the global GCLOUD_CONFIGURATION_ALIAS and GCLOUD_CONFIGURATION_ID
# by files included in conf.d
function gc
    for i in (seq (count $GCLOUD_CONFIGURATION_ALIAS))
        if test "$argv[1]" = "$GCLOUD_CONFIGURATION_ALIAS[$i]"
          set CONFIGURATION $GCLOUD_CONFIGURATION_ID[$i]
          break
        end
        if test "$argv[1]" = "$GCLOUD_CONFIGURATION_ID[$i]"
          set CONFIGURATION $GCLOUD_CONFIGURATION_ID[$i]
          break
        end
    end

    if not set -q CONFIGURATION
        echo "Unknown configuration alias '$argv[1]'"
        return 1
    end

     gcloud config configurations activate $CONFIGURATION
     gcloud config configurations list | rg "NAME|^$CONFIGURATION\s"

end


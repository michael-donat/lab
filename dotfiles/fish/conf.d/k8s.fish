

function kn
    kubectl config set-context --current --namespace=$argv[1]
end

function k
    kubectl $argv
end

function ka
    k apply $argv
end

function kg
    k get $argv
end

function kl
    k logs -f $argv
end

function kcl
        echo
        echo "Available contexts for kc:"
        echo
    for i in (seq (count $K8S_CONTEXT_ALIAS))
        printf '%20s => %s\n' $K8S_CONTEXT_ALIAS[$i] $K8S_CONTEXT_ID[$i]
    end
    echo
end

# to switch context we will iterate over the array of 'registered' aliases
# registration happens by appending to the global $K8S_CONTEXT_ALIAS and $K8S_CONTEXT_ID
# by files included in conf.d
function kc
    for i in (seq (count $K8S_CONTEXT_ALIAS))
        if test "$argv[1]" = "$K8S_CONTEXT_ALIAS[$i]"
          set CONTEXT $K8S_CONTEXT_ID[$i]
          break
        end
        if test "$argv[1]" = "$K8S_CONTEXT_ID[$i]"
          set CONTEXT $K8S_CONTEXT_ID[$i]
          break
        end
    end

     k config use-context $CONTEXT

end
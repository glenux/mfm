#!/bin/bash

# mfm Bash completion script

_mfm() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Options globales pour 'mfm'
    local mfm_global_opts="-c --config -v --verbose -o --open --version -h --help"

    # Commandes pour 'mfm'
    local mfm_cmds="config mapping completion"

    # Options pour 'config' et 'mapping'
    local config_opts="init"
    local mapping_opts="list create edit mount umount delete"

    # Ajouter les options globales à chaque cas
    case "${prev}" in
        mfm)
            COMPREPLY=($(compgen -W "${mfm_cmds} ${mfm_global_opts}" -- ${cur}))
            return 0
            ;;
        config)
            COMPREPLY=($(compgen -W "${config_opts} ${mfm_global_opts}" -- ${cur}))
            return 0
            ;;
        mapping)
            COMPREPLY=($(compgen -W "${mapping_opts} ${mfm_global_opts}" -- ${cur}))
            return 0
            ;;
        *)
            if [[ ${cur} == -* ]]; then
                COMPREPLY=($(compgen -W "${mfm_global_opts}" -- ${cur}))
            fi
            return 0
            ;;
    esac
}

# Appliquer la complétion à la fonction 'mfm'
complete -F _mfm mfm

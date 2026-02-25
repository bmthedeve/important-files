export SHOW_KUBE_CONTEXT=false

autoload -Uz colors && colors
setopt PROMPT_SUBST

kube_context() {
  [[ "$SHOW_KUBE_CONTEXT" != "true" ]] && return

  local ctx ns color

  ctx=$(kubectl config current-context 2>/dev/null)
  ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

  [[ -z "$ctx" ]] && return

  if [[ "$ctx" == *"production"* ]]; then
    color="magenta"
  elif [[ "$ctx" == *"dev"* ]]; then
    color="cyan"
  else
    color="white"
  fi

  echo "%{$fg[$color]%}${ctx}:${ns}%{$reset_color%}"
}

PROMPT='%F{green}%n%f %B%F{cyan}%~%f%b $(kube_context) %# '

alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -alhG'
alias lrt='ls -ltraG'
alias ltr='ls -ltraG'

alias k='kubectl'
alias tf='terraform'
alias d='docker'

alias po='kubectl get pods'
alias deploy='kubectl get deploy'
alias secret='kubectl get secrets'
alias ns='kubectl get ns'
alias svc='k get svc'
alias ing='k get ing'
alias ev='k get events --sort-by=.metadata.creationTimestamp'

alias kns='k config set-context --current --namespace'
alias kctxs='k config get-contexts'
alias kctx='k config use-context'

alias hosts='sudo vi /etc/hosts'

alias kube-on='export SHOW_KUBE_CONTEXT=true'
alias kube-off='export SHOW_KUBE_CONTEXT=false'

export KUBECONFIG=~/.kube/config:~/.kube/dev-k8s.yaml:~/.kube/frankfurt-production.yaml

autoload -Uz compinit
compinit

source <(kubectl completion zsh)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C "$(which terraform)" terraform

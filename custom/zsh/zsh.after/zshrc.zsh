# Perlbrew stuff
export PERLBREW_ROOT=$HOME/perl5/perlbrew
export PERLBREW_HOME=$HOME/.perlbrew
export VISUAL=$HOME/bin/subl
export EDITOR=$HOME/bin/subl
source $PERLBREW_ROOT/etc/bashrc

# Autojump stuff
source /usr/local/etc/autojump.zsh

# Python stuff
export PYTHONPATH=/Library/Python/2.7/site-packages

PATH=~/bin:$PATH

#Git ProTip - Delete all local branches that have been merged into HEAD
git_purge_local_branches() {
    [ -z $1 ] && return
    #git branch -d `git branch --merged $1 | grep -v '^*' | grep -v 'master' | grep -v 'dev' | tr -d '\n'`
    BRANCHES=`git branch --merged $1 | grep -v '^*' | grep -v 'master' | grep -v 'dev' | tr -d '\n'`
    echo "Running: git branch -d $BRANCHES"
    git branch -d $BRANCHES
}

#Bonus - Delete all remote branches that are merged into HEAD (thanks +Kyle Neath)
git_purge_remote_branches() {
    [ -z $1 ] && return
    git remote prune origin

    #git push origin `git branch -r --merged $1 | grep 'origin' | grep -v '/master$' | grep -v '/dev$' | sed 's/origin\//:/g' | tr -d '\n'`
    BRANCHES=`git branch -r --merged $1 | grep 'origin' | grep -v '/master$' | grep -v '/dev$' | sed 's/origin\//:/g' | tr -d '\n'`
    echo "Running: git push origin $BRANCHES"
    git push origin $BRANCHES
}

git_purge() {
    [ -z $1 ] && return
    git_purge_local_branches $1
    git_purge_remote_branches $1
}

pullreq() {
    [ -z $BRANCH ] && BRANCH="dev"
    HEAD=$(git symbolic-ref HEAD 2> /dev/null)
    [ -z $HEAD ] && return # Return if no head
    REMOTE=`cat .git/config | grep "remote \"origin\"" -A 2 | tail -n1 | sed 's/.*:\([^\/]*\).*/\1/'`

    hub pull-request -b $BRANCH -h $REMOTE:${HEAD#refs/heads/} $1
}

source ~/.secrets

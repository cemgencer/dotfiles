# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
if [ -f $prefix/etc/bash_completion ]; then
    source $prefix/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# z
[ -f $prefix/etc/profile.d/z.sh ] && source $prefix/etc/profile.d/z.sh

# terminal color
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# prompt
#PS1="\[\033[34m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

# Git
if [ -f $prefix/etc/bash_completion.d/git-completion.bash ]; then
	source $prefix/etc/bash_completion.d/git-completion.bash
	PROMPT_COMMAND='__git_ps1 "\h:\W" "\\\$ "'
fi
[ -f $prefix/etc/bash_completion.d/git-prompt.sh ] && source $prefix/etc/bash_completion.d/git-prompt.sh

# If you set GIT_PS1_SHOWDIRTYSTATE to a nonempty value,
# unstaged (*) and staged (+) changes will be shown next to the branch
# name.  You can configure this per-repository with the
# bash.showDirtyState variable, which defaults to true once
# GIT_PS1_SHOWDIRTYSTATE is enabled.
GIT_PS1_SHOWDIRTYSTATE=1

# You can also see if currently something is stashed, by setting
# GIT_PS1_SHOWSTASHSTATE to a nonempty value. If something is stashed,
# then a '$' will be shown next to the branch name.
#GIT_PS1_SHOWSTASHSTATE=1

# If you would like to see if there're untracked files, then you can set
# GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value. If there're untracked
# files, then a '%' will be shown next to the branch name.  You can
# configure this per-repository with the bash.showUntrackedFiles
# variable, which defaults to true once GIT_PS1_SHOWUNTRACKEDFILES is
# enabled.
GIT_PS1_SHOWUNTRACKEDFILES=1

# If you would like to see the difference between HEAD and its upstream,
# set GIT_PS1_SHOWUPSTREAM="auto".  A "<" indicates you are behind, ">"
# indicates you are ahead, "<>" indicates you have diverged and "="
# indicates that there is no difference. You can further control
# behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated list
# of values:
#
#     verbose       show number of commits ahead/behind (+/-) upstream
#     legacy        don't use the '--count' option available in recent
#                   versions of git-rev-list
#     git           always compare HEAD to @{upstream}
#     svn           always compare HEAD to your SVN upstream
#
# By default, __git_ps1 will compare HEAD to your SVN upstream if it can
# find one, or @{upstream} otherwise.  Once you have set
# GIT_PS1_SHOWUPSTREAM, you can override it on a per-repository basis by
# setting the bash.showUpstream config variable.
GIT_PS1_SHOWUPSTREAM=verbose

# If you would like to see more information about the identity of
# commits checked out as a detached HEAD, set GIT_PS1_DESCRIBE_STYLE
# to one of these values:
#
#     contains      relative to newer annotated tag (v1.6.3.2~35)
#     branch        relative to newer tag or branch (master~4)
#     describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
#     default       exactly matching tag
#GIT_PS1_DESCRIBE_STYLE=default

# If you would like a colored hint about the current dirty state, set
# GIT_PS1_SHOWCOLORHINTS to a nonempty value. The colors are based on
# the colored output of "git status -sb".
GIT_PS1_SHOWCOLORHINTS=1

_byobu_sourced=1 . /usr/local/bin/byobu-launch

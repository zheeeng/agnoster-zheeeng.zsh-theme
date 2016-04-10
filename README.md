# agnoster-zheeeng.zsh-theme
**agnoster.zsh-theme revamp based on <https://github.com/agnoster/agnoster-zsh-theme>**

## Compatibility

For rendering this theme in all likelihood, you will need a [Powerline-patched font](https://gist.github.com/1595572).  
Try the echo test `echo "\ue0b0 \ue0a0 \u27a6 \u2714 \u2718 \u26a1 \u2699 \u2764 \u2693"`, and the expected output should look like:

![echo test](https://cloud.githubusercontent.com/assets/1303154/10761357/fce30812-7cfb-11e5-8ece-b4f7039338a7.png)

The recommended terminal:  
* iTerm2

The recommended iTerm2 fonts:  
* Regular Font: Source Code Pro Regular [[Associate Link](https://github.com/adobe-fonts/source-code-pro)]
* Non-ASCII Font: 14pt Source Code Pro for Powerline Regular (display in iTerm2 Text config panel: 14pt Sauce Code Powerline)

The recommended iTerm2 theme:  
* [Tomorrow Night Eighties theme](https://github.com/chriskempson/tomorrow-theme/tree/master/iTerm2)

## Usage

1. Copy `agnoster-zheeeng.zsh-theme` to `$ZSH_CUSTOM/themes/`.
2. Modify `.zshrc`, add `ZSH_THEME="agnoster-zheeeng"` below old `ZSH_THEME` and comment the old.

## Features

* Privilege: root - `⚡`, normal user - `⚓`
* > `Username` > `Hostname` > `Working directory`
* > Local branch
  * ` Branch name` / `➦ SHA1 in detached head state`: dirty working directory - background color change to yellow
  * Dirty working directory prompt what you would and could commit files (`a:$added u:$unadded t:$total heart:$all_added`)
  * Head ahead upstreawm count (`($ahead..`)
  * > Remote branch
    * Head behind upstream count (`..$ahead)`)
    * `Branch name `
* > `Previous command status` start in new line, failed - `✘`, Success - `✔`
* > `Are jobs working?` : Yes - `⚙`, No - none
* > Commands
* Current Time on the right of prompt

**Tip: set DEFAULT_USER in our profile, username and hostname won't show**

## Screenshots

- [ ] Todo: add screenshots

## Future Work

- [ ] install.sh
- [ ] git stash info
- [ ] SVN, HG support
- [ ] virtualenv, rbenv, jenv, nvm support
- [ ] Todo timer

## Improvement

- [ ] Fix blank space coloring once window wrapping cause prompt line breaking.
- [ ] The position of time info.

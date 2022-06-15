# Git & SSH configuration for multiple github accounts

#### WARNING: Make sure to keep backups of SSH config and global .gitconfig files

Generate SSH keys

```
ssh-keygen -t ed25519 -C "my-email@example.com"
// save as 'user1-github'
ssh-keygen -t ed25519 -C "my-second-email@example.com"
// save as 'user2-github'
```

Start SSH agent and add private keys

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/user1-github
ssh-add ~/.ssh/user2-github
```

Add public key for each account on github

```
# Copy paste public key
cat ~/.ssh/user1-github
# For second github account
cat ~/.ssh/user2-github
```

Edit SSH config file

```
# ~/.ssh/config

# User 1
Host github.com
        HostName github.com
        User user1
        IdentityFile ~/.ssh/user1-github
        IdentitiesOnly yes
        AddKeysToAgent yes

# User 2
Host github.com-user2
        HostName github.com
        User user2
        IdentityFile ~/.ssh/user2-github
        IdentitiesOnly yes
        AddKeysToAgent yes

```

Create .gitconfig for second user

```
# ~/user2.gitconfig

[user]
        user = user2
        email = my-second-email@example.com
[url "git@github.com-user2:user2"]
        insteadOf = git@github.com:user2

```

Edit global `.gitconfig`

```
[init]
        defaultBranch = main
[user]
        name = user1
        email = my-email@example.com
[includeIf "gitdir:~/projects/user2/"]
        path = ~/user2.gitconfig
```

# Git & SSH configuration for multiple github accounts

Generate SSH keys

```
ssh-keygen -t ed25519 -C "my-email@example.com" #save as 'id_ed25519' (default)
ssh-keygen -t ed25519 -C "my-second-email@example.com" #save as 'id_ed25519.user2'
```

Start SSH agent and add private keys

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519.user2
```

Add public key for each account on github

```
# Copy paste public key
cat ~/.ssh/id_ed25519.pub
# For second github account
cat ~/.ssh/id_ed25519.user2.pub
```

Edit SSH config file

```
# ~/.ssh/config

# User 1
Host github.com
        HostName github.com
        User user1
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
        AddKeysToAgent yes

# User 2
Host github.com
        HostName github.com-user2
        User user2
        IdentityFile ~/.ssh/id_ed25519.user2
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

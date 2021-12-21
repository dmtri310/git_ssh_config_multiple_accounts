#! /bin/bash

TAB="$(printf '\t')"

read -p "Enter 1st user name: " user1_name
read -p "Enter 1st user email: " user1_email
read -p "Enter 2nd user name: " user2_name
read -p "Enter 2nd user email: " user2_email

mkdir -p "$HOME/projects/$user1_name"
mkdir -p "$HOME/projects/$user2_name"

# Generate SSH keys
ssh-keygen -t ed25519 -C $user1_email -N "" -f "$HOME/.ssh/id_ed25519"
ssh-keygen -t ed25519 -C $user2_email -N "" -f "$HOME/.ssh/id_ed25519.$user2_name"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add SSH private keys to ssh-agent
ssh-add ~/.ssh/id_ed25519
ssh-add "$HOME/.ssh/id_ed25519.$user2_name"

# Create .gitconfig for second user
user2_gitconfig="$HOME/$user2_name.gitconfig"
touch $user2_gitconfig
cat > $user2_gitconfig <<EOL
[user]
${TAB}user = ${user2_name}
${TAB}email = ${user2_email}
[url "git@github.com-${user2_name}:${user2_name}"]
${TAB}insteadOf = git@github.com:${user2_name}
EOL

# Edit global .gitconfig
touch ~/.gitconfig
cat > ~/.gitconfig <<EOL
[init]
${TAB}defaultBranch = main
[user]
${TAB}name = ${user1_name}
${TAB}email = ${user1_email}
[includeIf "gitdir:~/projects/${user2_name}/"]
${TAB}path = ${user2_gitconfig}
EOL

# Edit SSH config
touch ~/.ssh/config
cat > ~/.ssh/config <<EOL
# ${user1_name}
Host github.com
${TAB}HostName github.com
${TAB}User ${user1_name}
${TAB}IdentityFile ~/.ssh/id_ed25519
${TAB}IdentitiesOnly yes
${TAB}AddKeysToAgent yes

# ${user2_name}
Host github.com
${TAB}HostName github.com-${user2_name}
${TAB}User ${user2_name}
${TAB}IdentityFile ~/.ssh/id_ed25519.${user2_name}
${TAB}IdentitiesOnly yes
${TAB}AddKeysToAgent yes
EOL

echo ""
echo "Public key for 1st user:"
cat ~/.ssh/id_ed25519.pub

echo "Public key for 2nd user:"
cat "$HOME/.ssh/id_ed25519.${user2_name}.pub"

# font for terminal
choco install nerd-fonts-robotomono

# github cli
choco install gh

# neovim
choco install neovim -y

# used by telescope
choco install mingw -y 
choco install ripgrep -y
choco install fd -y

# create symlink for git-config
if (Test-Path -Path "$env:LOCALAPPDATA\.gitconfig") { Remove-Item -Path "$env:LOCALAPPDATA\.gitconfig" -Force }
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\.gitconfig" -Target ".\git\.gitconfig"

# create symlink for nvim config
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target ".\nvim"

# make sure userhome ("HOME" environment-variable) is explicit mapped to a local folder (C:/Users/Username).
[System.Environment]::SetEnvironmentVariable('HOME', $env:USERPROFILE, 'User')

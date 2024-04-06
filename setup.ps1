choco install neovim -y

# used by telescope
choco install mingw -y 
choco install ripgrep -y
choco install fd -y

# create symlink for nvim config
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target ".\nvim"

# make  sure userhome ("HOME" environemnt shows not to a network drive).
# Todo: Set environment variable to C:\Users\User

#nvim :MasonUpdate


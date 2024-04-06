choco install neovim -y

# used by telescope
choco install mingw -y 
choco install ripgrep -y
choco install fd -y

# create symlink for nvim config
$nvimConfigFolder = "%localappdata%\nvim"
if (!(Test-Path $nvimConfigFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $nvimConfigFolder
}

New-Item -ItemType SymbolicLink -Path ".\nvim" -Target $nvimConfigFolder

# make  sure userhome ("HOME" environemnt shows not to a network drive).
# Todo: Set environment variable to C:\Users\User

#nvim :MasonUpdate


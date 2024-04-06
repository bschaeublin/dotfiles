choco install neovim -y

# used by telescope
choco install mingw -y 
choco install ripgrep -y
choco install fd -y

md ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)

# make  sure userhome ("HOME" environemnt shows not to a network drive).
# Todo: Set environment variable to C:\Users\User

#nvim :PlugInstall

#nvim :TSInstall lua
#nvim :TSInstall vimdoc

#nvim :MasonUpdate

#nvim: LspInstall angularls
#nvim: LspInstall tsserver
#nvim: LspInstall eslint
#nvim: LspInstall cssls (?)

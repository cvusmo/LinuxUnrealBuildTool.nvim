# LinuxUnrealBuildTool

# LinuxUnrealBuildTool.nvim/lua/linuxunrealbuildtool

<a href="https://dotfyle.com/blacksheepcosmo/linuxunrealbuildtoolnvim-lua-linuxunrealbuildtool"><img src="https://dotfyle.com/blacksheepcosmo/linuxunrealbuildtoolnvim-lua-linuxunrealbuildtool/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/blacksheepcosmo/linuxunrealbuildtoolnvim-lua-linuxunrealbuildtool"><img src="https://dotfyle.com/blacksheepcosmo/linuxunrealbuildtoolnvim-lua-linuxunrealbuildtool/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/blacksheepcosmo/linuxunrealbuildtoolnvim-lua-linuxunrealbuildtool"><img src="https://dotfyle.com/blacksheepcosmo/linuxunrealbuildtoolnvim-lua-linuxunrealbuildtool/badges/plugin-manager?style=flat" /></a>

Welcome to Linux Unreal Build Tool by cvusmo. LinuxUnrealBuildTool is a work in progress aimed at enhancing the Unreal Engine development experience on Linux, specifically integrated with Neovim. The plugin offers a simple yet powerful set of commands to streamline common tasks:

### Features:

- **Clean:** Remove previous build artifacts to ensure a fresh start.
- **Build:** Compile your project efficiently.
- **Rebuild:** Clean and build your project in one step.
- **Create New Blank C++ Projects:** Quickly set up new C++ projects.
- **Install Plugins:** Easily manage and install plugins.

### Usage

All functionalities are accessible via commands in Neovim, making it an ideal tool for developers who prefer a terminal-based workflow.

Lazyvim:
```
return {
  {
    "cvusmo/LinuxUnrealBuildTool.nvim",
    event = "VeryLazy",
    config = function()
      require('linuxunrealbuildtool').setup({
        project_path = "/home/bob/path/to/project",
        unreal_engine_path = "/home/bob/path/to/unrealengine"
      })
    end,
  },
}
```

### Navigation:

- [Section ᴎ - Before you begin](#section-ᴎ)
- [Section I - Build from Source](#section-i)
- [Section II - Neovim Integration](#section-ii)
- [Section III](#section-iii)

## Section ᴎ 

This guide is designed to be simple and easy to follow. I would recommend reading each section before you execute any commands. If you don't know what a command does, look at the wiki, ask google, ask a friend, or chatgpt. I'm not responsible if you enter a command and it deletes something. 

### Contributing

With that out of the way, I'm moving away from IDE's and wanting to develop with neovim. Part of that is creating plugins like this to help make things a bit easier. If you encounter issues or need to install these dependencies on another distribution, or to contribute to the plugin, open an issue:

```
- Navigate to https://www.github.com/cvusmo/linuxunrealbuildtool.nvim
- Click on the "Issues" tab.
- Click "New issue".
- Fill in the title and provide any relevant information or questions.
- Click "Submit new issue".
```

### Dependencies:

```
git base-devel clang cmake ispc dotnet-runtime-6.0 neovim
```

Arch:
```
sudo pacman -S git base-devel clang cmake ispc dotnet-runtime-6.0 
```

Debian/Ubuntu:
```
sudo apt update
sudo apt install git build-essential clang cmake ispc dotnet-runtime-6.0
```

Fedora:
```
sudo dnf install git @development-tools clang cmake ispc dotnet-runtime-6.0
```

openSUSE:
```
sudo zypper install git gcc gcc-c++ make automake cmake clang ispc dotnet-runtime-6.0
```

## Section I 
Build from Source

1a. check for existing ssh key
```
ls -al ~/.ssh
```

1b. if you don't have an ssh key, generate a new ssh key pair
```
ssh-keygen -t rsa -b 4096 -C "your-email@exmaple.com"
```

```
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

1c. add ssh key to ssh agent

bash or zsh
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

fish
```
eval (ssh-agent -c)
ssh-add ~/.ssh/id_rsa
```

1d. add ssh key to github account

copy ssh key to clipboard using xclip
```
sudo pacman -S xclip
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
```

or

manually copy the key

```
cat ~/.ssh/id_rsa.pub
```

1e. add ssh keys to github account

```
- Log in to your GitHub account.
- Go to **Settings**.
- In the left sidebar, click **SSH and GPG keys**.
- Click **New SSH key**.
- Paste your SSH key into the "Key" field.
- Click **Add SSH key**.
```

1f. verify ssh connection

```
ssh -T git@github.com
```

success 
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

2a. clone repo from github for Unreal Engine 5.4

automated:

```
cd /path/to/where/you/want/to/install/UnrealEngine
./SourceBuild.sh
```

example:
```
cd /home/echo/Build/
./SourceBuild.sh
```

manually:

bash or zsh
```
git clone -b 5.4 git@github.com:EpicGames/UnrealEngine && cd UnrealEngine
```

fish
```
git clone -b 5.4 git@github.com:EpicGames/UnrealEngine; and cd UnrealEngine
```

2b. build unreal engine from source

```
./Setup.sh
./GenerateProjectFiles.sh
make -j1
```

3a. create blank C++ project

```
cd /home/$USER/PATH/TO/HERE/UnrealEngine/Engine/Binaries/Linux
./UnrealEditor
```
## Section II 
Neovim Integration

@TODO

# LinuxUnrealBuildTool

Overview:
@TODO

Navigation:
- [Section ᴎ - Before you begin](#section-ᴎ)
- [Section I - Build from Source](#section-i)
- [Section II - Neovim Integration](#section-ii)
- [Section III](#section-iii)

## Section ᴎ 
Before you Begin

Arch users beware... building from source from the github nets a frustrating time. The best way I've been able to build a reliable engine is by using the AUR. It's simple.
Unlike Sigma Arch users I'm not going to tell you to read the AUR. I'm just going to quote it, so you can read it here:

```bash
git clone https://aur.archlinux.org/packages/unreal-engine-bin.git

Download the zip file manually. Vrify which engine version as of this article, it was [Linux_Unreal_Engine_5.4.1.zip].

https://www.unrealengine.com/linux

Download and save the *.zip into the unreal-engine-bin folder.
makepkg -si
```


@TODO 
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

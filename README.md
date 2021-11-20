There are so many commands to remember among the GNU/Linux distributions, and sometime I can't find what I really want from a package manager.

Here's what it means for me to use a completely "standalone" application:

- I want an app totally independent from the repositories of my distribution;
- it must not require hundreds of packages and files of dependencies;
- my app must not share its dependencies with other installed applications;
- this app must always be updated to the latest version, even at the cost of updating without asking, I just want to use it;
- it must also be available for other users who use my pc;
- I want this app to be easy to install and remove using an extremely intuitive command;
- I want to summarize the whole installation process, including icons, launchers, info files and a script to remove all this in just one script.

APT (Debian) often includes too old programs that require too many dependencies, while the programs installed by AUR (Arch Linux) are not always reliable, especially in terms of dependencies, and PacMan by default does not include all the programs that APT manages. Flatpak takes up too much disk space, while Snap slows down PC resources. AppImage doesn't have a centralized repository capable of automatically managing updates and tools such as "appimaged" are not enough to integrate the program in the correct way into the system.

Finally I decided to write my own script, again.

I have already wrote [AppMan](https://github.com/ivan-hc/AppMan), an application manager for standalone programs and AppImages that works like APT or Pacman, so the main problem for me was to find a name for a new command that was short, easy to remember and that fully reflected its purpose... failing!

In the end I chose the most self-centered, obvious, stupid... and bravest name that an amateur developer could give to an application manager: `app`!

------------------------------------------------------------------------
                                                                           
                AAA               PPPPPPPPPPPPPPPPP   PPPPPPPPPPPPPPPPP   
               A:::A              P::::::::::::::::P  P::::::::::::::::P  
              A:::::A             P::::::PPPPPP:::::P P::::::PPPPPP:::::P 
             A:::::::A            PP:::::P     P:::::PPP:::::P     P:::::P
            A:::::::::A             P::::P     P:::::P  P::::P     P:::::P
           A:::::A:::::A            P::::P     P:::::P  P::::P     P:::::P
          A:::::A A:::::A           P::::PPPPPP:::::P   P::::PPPPPP:::::P 
         A:::::A   A:::::A          P:::::::::::::PP    P:::::::::::::PP  
        A:::::A     A:::::A         P::::PPPPPPPPP      P::::PPPPPPPPP    
       A:::::AAAAAAAAA:::::A        P::::P              P::::P            
      A:::::::::::::::::::::A       P::::P              P::::P            
     A:::::AAAAAAAAAAAAA:::::A      P::::P              P::::P            
    A:::::A             A:::::A   PP::::::PP          PP::::::PP          

------------------------------------------------------------------------

 >>  Enjoy your applications without thinking about anything else   <<   
  
------------------------------------------------------------------------

[Installation](#installation)

[Usage](#usage)

[Updates](#updates)

[Multiarchitecture](#multiarchitecture)

[Repository](#repository)

[Scripts and rules](#scripts-and-rules)

[How to uninstall "APP"](#how-to-uninstall-app)

[How to uninstall a program using "APP"](#how-to-uninstall-a-program-using-app)

[How to uninstall a program without "APP"](#how-to-uninstall-a-program-without-app)

[Conclusions](#conclusions)

-----------------------

The `app` command is very similar to [AppMan](https://github.com/ivan-hc/AppMan), but in this case [here are less inbuilt options](#usage), because here are less things to do:

-`app` is built to allow integration in the system and automatic updates for each application, so the final user must do nothing but just using the application;
- this tool can only install or remove the desired application, updates are at the complete discretion and management of the latter;
- using the `app` command to install/remove standalone apps is as easy and ridiculous as typing a command at random, out of desperation!

-----------------------

# Installation
Copy/paste this command:

`wget https://raw.githubusercontent.com/ivan-hc/APP-Manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

This will download the ["APP-COMMAND"](https://github.com/ivan-hc/APP-Manager/blob/main/APP-COMMAND) script in /opt/app, a symlink for it in /usr/bin named `app` and the /opt/app/remove script needed to uninstall `app`.

# Usage

  `app [option]`
  
  where option include:
  
  `-h`, `help`	Prints this message.

  `-f`, `files`	Shows the installed programs managed by "APP".

  `-s`, `sync`	Updates "APP" to a more recent version.

  -----------------------------------------------------------------------
      
  `app [option] [argument]`
  
  where option include:
  
  `-i`, `install` Install a program. This will be taken directly from the
  		repository of the developer (always the latest version):
  		- the installer is stored in /opt/app/programs;
  		- the command is linked to a $PATH;
		- the program is stored in /opt/<program> with a script to
	    	remove this and all the files listed above.
		The icon and the launcher are optional for no-ui programs.
  		APP uses both AppImages and other standalone programs.
  		
  `-r`, `remove` Removes the program and all the other files listed above
  		using the instructions in /opt/app/remove/<program>.
  		Confirmation is required (Y or N, default is N).

# Updates
Each script will create, among other things, another update-oriented script, which can be activated when the program itself starts or by adding a relative `<program>-update` between the processes that you want to start at login. To make this possible, each user must be given the necessary permissions on each program folder.

NOTE that the AppImages are using [appimageupdate](https://github.com/AppImage/AppImageUpdate), a command line tool available for both i386 and x86_64 architectures, install it using the command:
	
`sudo app install appimageupdate`
	
#### WARNING! Programs that update at startup can slow down your system, and programs that include update at startup may take a long time to open before the update is complete.

# Repository
Each program is installed through a dedicated script.
	
The scripts listed in the "[repository](https://github.com/ivan-hc/APP-Manager/tree/main/programs)" are divided by architecture.
	
# Multiarchitecture
Currently my work focuses on applications for x86_64 architecture, but it is possible to extend "APP" to all other available architectures.

If you are interested, you can deliberately join this project.

# Scripts and rules	
Once you've performed the command:
	
`sudo app install $PROGRAM`
	
The script will create:
- a /opt/$PROGRAM folder containing the standalone app, an uninstaller script named `remove`* and other files (maybe related to the automatic updates);
- a symlink of /opt/$PROGRAM/$YOUR-APP-AND-HELPERS to a $PATH (ie /usr/local/bin, /usr/bin, /bin, /usr/local/games, /usr/games...);
- the icon, that can be placed, for example, in /usr/share/pixmaps or /usr/share/icons (optional for command line tools);
- the launcher in /usr/share/applications (optional for command line tools).
	
##### *NOTE that it is more important to have a /opt/$PROGRAM/remove script file, it must contain the path of all the files created by your script, learn more [here](#how-to-uninstall-a-program-using-app). 

# How to uninstall "APP"

`sudo app remove app`

# How to uninstall a program using "APP"
With "APP":

`sudo app remove <$PROGRAM>`

# How to uninstall a program without "APP"
	
`sudo /opt/$PROGRAM/remove`

# Conclusions
As you can see, you're free to do whatever you want with your script! The rules of the `app` command are few and the commands to use even fewer.

I personally will try to import so many scripts from [AppMan](https://github.com/ivan-hc/AppMan) as possible (if I'll have time enough).
	
I created this program because I was bored every time I had to look for the new version of a program... and after all, even the name of the command, "app", I decided out of boredom.
	
### And since the "app" command has not yet been invented by anyone, I gladly take advantage of it.

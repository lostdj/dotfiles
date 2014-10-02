# ThinkPad W520.

{ config, pkgs, lib, ... }:

with builtins;
with lib;

let
	privy = (import ./privy.nix) { config = config; pkgs = pkgs; lib = lib; };

	cfg = mkMerge
	[
	# ----------------------------------------
	{
		my.pkgOverrides =
		[(p: rec {
			#grub2 = p.grub2.override { zfsSupport = false; };
			#grub2_zfs = p.grub2_zfs.override { zfsSupport = false; };
			#grub2_zfs = p.grub2;
		})];

		environment.systemPackages = with pkgs;
		[
			grub2
		];

		boot.loader.grub =
		{
			enable = true;
			version = 2;
			device = "/dev/sda";
		};
	}


	# ----------------------------------------
	{
		boot.initrd =
		{
			availableKernelModules =
			[
				"ehci_pci"
				"ahci"
				"firewire_ohci"
				"xhci_hcd"
				"usb_storage"
			];

			luks =
			{
				cryptoModules =
				[
					"aes"
					"aes_generic"
					"blowfish"
					"twofish"
					"serpent"
					"cbc"
					"xts"
					"lrw"
					"sha1"
					"sha256"
					"sha512"
					"aes_x86_64"
				];

				devices =
				[{
					name = "encd-zplews";
					device = "/dev/sda2";
				}];
			};
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			linuxPackages.spl
			linuxPackages.zfs
		];

		boot =
		{
			loader.grub =
			{
				#extraConfig = "insmod zfs";
			};

			kernelModules =
			[
				"spl"
				"zfs"
			];

			supportedFilesystems = [ "zfs" ];
			
			spl.hostid = "0xdeadbabe";

			extraModprobeConfig =
			# TODO: Not working? Put this in postBootCommands?
			/*''
				options zfs zfs_arc_min=33554432
				options zfs zfs_arc_max=536870912
				options zfs zfs_arc_meta_limit=134217728
			''*/
			'''';
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			# If you are installing on a recent Thinkpad that has an Ivy Bridge
			# or newer processor (X230, T430, T530, etc.), tp_smapi will not work.
			linuxPackages.tp_smapi /* http://www.thinkwiki.org/wiki/Tp_smapi https://github.com/evgeni/tp_smapi */
			/* disk_indicator https://github.com/MeanEYE/Disk-Indicator */
			/* thinkfan nixpkgs / nixos / modules / services / hardware / thinkfan.nix */
			/* thinkpad_acpi kmod http://www.thinkwiki.org/wiki/Thinkpad-acpi */

			pmutils
			upower
			acpid
		];

		boot =
		{
			# TODO: TP
			extraModulePackages =
			[
				#
			];

			kernelModules =
			[
				"thinkpad_ec"
				"tp_smapi"
			];
		};

		services.upower.enable = true;

		services.acpid.enable = true; # FYI it's already enabled by nvidia drvs.

		hardware.trackpoint =
		{
			enable = true;
			emulateWheel = true;
		};

		services.xserver.synaptics =
		{
			enable = true;
			twoFingerScroll = true;
		};
	}


	# ----------------------------------------
	{
		boot =
		{
			kernelParams =
			[
				#"memmap=0x1000\$0x8c31e000"
				#"intel_iommu=on"
			];

			extraModulePackages =
			[
				#
			];

			kernelModules =
			[
				"kvm-intel"
				"iwlwifi"
				"iwldvm"
			];

			kernel.sysctl =
			{
				"fs.inotify.max_user_watches" = 100500;
			};

			cleanTmpDir = true;

			devShmSize = "5G";

			# Shell commands to be executed just before systemd is started.
			# postBootCommands = "";
		};

		hardware.enableAllFirmware = true;

		services.nscd.enable = false;
	}


	# ----------------------------------------
	{
		swapDevices = [ ];

		fileSystems =
		{
			"/" =
			{
				device = "zplews/sys/nixos/root1";
				fsType = "zfs";
			};

			"/boot" =
			{
				device = "/dev/sda1";
				fsType = "ext4";
			};

			"/tmp" =
			{
				device = "tmpfs";
				fsType = "tmpfs";
				options = "size=10g, mode=1777";
			};
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			tzdata
		];

		time =
		{
			hardwareClockInLocalTime = false;
			timeZone = "Europe/Moscow";
		};
	}


	# ----------------------------------------
	{
		i18n =
		{
			consoleKeyMap = "us";
			defaultLocale = "en_US.UTF-8";
			supportedLocales = [ "all" ];
		};
	}


	# ----------------------------------------
	{
		gnu = false;

		nixpkgs.config.allowUnfree = true;

		services.nixosManual.enable = false;

		nix =
		{
			maxJobs = pkgs.lib.mkOverride 0 2;

			binaryCaches = pkgs.lib.mkOverride 0
			[
				"http://cache.nixos.org"
				"https://hydra.nixos.org"
			];

			extraOptions =
			"
				gc-keep-outputs = true
				gc-keep-derivations = true
			";
		};

		boot.loader =
		{
			grub.copyKernels = true;

			generationsDir.copyKernels = true;
		};

		fileSystems =
		{
			"/opt/nixpkgs" =
			{
				device = "zplews/usr/nixos/nixpkgs";
				fsType = "zfs";
			};

			"/opt/nixpkgs/stable" =
			{
				device = "zplews/usr/nixos/nixpkgs/stable";
				fsType = "zfs";
			};
		
			"/opt/nixpkgs/master" =
			{
				device = "zplews/usr/nixos/nixpkgs/master";
				fsType = "zfs";
			};

			"/opt/nixpkgs/master-upstream" =
			{
				device = "zplews/usr/nixos/nixpkgs/master-upstream";
				fsType = "zfs";
			};
		};
	}


	# ----------------------------------------
	{
		environment.variables =
		{
			HISTFILESIZE = [ "9000" ];

			PATH =
			[
				"/mnt/zfs/levault/bin/"
			];

			NIX_PATH = pkgs.lib.mkOverride 0
			[
				"/opt/nixpkgs/stable"
				"nixpkgs=/opt/nixpkgs/stable"
				"nixos-config=/etc/nixos/configuration.nix"
				#"/nix/var/nix/profiles/per-user/root/channels/nixos"
			];
		};
	}


	# ----------------------------------------
	{
		users.mutableUsers = false;

		fileSystems."/home" =
		{
			device = "zplews/usr/nixos/home";
			fsType = "zfs";
		};
	}

	# ----------------------------------------
	{
		# `mkpasswd -m sha-512`
		security.initialRootPassword = privy.users.root.passwd;

		fileSystems."/root" =
		{
			device = "zplews/usr/nixos/home/root";
			fsType = "zfs";
		};
	}


	# ----------------------------------------
	{
		users.extraUsers.ltp =
		{
			uid = 1042;
			hashedPassword = privy.users.ltp.passwd;
			createHome = true;
			home = "/home/ltp";
			group = "gltp";
			extraGroups = [ "users" "wheel" ];
			shell = "/run/current-system/sw/bin/bash";
		};

		users.extraGroups.gltp.gid = 1042;

		fileSystems."/home/ltp" =
		{
			device = "zplews/usr/nixos/home/ltp";
			fsType = "zfs";
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			wpa_supplicant_gui
		];

		networking =
		{
			hostName = "lews";
			enableIPv6 = false;

			# Statically configured interfaces are set up by the systemd service interface-name-cfg.service.
			# The default gateway and name server configuration is performed by network-setup.service.
			#interfaces.eth0 = { ipAddress = "192.168.3.1"; /*prefixLength = 24;*/ subnetMask = "255.255.0.0"; };
			#defaultGateway = "192.168.1.1";
			#nameservers = [ "192.168.0.1" "8.8.8.8" ];

			wireless.enable = true;
			wireless.userControlled.enable = true;
			wireless.interfaces = [ "wlp3s0" ];

			#localCommands =
			#''
			#	ip -6 addr add 2001:610:685:1::1/64 dev eth0
			#'';

			firewall =
			{
				enable = false;
				#allowPing = true;
				#allowedTCPPorts = [ 80 443 ];
			};

			extraHosts =
			''
				0.0.0.0						hosts_0_0_0_0
				127.0.0.1					hosts_127_0_0_1
			'';
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			pulseaudioFull
			alsaLib
			alsaPlugins
			alsaUtils
			alsaOss
			phonon
			phonon_backend_vlc
			phonon_backend_gstreamer
		];

		sound.enable = true;
		hardware.pulseaudio.enable = true;
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			x11
			# xlibs.libX11 etc
		];

		services.xserver.enable = true;
		services.xserver.autorun = false;
		services.xserver.exportConfiguration = true;
		services.xserver.deviceSection =
		''
			Option "RegistryDwords" "EnableBrightnessControl=1"
		'';

		services.xserver.videoDrivers = [ "nvidia" ];
		hardware.opengl.enable = true;
		hardware.opengl.driSupport = true;
		hardware.opengl.driSupport32Bit = true;
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			stdenv_32bit
		];

		hardware.opengl.driSupport32Bit = true;
	}


	# ----------------------------------------
	{
		# fc-cache --really-force --verbose

		my.pkgOverrides =
		[(p: rec {
			freetype = p.freetype.override { useEncumberedCode = true; };
		})];

		environment.systemPackages = with pkgs;
		[
			freetype

			fontconfig
			xorg.fontsproto
			xorg.fontutil
		];

		environment.sessionVariables.LD_LIBRARY_PATH = [ "${pkgs.freetype}/lib" ];

		fonts =
		{
			enableFontDir = true;
			enableFontConfig = true;
			enableGhostscriptFonts = true;
			enableCoreFonts = true;
			fonts = with pkgs;
			[
				#wrapFonts
				andagii
				anonymousPro
				#arkpandora_ttf Failed to connect to www.users.bigpond.net.au
				aurulent-sans
				bakoma_ttf
				cantarell_fonts
				clearlyU
				cm_unicode
				comic-neue
				dejavu_fonts
				dosemu_fonts
				eb-garamond
				fira
				freefont_ttf
				gentium
				inconsolata
				ipafont
				junicode
				kochi-substitute-naga10
				kochi-substitute
				libertine
				lmodern
				lohit-fonts
				mph_2b_damase
				nafees
				oldstandard
				opensans-ttf
				poly
				liberation_ttf
				source-code-pro
				source-sans-pro
				source-serif-pro
				source-han-sans-japanese
				source-han-sans-korean
				source-han-sans-simplified-chinese
				source-han-sans-traditional-chinese
				#symbola wrong hash
				tempora_lgc
				terminus_font
				theano
				tipa
				ttf_bitstream_vera
				ubuntu_font_family
				ucsFonts
				unifont
				vistafonts
				wqy_microhei
				wqy_zenhei
				xorg.fontadobe100dpi
				xorg.fontadobe75dpi
				xorg.fontadobeutopia100dpi
				xorg.fontadobeutopia75dpi
				xorg.fontadobeutopiatype1
				xorg.fontbhlucidatypewriter100dpi
				xorg.fontbhlucidatypewriter75dpi
				xorg.fontbhttf
				xorg.fontbh100dpi
				xorg.fontbh75dpi
				xorg.fontmiscmisc
				xorg.fontcursormisc
				xorg.fontcronyxcyrillic
				xorg.fontdaewoomisc
				xorg.fontmisccyrillic
				xorg.fontmiscethiopic
				xorg.fontisasmisc
				xorg.fontjismisc
				xorg.fontsonymisc
				xorg.fontsunmisc
				xorg.fontwinitzkicyrillic
				xorg.fontxfree86type1
			];
		};
	}


	# ----------------------------------------
	{
		my.pkgOverrides =
		[(p: rec {
			kde4 = p.kde412;
		})];

		environment.systemPackages = with pkgs;
		[
			kde4.kdeaccessibility
			kde4.kdeadmin
			kde4.kdeartwork
			kde4.kdebindings
			kde4.kdegraphics
			kde4.kdemultimedia
			kde4.kdenetwork
			kde4.kdesdk
			kde4.kdeutils
			kde4.kdewebdev
			kde4.amarok.all
			kde4.calligra.all
			kde4.colord-kde.all
			kde4.digikam.all
			kde4.k3b.all
			kde4.kadu.all
			kde4.kde_gtk_config.all
			kde4.kde_wacomtablet.all
			kde4.kdeconnect.all
			kde4.kdenlive.all
			kde4.kdesvn.all
			kde4.kdevelop.all
			kde4.kdevplatform.all
			kde4.kdiff3.all
			kde4.kile.all
			kde4.kmplayer.all
			kde4.kmymoney.all
			kde4.konversation.all
			kde4.kvirc.all
			kde4.krename.all
			kde4.krusader.all
			kde4.ktorrent.all
			kde4.kuickshow.all
			kde4.networkmanagement.all
			kde4.psi.all
			#kde4.rekonq.all # Screws with everything.
			#kde4.telepathy.full
			#oxygen_gtk.all # Screws with Palemoon.
		];

		services.xserver.displayManager.kdm.enable = true;
		services.xserver.displayManager.kdm.extraConfig =
		"
			[X-*-Core]
			AllowRootLogin = true
		";

		services.xserver.desktopManager.kde4.enable = true;
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			openssh
		];

		services =
		{
			openssh =
			{
				enable = false;
				permitRootLogin = "yes";
			};
		};

		programs =
		{
			ssh.forwardX11 = true;
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			samba
		];

		services.samba =
		{
			enable = false;
		};

		fileSystems = privy.cifs.shares.kiwi;

		# Ex.
		/*fileSystems =
		{
			"/mnt/cifs/share" =
			{
				device = "//box.zone/share";
				fsType = "cifs";
				options = "uid=username,gid=1337,file_mode=0777,dir_mode=0777,rw,noperm,username=cifsUsername,password=cifsPasswd,sec=ntlm,iocharset=utf8";
			};
		};*/
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			nano
		];

		programs.nano.nanorc =
		"
			set fill 0
			set softwrap
			set nowrap
			set smooth
			set tabsize 2
		";
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			skype
		];

		networking.extraHosts =
		''
			127.0.0.1					ui.skype.com
			127.0.0.1					download.skype.com
			127.0.0.1					rad.msn.com
		'';
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			sublime3
		];

		networking.extraHosts =
		''
			127.0.0.1					sublimetext.com
			127.0.0.1					www.sublimetext.com
		'';
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			bittorrentSync
		];

		services.btsync =
		{
			enable = true;
			deviceName = "lews";
			checkForUpdates = false;
			useUpnp = false;
			enableWebUI = true;
			httpListenAddr = "127.0.0.1";
			httpListenPort = 9000;
			httpLogin = privy.btsync.login;
			httpPass = privy.btsync.passwd;
			encryptLAN = true;
		};

		networking.extraHosts =
		''
			127.0.0.1					btsync.lews
		'';
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			pgadmin
			mysqlWorkbench
		];
	}


	# ----------------------------------------
	{
		my.pkgOverrides =
		[(p: rec {
			postgresql = p.postgresql93;
		})];

		environment.systemPackages = with pkgs;
		[
			postgresql
		];

		users.extraUsers.postgres.hashedPassword = privy.users.postgres.passwd;

		services.postgresql =
		{
			enable = true;
			package = pkgs.postgresql;
			dataDir = "/mnt/zfs/levault/local/pg";
			enableTCPIP = false;
			authentication =
			''
				local all postgres ident
			'';
		};
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			git
			subversion
			mercurial

			smartgithg

			cmake

			SDL
			openal
		];
	}


	# ----------------------------------------
	{
		my.pkgOverrides =
		[(p: rec {
			jdk = p.oraclejdk7;
			jdkdistro = p.oraclejdk7distro;
			#jre = p.oraclejre7;
			jre = jdk;

			ant = p.apacheAnt;
		})];

		environment.systemPackages = with pkgs;
		[
			jdk
			#jre

			ant

			ideas.idea-community
		];
	}


	# ----------------------------------------
	{
		my.pkgOverrides =
		[(p: rec {
			wine = p.wineUnstable;
			winetricks = p.winetricks.override { wine = p.wineUnstable; };
		})];

		environment.systemPackages = with pkgs;
		[
			wine
			winetricks # `winetricks atmlib gdiplus msxml3 msxml6 vcrun2005 vcrun2005sp1 vcrun2008 ie6 fontsmooth-rgb gecko`
		];
	}


	# ----------------------------------------
	{
		nixpkgs.config.firefox.enableAdobeFlash = true;
		#nixpkgs.config.firefox.enableVlc = true;
		nixpkgs.config.firefox.enableDjvu = true;
		nixpkgs.config.firefox.jre = true;

		nixpkgs.config.chromium.enablePepperFlash = true;
		nixpkgs.config.chromium.enablePepperPDF = true;

		my.pkgOverrides =
		[(p: rec {
			#firefox = p.firefoxWrapper; # Infinite rec.
		})];


		environment.systemPackages = with pkgs;
		[
			firefoxWrapper

			#chromiumBeta
		];
	}


	# ----------------------------------------
	{
		environment.systemPackages = with pkgs;
		[
			gptfdisk

			htop
			jnettop
			iotop

			mkpasswd
			mc
			curl
			wget
			unzip

			python2

			vlc
			viewnior

			firefox
			thunderbird
		];
	}
	]; # /mkMerge cfg


	# ----------------------------------------
	#cfgf = import ./cfg.nix;
	#cfg_ = cfgf { lib = lib; config = config; pkgs = pkgs; };
	cfg_ = mkMerge
	(
		(map (co: (removeAttrs co [ "my" ])) cfg.contents)

		++

		[{
			nixpkgs.config.packageOverrides = origPkgs:
				let
					pkgMapper = { rest, origPkgs }:
						if rest != [] then
							if (head rest) == [] then
								pkgMapper { rest = tail rest; origPkgs = origPkgs; }
							else
								((head (head rest)) origPkgs)
								// pkgMapper { rest = tail rest; origPkgs = origPkgs; }
						else
							{};
				in
					#trace (map (co: if (hasAttr "my" co && hasAttr "pkgOverrides" co.my) then co.my.pkgOverrides else []) cfg.contents)
					pkgMapper
					{
						rest =
							map
							(co:
								if (hasAttr "my" co && hasAttr "pkgOverrides" co.my) then
									co.my.pkgOverrides
								else
									[]
							)
							cfg.contents;
						origPkgs = origPkgs;
					};
		}]
	);
in
	cfg_


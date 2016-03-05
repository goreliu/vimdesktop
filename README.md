## ![icon](doc/images/vimdesktop_32.jpg) VimDesktop

让所有 Windows 桌面程序拥有 Vim 操作风格的辅助工具

### 下载地址
[最新版本](https://github.com/goreliu/vimdesktop/releases/latest)

[开发版本（无exe，请使用ahk运行）](https://github.com/goreliu/vimdesktop/archive/master.zip)

### VimDesktop介绍

[中文版](https://github.com/goreliu/vimdesktop/wiki)

[English version](https://github.com/goreliu/vimdesktop/wiki/VimDesktop-Introduction-%5BEnglish-Version%5D)

[TC 快捷键列表](https://github.com/goreliu/vimdesktop/wiki/TC%E5%BF%AB%E6%8D%B7%E9%94%AE%E5%88%97%E8%A1%A8)

<a href="http://htmlpreview.github.io/?https://github.com/goreliu/vimdesktop/blob/master/doc/api.html" target="_blank">API</a>

[更新历史](https://github.com/goreliu/vimdesktop/blob/master/doc/HISTORY.md)

[TODO](https://github.com/goreliu/vimdesktop/blob/master/doc/TODO.md)

### 其他版本的 VimDesktop

[linxinhong](http://git.oschina.net/linxinhong) 的原版 VimDesktop （开发处于停滞状态）：[oschina地址](http://git.oschina.net/linxinhong/VimDesktop) [github地址（已弃用）](https://github.com/linxinhong/VimDesktop)

[linxinhong](http://git.oschina.net/linxinhong) 的 ViATc （VimDesktop 的前身，已停止更新）：[github地址](https://github.com/linxinhong/ViATc) [sourceforge地址](https://sourceforge.net/p/viatc/home/%E4%B8%BB%E9%A1%B5/)

[victorwoo](https://github.com/victorwoo) 的 VimDesktop （基于老版本的 linxinhong 版本的 VimDesktop 修改，已经一年多无更新）：[github地址](https://github.com/victorwoo/vimdesktop)

### 此版本 VimDesktop 的历史和缘由

我2016年1月接触到的 VimDesktop，当时在网上搜到了两个版本的 VimDesktop，如上所述。我分别试用后感觉 [victorwoo 版本](https://github.com/victorwoo/vimdesktop) 的好用些，主要是 `TotalCommander_Dialog` 插件很有用，配置文件也更方便些，当时并未考虑过修改代码。但使用过程中慢慢发现一些问题，或者有功能缺失，改了很多代码。修改过程中，发现这个版本的核心文件 `lib/vimcore.ahk` 缺陷比较多，功能也相对薄弱，而 [linxinhong 版本](http://git.oschina.net/linxinhong/VimDesktop) 的`lib/class_vim.ahk` 是 `lib/vimcore.ahk` 的升级版，功能更强大，缺陷也少些。于是改用 [linxinhong 版本](http://git.oschina.net/linxinhong/VimDesktop) 的部分核心文件，而插件部分还是沿用之前的代码，除了必要的兼容性改动。

此版本包含 [victorwoo 版本](https://github.com/victorwoo/vimdesktop) 和 [linxinhong 版本](http://git.oschina.net/linxinhong/VimDesktop) 的全部功能。

### 贡献及技术支持

官方 QQ 群: 271105729 （QZ/VimD/TC/AHK）

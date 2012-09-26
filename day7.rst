************************
Day 7 建置私有雲測試平台
************************

建置 Micro Cloud Foundry
========================

Micro Cloud Foundry 可以方便開發者在自己的電腦建立 PaaS 的測試環境，它提供的功能和 Cloud Foundry 開放的 PaaS 完全相同，但只要透過 VMWare Player 等虛擬機器軟體，就能在開發者的電腦執行。

通常開發框架（frameworks）都會提供測試的工具，例如 Ruby on Rails 使用 WEBrick 作為開發端測試的伺服器；在開發階段，應用程式必須先利用開發框架的方法測試，功能沒有問題再發佈到 PaaS。但是 PaaS 畢竟與開發端的環境不會完全相同，應用程式發佈到 PaaS 仍需要再次仔細測試，才會知道程式有哪些部分需要修正。

Cloud Foundry 的應用程式，可以將一份專案發佈為不同名稱的應用程式，也可以發佈到不同的目標伺服器（target）。Micro Cloud Foundry 讓開發者可以在區域網路的環境中，建置測試專用的迷你 PaaS，讓尚處於開發、測試階段的應用程式，不必貿然發佈到正式（production）的 PaaS 服務，只要利用開發端的環境就可以測試發佈後的應用程式。

由於 Micro Cloud Foundry 與 Cloud Foundry 的 PaaS 功能一致，因此應用程式只要能在 Micro Cloud Foundry 發佈、測試成功，只需要切換目標伺服器（target），就能將應用程式發佈到正式的 PaaS。

使用帳號密碼登入 CloudFoundry.com 網站，可以看到 Manage 及 Downloads 兩個項目。點選「Download Micro Cloud Foundry VM」取得最新版的虛擬機器壓縮檔（例如：micro-1.2.0.zip），將下載的檔案解壓縮至桌面或其他磁碟位置。

.. image:: images/cloudfoundry-micro.png

下載的 ZIP 檔案解壓縮，會得到 micro-disk1.vmdk 及 micro.vmx 兩個檔案。其中 vmx 是 VMWare 的虛擬機器，可以使用下列的軟體開啟。

* VMWare Workstation
* VMWare Fusion
* VMWare Player

其中 Fusion 是 Mac OS X 系統專用，而 Workstation 及 Player 兩個版本則支援 Windows 及 Linux 作業系統。Fusion 與 Workstation 需要付費購買正版軟體，若讀者只有測試的需要，下載安裝免費的 VMWare Player 版本即可。

Micro Cloud Foundry 預設需要 VMWare 虛擬機器軟體，可以不必多加設定就能立即執行。除此之外，讀者其實還有其它選擇，例如支援 Windows、Linux 及 Mac OS X 的 VirtualBox 軟體，功能和 VMWare 的虛擬機器軟體類似，它也支援 VMWare 的 vmdk 虛擬磁碟檔案格式，因此 VirtualBox 能夠透過以下的設定步驟，成功執行 Micro Cloud Foundry。

建立新的虛擬機器，作業系統類型選擇 Linux / Ubuntu (64bit)。

.. image:: images/virtualbox-micro-01.png

記憶體建議至少配置 1024MB 以上。

.. image:: images/virtualbox-micro-02.png

不必建立新的虛擬磁碟，直接選擇解壓縮得到的 micro-disk1.vmdk 即可。

.. image:: images/virtualbox-micro-03.png

將網路設定為 Bridged Adapter 模式。

.. image:: images/virtualbox-micro-05.png

Micro Cloud Foundry 的主畫面。 

.. image:: images/micro-screen-01.png

Micro Cloud Foundry 的設定直接透過純文字畫面的選單操作，

1. configure （設定）
2. refresh console （重新顯示畫面）
3. expert menu （進階功能）
4. help （輔助說明）
5. shutdown VM （關機）

第一次執行需要先進行設定，按下選單代號 1 及 Enter，就會要求輸入一組新密碼。

::

    Set password Micro Cloud Foundry VM user (vcap)
    Password: ********
    Confirmation: ********

接下來是網路設定，可以選擇 DHCP 或 Static。若是只作為內部測試用途，使用區網 IP 位址即可。

::

    1. DHCP
    2. Static

登入 CloudFoundry.com 網站取得 token 代碼，輸入一組子網域名稱（英文小寫或數字、可用「-」符號），在本文的範例中，我們使用 your-cloud-name 這個命名。

.. image:: images/micro-token-1.png

設定完成後，會顯示一組 configuration token，務必將它記下來。

.. image:: images/micro-token-2.png

如果忘記 token，可以按 Regenerate Token 重新產生一組（但無法找回已遺失的 Toek）。

.. image:: images/micro-token-3.png

目前 CloudFoundry 無法支援自訂網域名稱，只能用 \*.cloudfoundry.me 的子網域，所以也是先搶先贏，讀者可以儘快將想要的名稱註冊保留。

::

    Enter Micro Cloud Foundry configuration token or offline domain name:

接下來等待 DNS 更新及安裝動作完成。

.. image:: images/micro-screen-config-done.png

設定完成之後的主畫面（範例）：

.. image:: images/micro-screen-02.png

用 ping 指令測試，出現虛擬機器的 IP 表示 Cloud Foundry 的 DNS 設定已經更新。

::

    ping your-cloud-name.cloudfoundry.me
    ping api.your-cloud-name.cloudfoundry.me

使用瀏覽器或 ``curl`` 指令，可以測試 PaaS 服務是否已成功啟用。

::

    curl http://api.your-cloud-name.cloudfoundry.me

如果服務尚未建立完成，會得到以下的錯誤訊息。

::

    Error (JSON 404): VCAP ROUTER: 404 - DESTINATION NOT FOUND

需要等待多久必須視機器的效能而定；當服務已經啟用完成，就可以得到以下的歡迎訊息。

::

    Welcome to VMware's Cloud Application Platform

使用 vmc 指令將目標伺服器（target）切換為 Micro Cloud Foundry 專用的 URL：

::

    vmc target api.your-cloud-name.cloudfoundry.me

因為新建的 Micro Cloud Foundry 並沒有開發者的帳號密碼，同時它也是獨立於 CloudFoundry.com 的服務，所以需要用 vmc 的 register 指令建立一組新帳號。

::

    vmc register

輸入電子郵件及密碼（可自訂、與 CloudFoundry.com 的帳號無關），等待新帳號建立完成。

::

    Email: 設定電子郵件信箱
    Password: 密碼
    Verify Password: 確認密碼
    Creating New User: OK
    Attempting login to [http://api.your-cloud-name.cloudfoundry.me]
    Successfully logged into [http://api.your-cloud-name.cloudfoundry.me]

執行 ``vmc register`` 指令之後，除了會建立一組帳號外，也會自動完成登入。若日後需要重新登入，或改以其它帳號登入，就必須執行 ``vmc login`` 指令。

在 ``vmc target`` 設定為 Micro Cloud Foundry 的 URL 後，就可以使用 ``vmc push`` 發佈應用程式。Micro Cloud Foundry 的操作方法，與 api.cloudfoundry.com 完全相同；在 Micro 建立的應用程式與服務，都是獨立在虛擬機器中運作，與 CloudFoundry.com 並不相干。


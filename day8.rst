****************
Day 8 佈署雲平台
****************

安裝 VCAP 伺服器
===============

前面介紹的 Cloud Foundry 包括 CloudFoundry.com 以及使用 Micro Cloud Foundry 建立開發測試專用的 CloudFoundry.me，都是由 VMWare 提供的 PaaS 服務。若需要建立私有 PaaS，或者想要像 VMWare、AppFog 一樣提供 PaaS 服務，就必須自行安裝架設 VCAP 伺服器。

VCAP 的全名是 VMware's Cloud Application Platform，它包含建立 Cloud Foundry PaaS 所需的程式，在 GitHub 網站可以取得完整的原始碼：

https://github.com/cloudfoundry/vcap

VCAP 可以安裝在多部實體或虛擬機器，作為節點，組成大型、可延展的 PaaS 服務平台，例如由 16 個 routers 及 8 個 cloud controller 來提供服務。

但開發者也可以只用一部虛擬機器、安裝 VCAP，就能建立一個麻雀雖小、五臟俱全的 PaaS；例如 Micro Cloud Foundry 就是以 Ubuntu Linux 安裝 VCAP 建立的虛擬機器。

安裝 VCAP 的軟硬體配置需求如下：

* Ubuntu Linux 64bit （下載： http://www.ubuntu.com/download/server/download ）
* 至少 1GB 記憶體

以筆者的測試環境來說，是使用 VirtualBox 4.1.12 虛擬機器軟體，配置 1GB 以上記憶體，網路卡使用橋接模式（方便區網其他機器建立連線），並安裝 Ubuntu Server 10.04.3 64bit，預先安裝 OpenSSH Server，以方便使用 ssh 進行後續的安裝設定。

VCAP 提供相當簡便的 shell script 安裝程式，以下的指令從 GitHub 網站取得 vcap_dev_setup 程式，執行後就會開始一連串自動化的安裝程序；在過程中會自動下載安裝所需的檔案，請確保網路連線暢通、並避免機器不正常關閉或終止安裝程式。

::

    wget https://raw.github.com/cloudfoundry/vcap/master/dev_setup/bin/vcap_dev_setup
    chmod a+x vcap_dev_setup
    ./vcap_dev_setup

安裝完成後，需要先登出，再重新登入一次，這樣 VCAP 的設定才會載入，接著就可以啟動 vcap_dev 服務。

::

    ~/cloudfoundry/vcap/dev_setup/bin/vcap_dev start

使用虛擬機器安裝 VCAP 是個理想的選擇，在安裝過程中，每個步驟成功後，可以立刻建立 SNAPSHOT 將階段保存起來，方便後續發生問題可以還原。未來需要增加 PaaS 的節點時，也只需要將虛擬機器複製一份，省下每次都要重新安裝 VCAP 的麻煩。

Cloud Foundry 提供一組 ``vcap.me`` 的網域名稱，讓 VCAP 安裝者可以方便進行測試；若使用 ping 或 nslookup 查詢這個網域，可以發現它其實對應到 localhost（127.0.0.1）。

::

    $ nslookup vcap.me

    Non-authoritative answer:
    Name:   vcap.me
    Address: 127.0.0.1

我們通常不會直接用 VCAP 伺服器開發應用程式，例如我們可能在一台開發用的機器（192.168.0.100），需要將應用程式發佈到安裝 VCAP 伺服器的虛擬機器（192.168.0.101）；Cloud Foundry 建議的作法，是利用 ssh 指令建立通道。

以下的指令將 localhost 的 80 或 8080 連接埠對應到虛擬機器，john@192.168.0.101 是此範例的 Ubuntu Server 登入帳號及區網 IP 位址（若 80 連接埠已經被其他程式佔用，可以改為 8080 或其它數字）。

::

    sudo ssh -L 80:192.168.0.101:80 john@192.168.0.101 -N

接下來，就可以將目標伺服器（target）切換為 vcap.me，例如：

::

    vmc target api.vcap.me

使用 ``vmc push`` 等指令，就可以將應用程式發佈到以 VCAP 建立的 PaaS 服務。

對於有開發 PaaS 平台需求的廠商來說，開放源碼的 VCAP 是個相當好的基礎，可以不必重新發明輪子、設計複雜的底層架構問題，更能專注於開發更有價值的服務，例如將自家的程式語言、開發框架、服務及工具整合到 Cloud Foundry；對於應用程式開發者來說，只要熟悉 VMC 工具的操作及 Cloud Foundry 的基本認識，就能選擇各家以 Cloud Foundry 為基礎建立的 PaaS 服務。

如果讀者想瞭解更多關於 VCAP 的技術，可以瀏覽 CloudFoundry.org 提供的文件、原始碼、部落格或郵件論壇等服務，相信只要更多人認識並參與 Cloud Foundry 的發展，開放源碼 PaaS 的未來就會更加美好。

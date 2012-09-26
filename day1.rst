*************************
Day 1 認識 Cloud Foundry
*************************

開放源碼的雲端解決方案
======================

全球虛擬化技術領導廠商 VMWare，近年致力於發展雲端解決方案，推出包含 vCloud 等「基礎架構即服務」（IaaS，Infrastructure as a Service）。VMWare 在併購 SpringSource 後，更積極發展「平台即服務」（PaaS，Platform as a Service），此舉揭示 VMWare 佈局雲端產品的企圖心，以下是 VMWare 近年的發展：

* 2009年併購 SpringSource 公司，旗下開放源碼的 Spring Framework 是被廣泛採用的 Java 應用程式開發框架。
* 2010年與 Google 公司合作，使 Google App Engine 支援佈署 Spring Java 應用程式。
* 2011年推出 Cloud Foundry，是業界第一款開放源碼 PaaS。

VMWare 的虛擬化技術能夠滿足企業對 IaaS 的需求，但是 IaaS 若少了配套的 PaaS 方案，對企業來說就像擁有硬體卻缺少合適的軟體，並無法滿足在雲端部署資訊系統的需求；因此，Cloud Foundry 的發展，對於採用 VMWare 虛擬化技術的企業來說，帶來更多往雲端發展的願景。 

將應用程式發佈到雲端平台，就能使用平台提供的便利服務，例如免除伺服器安裝設定的麻煩、輕鬆享有較高規格的防火牆及安全性，應用程式得到良好的水平可延展性（horizontal scalability），不必擔心未來大量成長造成硬體不敷使用、架構需要大幅調整，費用部分也可依照實際需求付費，減少過度投資造成的浪費。

雖然「平台即服務」的構想很美好，但開發者很容易被各種因素困擾：

1. 現有的軟體是否需要大幅修改？
2. 能不能將應用程式遷移到其它 PaaS 服務？
3. 是否要學習新技術、API？

Cloud Foundry 是開放源碼的 PaaS 解決方案，它的授權方式跟 Google Android 同樣都是 Apache License，因此除了商標之外，開發社群可以複製、修改及散佈 Cloud Foundry 開放分享的原始碼，廠商不僅可以使用 VMWare 提供的開放平台服務，也可以自行架設或選擇其它平台服務商採用 Cloud Foundry 為基礎提供的服務。

作為一個開放的 PaaS 解決方案，Cloud Foundry 能相容於許多已廣受開發者採用的技術；例如 Java、Ruby 及 PHP 等程式語言及 MySQL、PostgreSQL 等資料庫；對不少開發者而言，不需要重新學習新的程式語言、開發框架，只要瞭解發佈到雲端的方法及架構需要做的調整，就能享受佈署 PaaS 所帶來的好處。

但是過去已經建置的應用程式，若想佈署到 Cloud Foundry，需不需要大幅修改呢？其實 Cloud Foundry 對應用程式並沒有太多規範，但這個問題與應用程式的架構及採用的開發框架有關，舉例來說，若是使用 Rails 或 Grails 開發框架，對資料庫的存取多一層 ORM 的抽象化處理，並且也考慮到可擴展性（scalability）問題，例如使用網路磁碟或 Amazon S3 等雲端儲存服務，取代直接對本地磁碟的檔案存取，要佈署到 Cloud Foundry 幾乎毫不費力。

若是考慮遷移到其它 PaaS 的問題，就需要慎選多數 PaaS 能相容的組合，雖然 Cloud Foundry 支援相當多程式語言及框架，但其它 PaaS 並不見得能夠提供相容。舉例來說，Cloud Foundry 支援 Node.js 框架，而 Windows Azure、Heroku...等許多 PaaS 也都提供 Node.js 的支援，若以 Node.js 開發應用程式，想要順利遷移就比較不成問題。

Cloud Foundry 的平台及工具
==========================

Cloud Foundry 目前開放的網站有兩個，CloudFoundry.com 是 VMWare 公司以 vSphere 產品為基礎架構的開放服務，開發者只需要註冊一組帳號，就能將應用程式發佈到這個免費的 PaaS 平台。而 CloudFoundry.org 網站則是提供給開放原始碼社群，想要深入了解 Cloud Foundry 的技術、取得原始碼及參與討論等，可以利用這個網站提供的資訊。

VMWare 也發行名為 Micro Cloud Foundry 的虛擬機器，它的功能與 CloudFoundry.com 提供的服務相同，但是縮小到可以在開發者自有的機器上運作，利用 VMWare Player / Workstation / Fushion 等虛擬機器軟體即可執行。

開發者或企業在區域網路架設私有的 Micro Cloud Foundry，即可任意將應用程式發佈到這個迷你雲。由於 Micro Cloud Foundry 的功能和 CloudFoundry.com 一致，應用程式在開發過程可以先發佈到 Micro Cloud Foundry，功能、安全機制尚未完整的應用程式，就可以在這個沙盒中進行測試，等到準備正式上線時，就可以直接發佈到 CloudFoundry.com 或其他以 Cloud Foundry 建立的 PaaS 服務。

Cloud Foundry 的原始碼專案使用 GitHub 托管，目前發行的兩個主要專案有 VMC 及 VCAP。VMC 是應用程式開發端的工具，採用 Ruby 程式語言開發，用於發佈、維護管理 PaaS 的應用程式。VCAP（VMWare Cloud Application Platform）是伺服器端的軟體，同樣以 Ruby 開發，它包含提供 PaaS 服務所需的元件（如 cloud controller、health manager、dea、router、...等），雖然 VCAP 的目標是建立雲端的平台，但使用 VCAP 的硬體環境也可以很精簡，即使只用一部虛擬機器也可以開始建構 PaaS。

Cloud Foundry 的 GitHub 專案位址 https://github.com/cloudfoundry

VMC 是 command-line 的指令工具，開發者需要熟悉在終端機下使用文字指令工作。Cloud Foundry 也提供 Eclipse 軟體的 Plugin 套件，造福習慣使用圖形化整合開發環境的開發者，最簡易的使用方式就是先取得 SpringSource 推出的 STS（SpringSource Tool Suite）開發工具，再以內建的 Dashboard 加裝 Cloud Foundry 套件。

SpringSource Tool Suite http://www.springsource.com/developer/sts

.. image:: images/sts-cloudfoundry-plugin.png
   :width: 80%
   :align: center

目前 VMWare 官方版本的 Cloud Foundry，可以支援 Java、Ruby、JavaScript 等程式語言，其中 Java 部分亦包含愈來愈盛行的 JVM Scripting 語言如 Groovy 與 Scala，開發框架也支援廣受歡迎的 Spring、Lift、Play 及 Grails。而 JavaScript 所指並非前端瀏覽器的 JavaScript，而是可以在伺服器執行的 CommonJS 規範，也就是目前相當受矚目的 Node.js。至於 Ruby on Rails 相信大多開發者都已耳熟能詳，Sinatra 對 Ruby 開發者也不陌生。

======== ============
開發框架   程式語言
======== ============
Spring   Java
Lift     Scala
Play     Scala/Java
Grails   Groovy
Sinatra  Ruby
Rails    Ruby
Node.js  JavaScript
======== ============

Cloud Foundry 是開放源碼的 PaaS，其它廠商能夠自由參與開發社群，支援的程式語言及開發框架也日益豐富。目前比較活躍的社群夥伴開發商有：

1. Joyent

   提供軟體開發商雲端解決方案，其客戶包括 LinkedIn 等。Node.js 也是 Joyent 的產品，目前 Cloud Foundry 提供的 Node.js 就是由 Joyent 提供支援及維護。
2. ActiveState
   
   推出 Stackato 用於建構私有雲，是以 Cloud Foundry 為基礎、相容 vSphere 的產品，並可支援擁有廣大開發者使用的 ActivePython 及 ActivePerl。
2. AppFog
   
   目前提供 PHP Fog 是支援 PHP 及 MySQL 的 PaaS 服務，AppFog 也將支援 PHP 應用程式的 Cloud Foundry 開放原始碼回饋給社群。未來 AppFog 以 Cloud Foundry 發展的 PaaS，將能更廣泛支援 PHP、Node.js、Ruby、Python、Java、.NET 等技術。

除了對程式語言及開發框架的支援，Cloud Foundry 也提供服務（Services），包含關聯式資料庫 MySQL、PostgreSQL，以及 NOSQL 解決方案的 MongoDB 與 Redis，還有 RabbitMQ 訊息佇列服務。

若是 Cloud Foundry 及社群夥伴廠商提供的服務，也就是支援的程式語言、開發框架或資料庫種類，還是不能滿足應用程式開發的需求；或者需要自行架設私有雲 Private PaaS，就需要安裝建置 VCAP。VCAP 是 VMware's Cloud Application Platform 的縮寫，Cloud Foundry 提供的 PaaS 服務，就是利用 VCAP 建置的平台。

VCAP 是開放原始碼授權，開發者可以擴充它的程式，自行加上 Runtime（支援更多程式語言）、Framework（支援更多開發框架）或 Service（支援更多資料庫類型）。對於發展 PaaS 的廠商來說，使用 Cloud Foundry 開放的 VCAP 為基礎，就可以減少重複開發底層架構的成本，將重點擺在主要的功能擴充上，例如加上 Mono 以支援 .NET 應用程式等。



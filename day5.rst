***************
基礎程式調校與除錯
***************

應用程式調校與除錯技巧
==================

Cloud Foundry 將執行階段使用的參數，透過環境變數方式傳遞給應用程式，這種設計讓不同作業系統及程式語言有共同的存取方法。在前面的章節介紹過 Ruby Sinatra 簡易應用程式的佈署，為了觀察環境變數、方便進行除錯、測試及取得資訊，我們可以用 Sinatra 撰寫簡易的程式，將環境變數 ``ENV['VCAP_SERVICES']`` 完整印出以供開發者參考。

::

    require 'sinatra'

    get '/env' do
        ENV['VCAP_SERVICES']
    end

需要注意的地方是安全議題，在一般訪客可以存取的頁面，請勿為了方便將環境變數傾印，這可能會造成系統安全的漏洞。

將應用程式發佈到 Cloud Foundry 雲端時，有可能遇到啟動失敗或執行錯誤的情況，此時需要查看記錄檔進行偵錯。Cloud Foundry 將應用程式的記錄檔案放在雲端儲存空間的 ``logs`` 資料夾路徑下，使用以下指令可以列出 ``logs`` 資料夾包含的檔案清單：

::

    vmc files myfirstblog logs

對於大部分的應用程式，\ ``logs`` 資料夾至少會包含以下的記錄檔：

* stdout.log
* stderr.log

上述的檔案從檔名可以判斷，就是對應到標準輸出（STDIN）及標準錯誤輸出（STDOUT）。這是一般應用程式共通的標準，程式在執行時顯示在終端機（Terminal）畫面的文字訊息，Cloud Foundry 會將原本顯示在終端機的訊息重導（redirect）至文字檔，若是一般訊息會儲存到 stdout.log，如果程式發生錯誤就會將訊息則儲存至 stderr.log。

查看記錄檔的方法，可以使用檔案完整的路徑： 

::

    vmc files myfirstblog logs/stderr.log

另外也可以使用 VMC 提供的 ``logs`` 指令，以及用來檢查應用程式當機的 ``crashes`` 及 ``crashlogs`` 指令：

::

    vmc logs myfirstblog
    vmc crashes myfirstblog
    vmc crashlogs myfirstblog

查詢應用程式目前的執行狀態，可以透過 ``stats`` 指令查詢：

::

    vmc stats myfirstblog

將應用程式發佈到 Cloud Foundry 等雲端架構的 PaaS 平台，更容易進行水平擴充（scale out）的好處，藉由雲端的基礎設施得到更好的可延展性（scalability）；在應用程式需要更大的負載量時，透過增加 Instances 的方式，就可以讓應用程式擁有更多處理器及記憶體的資源。

在預設情況下，Cloud Foundry 的應用程式只會有一個 Instance。

::

    +----------+-------------+----------------+--------------+-------------+
    | Instance | CPU (Cores) | Memory (limit) | Disk (limit) | Uptime      |
    +----------+-------------+----------------+--------------+-------------+
    | 0        | 0.3% (4)    | 54.9M (256M)   | 50.0M (2G)   | 0d:0h:7m:9s |
    +----------+-------------+----------------+--------------+-------------+

增加 Instances 數量，可以讓應用程式效能提昇，因此能承受更高的負載量；由於 PaaS 通常以用量計費，專案開發初期只需要使用一個 Instance 就已足夠，之後隨時可以依照流量增加或減少 Instances 數量。調整 Instance 數量的指令是：

::

    vmc instances myfirstblog 3

執行上述的指令，Instances 數量就會擴充為 3 個。Cloud Foundry 的免費方案有記憶體總容量限制，所以 Instances 佔用的記憶體總量不能超過其限制，否則就會顯示調整失敗的訊息。執行成功後，重新以「vmc stats myfirstblog」指令查看狀態，可以發現 Instances 數量已經改變。

::

    +----------+-------------+----------------+--------------+--------------+
    | Instance | CPU (Cores) | Memory (limit) | Disk (limit) | Uptime       |
    +----------+-------------+----------------+--------------+--------------+
    | 0        | 0.4% (4)    | 54.9M (256M)   | 50.0M (2G)   | 0d:0h:6m:31s |
    | 1        | 0.5% (4)    | 52.7M (256M)   | 50.0M (2G)   | 0d:0h:4m:24s |
    | 2        | 0.5% (4)    | 52.8M (256M)   | 50.0M (2G)   | 0d:0h:4m:24s |
    +----------+-------------+----------------+--------------+--------------+


建置 MySQL 資料庫
================


使用 VMC 的「create-service」指令建立新服務。

::

    vmc create-service

輸入數字 5 並按 Enter 鍵，選擇建立 MySQL 資料庫。

::

    1: rabbitmq
    2: mongodb
    3: redis
    4: postgresql
    5: mysql
    Which service would you like to provision?: 

新的 MySQL 資料庫服務建立成功後，系統會回應 OK 的訊息如下。

::

    Creating Service [mysql-50d38]: OK

雖然我們只要在應用程式將環境變數傾印出來，可以取得 MySQL 資料庫的資訊；但我們無法直接使用 MySQL Client 建立連線，因為這些服務僅提供 PaaS 的應用程式連結。但開發者無法存取資料庫，對資料的維護、備份作業來說，實在相當不容易進行，為此 Cloud Foundry 提供 tunnel 的方式，讓開發者的電腦與 PaaS 服務之間可以建立一條虛擬的通道。

以下的指令會建立 tunnel 連結到 mysql-50d38 服務。

::

    vmc tunnel mysql-50d38

請注意，在第一次使用時，程式可能會提示缺少 Ruby 的 ``caldecott`` 套件，此時我們需要先用 RubyGems 安裝。

::

    gem install caldecott

在 tunnel 建立後，程式會詢問你需要執行哪一種指令，以 MySQL 為例，預設提供兩組指令：mysqldump 及 mysql，分別適用於資料備份及維護管理。由於指令是在 local 端執行，所以前提是系統也必須先裝有 MySQL Client 程式，並且 mysqldump 及 mysql 程式路徑必須包含在 PATH 環境變數中，讀者可以先執行 ``mysql --version`` 檢查程式是否存在。

::

    Starting tunnel to mysql-50d38 on port 10000.
    1: none
    2: mysqldump
    3: mysql

輸入 3 即可透過 MySQL Client 建立資料庫存取連線，如此便可直接下 SQL 語法進行資料庫調校及維護。


************************
Day 6 基礎程式調校與除錯
************************

應用程式調校與除錯
===============

在正式的應用程式中，傾印環境變數的資訊並不是安全的作法；因此，開發者可以建立測試專用的應用程式，方便進行除錯、測試及取得資訊，例如以下是以 Sinatra 撰寫的簡易範例，用來將 ``ENV['VCAP_SERVICES']`` 內容印出。

::

    require 'sinatra'

    get '/env' do
        ENV['VCAP_SERVICES']
    end

雖然我們只要將環境變數傾印出來，可以取得 MySQL 資料庫的資訊，但我們無法直接使用 MySQL Client 建立連線，因為這些服務僅提供 PaaS 的應用程式連結。但開發者無法存取資料庫，對資料的維護、備份作業來說，實在相當不容易進行，為此 Cloud Foundry 提供 tunnel 的方式，讓開發者的電腦與 PaaS 服務之間可以建立一條虛擬的通道。

以下的指令會建立 tunnel 連結到 mysql-50d38 服務。

::

    vmc tunnel mysql-50d38

第一次使用時，程式可能會提示缺少 Ruby 的 ``caldecott`` 套件，我們需要先用 RubyGems 安裝：

::

    gem install caldecott

在 tunnel 建立後，程式會詢問你需要執行哪一種指令，以 MySQL 為例，預設提供兩組指令 mysqldump 及 mysql，分別適用於資料備份及維護管理。由於指令是在 local 端執行，所以前提是系統也必須先裝有 MySQL Client 程式，並且 mysqldump 及 mysql 程式路徑必須包含在 PATH 環境變數中，讀者可以先執行 ``mysql --version`` 檢查程式是否存在。

::

    Starting tunnel to mysql-50d38 on port 10000.
    1: none
    2: mysqldump
    3: mysql

在應用程式發佈時，可能遇到啟動失敗的情況，此時就必須藉由記錄檔提供的資訊進行偵錯。Cloud Foundry 將應用程式的記錄檔案放在 ``logs`` 資料夾下，以下的指令可以列出 ``logs`` 包含的檔案清單：

::

    vmc files my-first-blog logs

``logs`` 至少會包含以下的記錄檔：

* stderr.log
* stdout.log

使用檔案完整的路徑，就可以傾印檔案內容： 

::

    vmc files my-first-blog logs/stderr.log

查看記錄檔有更多的指令用法，vmc 提供 ``logs`` 指令，以及用來檢查應用程式當機的 ``crashes`` 及 ``crashlogs`` 指令：

::

    vmc logs my-first-blog
    vmc crashes my-first-blog
    vmc crashlogs my-first-blog

應用程式目前的狀態，可以透過 ``stats`` 指令查詢：

::

    vmc stats my-first-blog

在預設情況下，應用程式只會有一個 Instance。

::

    +----------+-------------+----------------+--------------+-------------+
    | Instance | CPU (Cores) | Memory (limit) | Disk (limit) | Uptime      |
    +----------+-------------+----------------+--------------+-------------+
    | 0        | 0.3% (4)    | 54.9M (256M)   | 50.0M (2G)   | 0d:0h:7m:9s |
    +----------+-------------+----------------+--------------+-------------+

將應用程式發佈到 PaaS，可以得到可延展性（Scalability）的便利，例如當網站流量突然增加，造成應用程式的效能低落，就可以調整 Instance 數量，讓應用程式得到更多的處理器及記憶體、磁碟容量等資源；當應用程式不需要這麼多 Instance 時，也可以隨時降低數量。調整 Instance 數量的指令是：

::

    vmc instances my-first-blog 3

執行上面的指令，Instance 數量就會擴充為 3 個。因為 Cloud Foundry 的免費方案有限制記憶體等容量，所以 Instance 佔用的記憶體總量不能超過限制，否則就會顯示調整失敗的訊息。
    
::

    +----------+-------------+----------------+--------------+--------------+
    | Instance | CPU (Cores) | Memory (limit) | Disk (limit) | Uptime       |
    +----------+-------------+----------------+--------------+--------------+
    | 0        | 0.4% (4)    | 54.9M (256M)   | 50.0M (2G)   | 0d:0h:6m:31s |
    | 1        | 0.5% (4)    | 52.7M (256M)   | 50.0M (2G)   | 0d:0h:4m:24s |
    | 2        | 0.5% (4)    | 52.8M (256M)   | 50.0M (2G)   | 0d:0h:4m:24s |
    +----------+-------------+----------------+--------------+--------------+



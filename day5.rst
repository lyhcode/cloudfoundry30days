************************
Day 5 開發 MVC 應用程式
************************

發佈 Ruby on Rails 應用程式
=========================

Ruby on Rails 是廣受網站開發者喜愛的開發框架，將 Rails 應用程式發佈倒 Cloud Foundry 也相當容易。

使用 RubyGems 安裝 Rails。

::

    gem install rails

檢查版本編號以確認 Rails 安裝成功。

::

    rails --version

建立一個名為 blog 的新專案。

::

    rails new blog
    cd blog

使用 bundle 指令安裝依賴的套件。

::

    bundle package
    bundle install

接下來需要設定 Assets，也就是位於 ``app/assets`` 資料夾下的 CSS、JS 及圖片檔，這些檔案需要預先經過編譯處理，才能順利發佈到 PaaS。

修改 ``config/environment/production.rb`` 設定。

::

    config.serve_static_assets = true
    config.assets.compile = true

修改 ``config/application.rb`` 設定。

::

    config.assets.enabled = true

清除並重新編譯 Assets。

::

    RAILS_ENV=production bundle exec rake assets:clean
    RAILS_ENV=production bundle exec rake assets:precompile

執行 ``rails server`` 指令可以建立本地的 WEBrick 測試伺服器，使用瀏覽器開啟「http://localhost:3000」，如果看到 Rails 預設的畫面，就表示應用程式可以正常執行。測試完畢後，使用 Ctrl+C 停止伺服器。

再來是執行 ``vmc push`` 指令，將 Rails 專案發佈到 Cloud Foundry，假設輸入的應用程式名稱為 ``my-first-blog``\ ，成功佈署到 PaaS 之後，就可以使用「http://my-first-blog.cloudfoundry.com」瀏覽網站。

.. image:: images/rails-screen-1.png
   :width: 80%
   :align: center

資料庫的部份以 MySQL 為例，將 Gemfile 修改如下：

::
    # 註解原設定
    # gem 'sqlite3'

    # 加上以下設定
    group :development do
      gem 'sqlite3'
    end
       
    group :production do
      gem 'mysql2'
    end

這組設定使 Rails 在開發階段使用 sqlite3 資料庫，而發佈到 Cloud Foundry 後則使用 MySQL。

另外針對 Ruby 1.9，同時也需要修改 Gemfile 的 ``jquery-rails`` 設定如下：

::

    # gem 'jquery-rails'
    gem 'cloudfoundry-jquery-rails'

使用 ``bundle`` 重新安裝依賴的套件。

::

    bundle package
    bundle install

接下來使用 Rails 的 Scaffold 功能快速建立應用程式的雛形，在此例中「Post」包含 name、title、content 三項資料欄位。

::

    rails generate scaffold Post name:string title:string content:text
    rake db:migrate

執行 ``rails server`` 啟動測試伺服器，瀏覽「http://localhost:3000/posts」，看到「Listing posts」即可測試列表、新增、修改及移除的基本操作。

設定資料庫的部份，對剛入門 Cloud Foundry 的讀者來說，可能會覺得有些複雜。以 MySQL 來說，通常只需要修改 ``config/database.yml`` ；但是我們在發佈應用程式之前，就先得知 Cloud Foundry 自動產生的資料庫設定，因為在雲端的架構裡，由哪一部機器實際提供資料庫服務，是由 PaaS 平台來決定。一般在 database.yml 常見的 MySQL 設定如下：

::

    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: dbname
      host: localhost
      port: 3306
      username: root
      password: somepwd
      pool: 5
      timeout: 5000
      #socket: /tmp/mysql.sock

在設定資料庫之前，我們需要先建立 Cloud Foundry 的資料庫服務。

::

    vmc create-service

執行這個指令會顯示以下的選單，輸入 5 選擇 MySQL 資料庫。

::

    1: rabbitmq
    2: mongodb
    3: redis
    4: postgresql
    5: mysql
    Which service would you like to provision?: 

新服務建立成功後，系統會回應 OK 的訊息如下。

::

    Creating Service [mysql-50d38]: OK

其中 **mysql-50d38** 就是新服務的名稱，我們還需要將這個服務和應用程式關聯起來。

::

    vmc bind-service mysql-50d38 my-first-blog

如果需要檢視應用程式與服務之間的關聯，可以執行 ``vmc apps`` ，以下是輸出的範例：

::

    +---------------+----+---------+--------------------------------+-------------+
    | Application   | #  | Health  | URLS                           | Services    |
    +---------------+----+---------+--------------------------------+-------------+
    | my-first-blog | 1  | RUNNING | my-first-blog.cloudfoundry.com | mysql-50d38 |
    +---------------+----+---------+--------------------------------+-------------+

那應用程式如何得知資料庫的設定呢？方法是透過 ``ENV['VCAP_SERVICES']`` 這個環境變數，Cloud Foundry 會將服務的設定以此變數傳遞給應用程式。\ ``ENV['VCAP_SERVICES']`` 的內容是 JSON 格式，請參考以下的範例。

::

    {
        "mysql-5.1": [{
            "name": "mysql-50d38",
            "label": "mysql-5.1",
            "plan": "free",
            "tags": ["mysql","mysql-5.1","relational"],
            "credentials": {
                "name":"dfe428022cd5f4f7e901da2a9ff3ef9a7",
                "hostname":"172.30.48.22",
                "host":"172.30.48.22",
                "port":3306,
                "user":"umHe9MCRD6jVV",
                "username":"umHe9MCRD6jVV",
                "password":"pktKbJgobh5Uo"
            }
        }]
    }

因此，在 database.yml 設定中，必須在執行階段從變數中動態獲取設定。

::

    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: <%= JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first['credentials']['name'] rescue 'blog' %>
      host: <%= JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first['credentials']['host'] rescue 'localhost' %>
      port: <%= JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first['credentials']['port'] rescue '3306' %>
      username: <%= JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first['credentials']['username'] rescue 'root' %>
      password: <%= JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first['credentials']['password'] rescue '' %>
      pool: 5
      timeout: 5000

如果想知道 ``ENV['VCAP_SERVICES']`` 變數實際的內容，可以利用 Rails 的 Controller 或 View 將內容印出，例如將以下的 Ruby 程式碼加入 views/layouts/application.html.erb 的 <body>...</body> 區塊內。請注意避免將這些資訊洩漏，以免造成應用程式安全漏洞。

::

    ENV: <%= ENV['VCAP_SERVICES'] %>

資料庫的設定完成後，更新已發佈的應用程式：

::

    vmc update my-first-blog

應用程式更新成功後，即可開啟 http://my-first-blog.cloudfoundry.com/posts ，測試包含資料庫操作的應用程式。



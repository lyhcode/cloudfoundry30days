************************
發佈第一個應用程式
************************

本章示範最簡易的 Hello World 應用程式，如何透過 VMC 工具發佈到 Cloud Foundry；這個範例使用 Ruby 程式語言及 Sinatra 框架開發，由於程式碼相當簡單，即使沒有接觸過 Ruby 的朋友也能輕鬆練習。

發佈 Ruby Sinatra 應用程式
========================

因為安裝 vmc 表示系統已有 Ruby 及 RubyGems，所以使用 Ruby 開發第一個應用程式，將是最容易上手的方式。這裡要介紹給讀者 Sinatra 這個微型開發框架，它是能讓 Ruby 快速建立 Web 應用的領域描述語言（DSL）。

http://www.sinatrarb.com/

首先需要用 RubyGems 安裝 Sinatra：

::

    gem install sinatra

建立一個新資料夾，命名為 ``hello``\ ，將工作路徑切換到這個目錄下：

::

    mkdir hello
    cd hello

使用文字編輯器建立 ``hello.rb`` 程式，儲存在 hello 資料夾，並包含以下程式碼：

.. code-block:: ruby

    require 'sinatra'
    
    get '/hi' do
        "Hello World!"
    end

先在本地端測試程式是否可以執行：

::

    ruby -rubygems hello.rb

若程式執行成功，會顯示 WEBrick 測試伺服器的訊息如下。

::

    [2012-03-16 22:35:54] INFO  WEBrick 1.3.1
    [2012-03-16 22:35:54] INFO  ruby 1.8.7 (2011-12-28) [i686-darwin10]
    == Sinatra/1.3.2 has taken the stage on 4567 for development with backup from WEBrick
    [2012-03-16 22:35:54] INFO  WEBrick::HTTPServer#start: pid=5286 port=4567

從訊息可以看到預設的 Port 為 4567，使用瀏覽器開啟 http://localhost:4567/ ；如果看到「Hello World!」訊息，就表示程式可以正確執行。測試完成後，使用「Ctrl+C」終止程式。

接下來，將應用程式發佈到 Cloud Foundry。執行 vmc 的 push 指令：

::

    vmc push

這個步驟需要輸入一些設定，需要注意應用程式名稱不能和其它開發者的命名重複，因為 CloudFoundry.com 是開放服務，有些名稱可能已經被其它開發者使用；通常應用程式的名稱也會作為子網域名稱，例如「hello-ruby」應用程式的子網域可以設定為「hello-ruby.cloudfoundry.com」：

::

    Would you like to deploy from the current directory? [Yn]: y
    Application Name: 輸入應用程式名稱
    Application Deployed URL [應用程式名稱.cloudfoundry.com]: 
    Detected a Sinatra Application, is this correct? [Yn]: y
    Memory Reservation (64M, 128M, 256M, 512M, 1G, 2G) [128M]: 
    Creating Application: OK
    Would you like to bind any services to '應用程式名稱'? [yN]: 

看到「Starting Application: OK」訊息，就表示應用程式已發佈成功。

::
 
    Uploading Application:
      Checking for available resources: OK
      Packing application: OK
      Uploading (0K): OK   
    Push Status: OK
    Staging Application: OK                                                         
    Starting Application: OK

用瀏覽器打開「應用程式名稱.cloudfoundry.com」，若一切運作順利，將會看到和本地端測試相同的結果。

目前 CloudFoundry.com 並不提供自訂網域名稱的服務，所以上述設定的子網域名稱，就是將開發好的應用程式公諸於世時所使用的網址。換句話說，子網域名稱是先搶先贏，如果已經想到如何將應用程式命名，可以儘快註冊保留。



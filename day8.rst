*******************
Node.js 應用程式開發
*******************


Node.js 介紹
============

Node.js 是近來非常熱門的新興技術，它是一個網站後端開發框架，使用 Google Chrome 的 V8 JavaScript Engine 為基礎，相當輕量化且速度極快。其事件驅動（event-driven）及非阻斷式（non-blocking）I/O的特性，用於建構高擴充性（scalable）網站應用程式，有相當優秀的表現。

由於 Node.js 速度快、系統資源消耗少，一般而言在相同的硬體配置下，使用 Node.js 可以提供更多的負載量；基於 Node.js 帶來的各種益處，它已經是許多 PaaS 平台支援的開發框架，以下是一些比較常見支援 Node.js 的 PaaS，其中包括微軟的 Windows Azure。

* Cloud Foundry（http://docs.cloudfoundry.com/frameworks/nodejs/nodejs.html）
* Heroku（https://devcenter.heroku.com/articles/nodejs）
* Joyent（http://joyent.com/technology/nodejs）
* Nodejitsu（http://nodejitsu.com/）
* Nodester（http://nodester.com/）
* NodeSocket（http://www.nodesocket.com/）
* Windows Azure（http://www.windowsazure.com/en-us/develop/nodejs/）

由於 Node.js 尚處在發展速度飛快的階段，發行版本不斷躍進。目前 Cloud Foundry 支援的三個 Node.js 的主要版本：

* Node.js 0.4.12（node）
* Node.js 0.6.8（node06）
* Node.js 0.8.2（node08）

括號內的代碼是 Cloud Foundry 定義的執行環境（runtime）名稱，在建立新的 Node.js 應用程式時，必須依照版本需求做選擇。

最簡易的 Node.js 範例，是一個連接埠（port）為 8000 的網頁服務。從這個範例可以看到，Node.js 本身並不需要依賴其他網站伺服器（如 Apache、Tomcat 或 Nginx），就可以單獨執行運作。對於設計高效能的網站應用程式，Node.js 帶給開發者不少彈性。

::

    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(8000, '127.0.0.1');
    console.log('Server running at http://127.0.0.1:8000/');

使用 Node.js 開發網站應用程式，通常會搭配其他 Web Application Framework，讓程式撰寫者事半功倍：

* Express（http://expressjs.com/）
* RailwayJS（http://railwayjs.com/）

Cloud Foundry 與 Node.js 的搭配是很不錯的組合，如果再加上 Cloud9 雲端程式編輯器、GitHub 專案托管，甚至可以讓整個網站的開發都在瀏覽器中完成。

* GitHub（http://github.com/）
* Cloud9 IDE（https://c9.io/）

目前 Cloud Foundry 提供的三種主要程式語言：Ruby、Java、Node.js，筆者相當看好 Node.js 的發展。對於記憶體用量斤斤計較的一般 PaaS 收費方案，對於剛開始起步的 Web Application，Node.js 可以說開發快速又省錢，未來要遷移到不同 PaaS 也有非常多選擇。

延伸閱讀

* Node.js 官方網站（http://nodejs.org/）
* Node.js Taiwan 社群（http://nodejs.tw/）
* Node.js 中文電子書（http://book.nodejs.tw/）


建立 Node.js 開發環境
===================

Node.js 支援多種作業系統，Windows 及 Mac OS X 可以直接下載安裝程式。通常開發者還需要 NPM（Node Package Manager）以管理 Node.js 的套件，目前官方發行的新版 Node.js 安裝程式，已經包含 NPM 工具。

* 下載 Node.js（http://nodejs.org/download/）

Ubuntu Linux 的使用者，可以使用 apt-get 安裝：

::

	sudo apt-get install nodejs npm

Mac OS X 除使用官方的 .pkg 安裝外，也可以使用 MacPorts 安裝：

::

    sudo port install nodejs

針對 Mac OS X 及 Linux 的使用者，還可以考慮使用 NVM（Node Version Manager）安裝；NVM 可以同時安裝多個 Node.js 版本，並且可以在不同版本間即時切換。

::

	git clone git://github.com/creationix/nvm.git ~/nvm
	. ~/nvm/nvm.sh

使用 NVM 查詢有哪些可供安裝的 Node.js 版本：

:: 

	nvm list-remote

以安裝目前最新版本 0.9.2 為例，只需要指定其版本編號：

::

	nvm install 0.9.2

顯示本地已安裝的 Node.js 版本，可以使用：

::

	nvm list

也可以即時切換不同版本：

::

	nvm use 0.8.12

為了方便日後使用 NVM，可以在 .bashrc 加入一行設定：

::

	echo '. ~/nvm/nvm.sh' >> ~/.bashrc

安裝完成後檢查 Node.js 及 NPM 是否可執行：

::

	node --version
	npm --version

接下來，建立一個命名為「app.js」的程式檔，內容如下：

::

	var http = require('http');
	http.createServer(function (req, res) {
	  res.writeHead(200, {'Content-Type': 'text/plain'});
	  res.end('Hello World\n');
	}).listen(8000, '127.0.0.1');
	console.log('Server running at http://127.0.0.1:8000/');

執行的方法如下，這個指令會建立一個本地端的網頁伺服器，並且回應「Hello World」文字：

::

	node app.js

如果沒有發生錯誤，使用瀏覽器開啟「http://localhost:8000/」，就可以看到執行結果。


發佈 Node.js 程式
================

建立一個新資料夾（例如 myfirstnode）。

::

	mkdir myfirstnode
	cd myfirstnode

將 Node.js 範例儲存為「app.js」。

::

	var http = require('http');
	http.createServer(function (req, res) {
	  res.writeHead(200, {'Content-Type': 'text/plain'});
	  res.end('Hello World\n');
	}).listen(8000, '127.0.0.1');
	console.log('Server running at http://127.0.0.1:8000/');



使用 VMC 工具的 push 指令，就可以將這個超簡易的 Hello World 程式發佈到 Cloud Foundry。

::

	vmc push

正常情況下，會有以下的畫面訊息。

::

	$ vmc push
	Would you like to deploy from the current directory? [Yn]:
	Application Name: myfirstnode
	Application Deployed URL [myfirstnode.cloudfoundry.com]:
	Detected a Node.js Application, is this correct? [Yn]:
	Memory Reservation (64M, 128M, 256M, 512M, 1G) [64M]:
	Creating Application: OK
	Would you like to bind any services to 'myfirstnode'? [yN]:
	Uploading Application:
	  Checking for available resources: OK
	  Packing application: OK
	  Uploading (0K): OK
	Push Status: OK
	Staging Application: OK
	Starting Application: OK

Application Name 需要為應用程式定義一個專屬的名稱，如果命名與其他人的名稱重複，發佈應用程式就會失敗。這個範例使用最少的記憶體配置（64MB），VMC 會自動偵測出程式使用 Node.js 開發；這個範例不需要用到資料庫服務，所以在選擇不要與任何服務連結（bind）。

＊您需要將 myfirstnode 名稱更換為其他設定，因為本文的範例在測試時已經先註冊這個名稱了。

使用瀏覽器開啟網址「http://myfirstnode.cloudfoundry.com/」，就可以看到發佈至 Cloud Foundry 的程式已經正常運作。

使用 VMC 的 logs 指令，可以看到程式輸出到 console 的訊息被記錄：

::

	vmc logs myfirstnode

使用 VMC 的 stats 指令，查詢應用程式執行狀態：

::

	vmc stats myfirstnode

狀態查詢結果的範例如下，可以看到應用程式佔用的記憶體、磁碟容量及處理器，以及啟動經過的時間。

::

	+----------+-------------+----------------+--------------+---------------+
	| Instance | CPU (Cores) | Memory (limit) | Disk (limit) | Uptime        |
	+----------+-------------+----------------+--------------+---------------+
	| 0        | 0.0% (4)    | 14.4M (64M)    | 256.0K (2G)  | 0d:0h:39m:48s |
	+----------+-------------+----------------+--------------+---------------+

曾經用過其他 PaaS 的 Node.js 開發者，對這個範例也許會發現一個疑問；一般發佈 Node.js 程式到 PaaS，可能需要以下的設定，透過環境變數取得連接埠（port）參數，才可以順利在雲端環境執行（例如 Windows Azure）。

::

	.listen(process.env.port);

早期 Cloud Foundry 執行 Node.js 程式，也同樣需要加上參數，而且必須使用 Cloud Foundry 指定的參數名稱。

::

	.listen(process.env.VCAP_APP_PORT);

但目前新的 Cloud Foundry 已經支援 Auto-Reconfiguration，也就是即使我們在程式碼指定 1337 或 8000 之類的連接埠號碼，發佈到 Cloud Foundry 執行時，會由 PaaS 自動調整為合適的設定。關於 Auto-Reconfiguration 機制可以參考以下連結。

* Cloud Foundry Now Supports Auto-Reconfiguration for Node.js Applications（http://goo.gl/fUkEf）


使用 Express 框架開發
===================

這一節講解 Node.js 最知名的 Express 開發框架，它簡化建立一個網站應用程式所需的工作，提供樣板引擎（例如 EJS、Jade 等），以及 Cookie/Session 等網站常用的基礎設施。

先用 VMC 的 delete 指令刪除前面建立的應用程式，在本節建立的程式將重複使用同一個命名。

::

	vmc delete myfirstnode

將「app.js」檔案移除，但是保留「myfirstnode」資料夾，接下來繼續在「myfirstnode」這個資料夾下操作。

在使用 Express 前，需要先以 NPM 安裝 Express 相關套件，並且加上「-g」參數，讓 Express 提供的 command-line 工具放在系統共用的位置、並可以直接執行。（sudo 是 Linux 及 Mac OS X 下取得管理者權限的指令，Windows 開發者不需要加上 sudo。）

::

	sudo npm -g install express

測試一下「express」指令是否可以執行，我們使用版本查詢參數。

::

	express --version

在「myfirstnode」資料夾下，開始建立一個全新的 Express 專案。

::

	express .

＊如果不在一個空白資料夾（例如我們使用的 myfirstnode）下操作，則可以指定新專案使用的資料夾名稱，例如：「express myproject」。

執行成功，Express 會列出過程建立的檔案：

::

   create : .
   create : ./package.json
   create : ./app.js
   create : ./public
   create : ./public/images
   create : ./public/stylesheets
   create : ./public/stylesheets/style.css
   create : ./routes
   create : ./routes/index.js
   create : ./routes/user.js
   create : ./views
   create : ./views/layout.jade
   create : ./views/index.jade
   create : ./public/javascripts

   install dependencies:
     $ cd . && npm install

   run the app:
     $ node app

從以上 Express 的提示中，可以知道接下來的步驟。首先是再一次使用 NPM 工具，將專案依賴的套件自動安裝。（請注意不需要加上 sudo！）

::

	npm install

接下來要啟動應用程式，則以 node 執行 Express 新建的 app.js 程式主檔。

::

	node app

執行成功會看到以下訊息，此時可以用瀏覽器打開預設的網址「http://localhost:3000/」。

::

	Express server listening on port 3000

使用「Ctrl + C」終止程式。

再次使用「vmc push」將程式發佈到 Cloud Foundry，步驟與上一節的範例相同。

假設發佈的應用程式命名為「myfirstnode」，發佈成功後，就可以開啟「http://myfirstnode.cloudfoundry.com/」測試結果。

設定 package.json
=================

利用 Express 產生的新專案，包含一個名為 package.json 的設定檔。Node.js 相關的工具會讀取這個設定檔；例如 NPM 套件管理工具，會依照 dependencies 的設定內容，自動下載安裝需要的套件（範例中的套件為 express 及 jade）。

::

	{
	  "name": "application-name",
	  "version": "0.0.1",
	  "private": true,
	  "scripts": {
	    "start": "node app"
	  },
	  "dependencies": {
	    "express": "3.0.0rc5",
	    "jade": "*"
	  }
	}

* Packages/1.0 - CommonJS Spec Wiki（http://wiki.commonjs.org/wiki/Packages/1.0）
* Specifics of npm's package.json handling（https://npmjs.org/doc/json.html）

因此，專案建立 package.json 設定後，就不需要將 node_modules 資料夾（由 NPM 產生）放到版本控制系統。因為其他開發者只要取得 package.json，再執行一次 npm install 指令，就會重新將相關套件安裝好。

以 GIT 版本控制工具來說，通常會在 .gitignore 檔案中加入一行（node_modules），表示日後將新檔案加到版本控制時，會自動忽略這個資料夾。

但如果你嘗試將 node_modules 刪除後，再把應用程式發佈到 Cloud Foundry，將會發生應用程式無法啟動的錯誤。使用 VMC 的 update 指令，將已經發佈過的應用程式更新。

::
	rm -rf node_modules
	vmc update myfirstnode

Cloud Foundry 提供一份關於 Node.js NPM 的說明，可以得知使用上有所限制。

* Cloud Foundry Supports Node.js Modules with NPM（http://blog.cloudfoundry.com/2012/05/24/cloud-foundry-supports-node-js-modules-with-npm/）

其中重點是需要用 npm shrinkwrap 將套件相依的版本鎖住（lock down），使用 shrinkwrap 前需要先用 NPM 把相關套件都裝起來。

::

	npm install
	npm shrinkwrap

執行後會產生 npm-shrinkwrap.json 這個檔案，接下來就可以重新發佈程式（先將 Cloud Foundry 上的應用程式刪除）。

::

	vmc delete myfirstnode
	rm -rf node_modules
	vmc push myfirstnode --runtime=node06

這次就可以發佈成功了，仔細觀察 VMC 的訊息，可以看到上傳的檔案體積差異，包含 node_modules 檔案的容量，一個新建的 Express 專案，大約會有 20K，如果把 node_modules 去除，就大概只需要 3K。

::

  Uploading (3K): OK

透過組態檔管理套件版本是一個好的做法，即使用 Java 或 PHP 等其他語言工具，也可以找到類似工具，讓專案只管理自己開發、真正重要的部份。


Node.js helper for CloudFoundry
================================

前面的章節曾經提過應用程式取得各項服務參數（如資料庫連線帳號密碼等），需要使用 Cloud Foundry 透過環境變數傳遞的參數值，其資料為 JSON 格式。

為了方便參數的存取，可以使用「cloudfoundry」這個同名的 Node.js Module，它是一個 helper 的設計，也就是用來幫助開發者簡化程式的撰寫。安裝只要使用 NPM 即可：

::

    npm install cloudfoundry

在 Node.js 程式碼的開頭，需要加上 require 語法。

::

	var cloudfoundry = require('cloudfoundry');

如此就能輕鬆存取相關設定，例如：

::

	//判斷程式是否在 Cloud Foundry 上執行（如果想讓開發和佈署不同階段分別執行不同程式）
	cloudfoundry.cloud

	//程式使用的 host（網址）
	cloudfoundry.host

	//程式使用的連接埠
	cloudfoundry.port


其他相關語法還有：

::

	cloudfoundry.app
	cloudfoundry.services

如果你想存取服務（資料庫）的參數，使用的範例如下：

::

	cloudfoundry.mongodb['service-name'].credentials.hostname
	cloudfoundry.mongodb['service-name'].credentials.port
	cloudfoundry.mongodb['service-name'].credentials.db
	cloudfoundry.mongodb['service-name'].credentials.username
	cloudfoundry.mongodb['service-name'].credentials.password

例如我們可以撰寫這個簡單的 Node.js 程式，查詢程式在 Cloud Foundry 執行使用的 IP 位址。

::

	var cloudfoundry = require('cloudfoundry');

	var http = require('http');
	http.createServer(function (req, res) {
	  res.writeHead(200, {'Content-Type': 'text/plain'});
	  res.end(cloudfoundry.host);
	}).listen(8000, '127.0.0.1');


Cloud9 IDE 雲端整合開發環境
=========================

Node.js 這種輕量的開發框架，可以為雲端應用程式開發帶來什麼令人興奮的事呢？相信大家都可以想到各種應用方式，目前已經有名為 Cloud9 IDE 的雲端整合開發環境，支援 Node.js 應用程式的開發，並且可以輕鬆整合 Cloud Foundry 及 Heroku 等 PaaS 的佈署。

Cloud9 本身也是使用 Node.js 開發，它運用不少 Node.js 帶來的好處，讓程式編輯器在瀏覽器中執行，也可以有很棒的使用者體驗。使用現代瀏覽器如 Google Chrome、Firefox 就可以輕鬆使用 Cloud9 IDE。

* Cloud9 IDE（https://c9.io/）

Cloud9 對開源專案的開發者相當友善，它不僅支援 GitHub Repository 的整合，對於 Open Source 的專案也是免費提供服務。

想像一下整個開發流程都在雲端進行：

* 使用 Google Docs 整理專案資料
* 使用 Google+ Hangout 視訊會議
* 使用 GitHub 管理專案源碼及 Issues/Bugs
* 使用 Cloud Foundry 發佈應用程式
* 使用 Cloud9 IDE 撰寫程式碼及測試

也就是說，開發者只需要一台筆電加上行動網路，就可以在雲端打造整個應用程式。或許，你還可以用 Raspberry Pi 打造超迷你、可以放進口袋的電腦，只要用它執行 Arch Linux 或 Android 系統，就可以打開瀏覽器開始進行一天的開發工作。

* Raspberry Pi http://www.raspberrypi.org/

也許未來很多事情還只能想像，但使用 Cloud9 可能會讓你覺得更多可能性都開始成真。

你可以不必申請新帳號，使用 GitHub 的帳號就可以直接登入 Cloud9 IDE。在個人的 Dashboard 新增一個 Project（Create New Workspace），按下 Start Editing 就可以開始寫程式。

Cloud9 提供幾個很酷的功能，你一定要試試：

* Console 輸入如 ls, npm 等指令，直接在遠端執行（https://docs.c9.io/console.html）
* Terminal 讓你直接在瀏覽器打開終端機畫面，直接在遠端的 Unix 機器下指令（https://docs.c9.io/terminal.html）

目前 Cloud9 的功能以火箭般的速度快速發展，例如你可以直接在 Console 中輸入「express .」，遠端就會幫你建立一個 Express 新專案，然後執行 npm install，同樣在遠端就能完成模組安裝。整個過程都在瀏覽器中發生，你的電腦不需要安裝 Node.js 就可以開發。

在 Cloud9 的 Deployment 選單中，讀者可以看到「Heroku」、「Windows Azure」等選項，可是說好的 Cloud Foundry 在哪裡呢？目前在 Cloud9 發佈 Cloud Foundry 還沒辦法利用 UI 介面操作，而是要先打開一個 Terminal，先手動

::

	cd ~
	wget https://github.com/cloudfoundry/vmc/zipball/master
	mv master cloudfoundry
	unzip cloudfoundry
	cd cloudfoundry-vmc-nnnn
	bundle

上面的作法是 Cloud9 官方文件建議的方式，但筆者發現其實只要用 RubyGems 安裝 VMC 即可：

::

	gem install vmc

然後記得先切換 Target 和進行 Login。

::

	vmc target api.cloudfoundry.com
	vmc login

沒錯！就是這麼簡單，接下來就可以在 Cloud9 IDE 使用本系列文章教學的方法，將建立的 Node.js 應用程式發佈到 Cloud Foundry。


使用 MongoDB 資料庫服務
=====================

回到之前建立的 Express 專案，我們開始實作一個存取 MongoDB 資料庫的範例程式。

在 package.json 加入「mongoose」及「cloudfoundry」的 dependencies 設定：

::

  "dependencies": {
    "express": "3.0.0rc5",
    "jade": "*",
    "mongoose": "*",
    "cloudfoundry": "*"
  }


然後使用 NPM 安裝套件。

::

	npm install

這個新安裝的套件「mongoose」是 Node.js 的 MongoDB 函式庫，直接使用 Node.js 的 MongoDB Driver 相當麻煩，一個簡單的查詢就需要多層的 JavaScript closure；搭配 mongoose 不僅簡化查詢所需的語法，也提供類似 ORM（物件關聯映射）設計。

我們延續之前使用的應用程式命名「myfirstnode」，並建立一個新的服務：

::

	vmc create-service mongodb

如果建立成功，VMC 會有以下訊息：

::

	Creating Service [mongodb-9bd2c]: OK

由以上訊息可知新服務名稱是「mongodb-9bd2c」，我們還需要將服務和應用程式綁定（bind），才能開始在應用程式中存取服務。

::

	vmc bind-service mongodb-9bd2c myfirstnode

以下的範例程式加在 var app = express(); 前面，使用 MongoDB 記錄應用程式啟動次數。

::

	var mongoose = require('mongoose');
	var cloudfoundry = require('cloudfoundry');

	var credentials = JSON.parse(process.env.VCAP_SERVICES)['mongodb-2.0'][0]['credentials'];
	var db = mongoose.createConnection("mongo://"
	     + credentials["username"]
	     + ":" + credentials["password"]
	     + "@" + credentials["hostname"]
	     + ":" + credentials["port"]
	     + "/" + credentials["db"]);

	var Counter = new mongoose.Schema ({name: String, num: Number});

	mongoose.model('Counter', Counter);
	var Counter = db.model('Counter');

	Counter.findOne({name: 'startup'}, function(err, counter) {
	  if(!err) {
	    if (!counter) {
	      counter = new Counter();
	      counter.num = 0;
	    }
	    counter.num++;
	    counter.save(function(err) {
	      if(!err) {
	        console.log('could not save counter');
	      }
	    });
	  }
	});

重新發佈應用程式：

::

	vmc update myfirstnode

接下來建立通道（tunnel），以方便使用 MongoDB Client 手動查詢資料庫內容：

::

	vmc tunnel mongodb-9bd2c

執行以上的指令，會詢問 Cloud Foundry 的密碼，輸入後會上傳「caldecott」這個程式。

看到以下的詢問，輸入 2 選擇「mongo」指令（MongoDB 內建的 Client 程式）。

::

	Starting tunnel to mongodb-9bd2c on port 10000.
	1: none
	2: mongo
	Which client would you like to start?: 

你會看到類似以下的訊息，代表 VMC 已經幫你建立一個 MongoDB Client 到 PaaS MongoDB 資料庫的特殊連線：

::

	Launching 'mongo --host localhost --port 10000 -u 6f3aab6a-574e-4901-a0c5-6a42a2a78d49 -p 56201b90-74e1-4898-8779-943a184277fa db'

在 MongoDB Client 直接輸入 MongoDB 查詢語法（JavaScript）：

::

	db.Counter.find();

就可以看到在 Node.js 程式中寫入 MongoDB 的資料。
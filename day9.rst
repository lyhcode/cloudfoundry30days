*******************
Grails 應用程式開發
*******************


Grails 介紹
============

前面的章節已經介紹過 Sinatra 、 Ruby on Rails 及 Node.js 等開發框架，接下來要介紹的是屬於 Java 世界的 Grails，這個開發框架由同屬 VMWare 公司的 SpringSource 發展，在 Cloud Foundry 平台當然也受到良好的支援及整合。

Cloud Foundry 建議的開發工具之一：STS（Spring Tool Suite），提供 Grails 的整合開發環境；另外還有 NetBeans 及 IntelliJ IDEA 等開發工具，也都支援 Grails 專案的開發。

但是對於經常使用整合開發環境的 Java 開發者來說，剛開始使用 Grails 反而會有些不習慣，因為實際上 Grails 並不需要特別的開發工具，只要使用 command-line 搭配一般程式碼編輯器就能輕鬆開發。你可以將 Grails 當做是 Java 版的 Rails，我也喜歡將它稱為「Groovy on Grails」。

為什麼是 Groovy 而非 Java 呢？

因為 Grails 捨棄繁瑣難寫又依賴開發工具的 Java 程式語言，改用另一個在 Java VM 上執行的新語言：Groovy，這個簡化 Java 又加上許多增強語法的新語言，擁有 Scripting Language 的開發簡便優勢，因此讓 Grails 在開發整個專案時，都可以像 Ruby on Rails 或 PHP 那樣，只要撰寫容易修改及測試 Script 程式碼即可。

舉例來說，定義一個 Model（Domain Class） 很簡單，只要使用 Groovy 撰寫 POJO（Pure Object Java Object）風格的類別。

::

	class User {
		String name
		String password
	}

撰寫 Controller 也相當容易：

::

	class UserController {
		def show(Long id) {
			[user: User.get(id)]
		}
	}

至於 View 則充分利用 JSP + JSTL 但是更加簡單：

::

	<h1>${user.name}</h1>
	<p>Password: ${user.password}</p>

Grails 也提供 Scaffolding 並支援 Unit/Integration Test 等現代開發框架應具備的功能，同樣可以利用既有的 Java 套件（例如 JasperReport）；但比起傳統複雜的 Java EE 開發框架，開發更加簡單快速。

延伸閱讀

* Spring Framework（http://www.springsource.org/spring-framework）
* Grails（http://grails.org/）
* Groovy（http://groovy.codehaus.org/）
* NetBeans and Grails（http://netbeans.org/kb/docs/web/grails-quickstart.html）
* STS and Grails（http://www.grails.org/STS+Integration）
* IntelliJ IDEA and Grails（http://www.jetbrains.com/idea/features/groovy_grails.html）


Grails 開發環境建置
=================

因為 Grails 是 Java-based 的開發框架，需要先準備 Java SDK 開發環境。從 Oracle 的 Java SE Downloads 網站選擇合適的版本（Windows or Linux、32bit or 64bit）。

* Java SE Downloads（http://www.oracle.com/technetwork/java/javase/downloads/index.html）

如果使用 Ubuntu Linux 12.10，現在只需要一道指令就可以完成 Java SDK 安裝。

::

	sudo apt-get update && sudo apt-get install default-jdk

Grails 只要下載最新的 Binary Zip 版本，解壓縮候設定 PATH 及 GRAILS_HOME 等環境變數。

* Grails Downloads（http://grails.org/Download）

在 Mac OS X 安裝 Grails，使用 MacPorts 是最簡單的方式：

::

	sudo port install grails

當然 Ubuntu Linux 同樣有簡單的快速安裝方法：

::

	sudo add-apt-repository ppa:groovy-dev/grails
	sudo apt-get update
	sudo apt-get install grails-ppa

檢查安裝好的 Grails 版本：

::

	grails -version

查詢 Grails 提供的操作指令：

::

	grails help

剛開始新建一個專案的方法，是使用「create-app」指令：

::

	grails create-app myfirstgrails

接著切換到專案路徑下，並開始啟動測試伺服器：

::

	cd myfirstgrails
	grails run-app

測試伺服器啟動成功後，使用瀏覽器開啟「http://localhost:8080/」即可測試。

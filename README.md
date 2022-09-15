# 小狼毫注音（洋蔥 mix-in 只保留注音與英文版本）

## 內容說明：

- 由於日文、韓文、俄文、希臘文使用率太低，因此移除相關字典，減少連打誤判率。

## 誰適合：

- :pushpin:		工作上常用到晶晶體，用中文與english夾雜，連shift都會懶得切換的人
- :pushpin:		想打出注音文ㄏㄏ

## 使用方法：

- 安裝小狼毫輸入法本體
- 將Github內容覆蓋至以下路徑（Linux、Mac並無測試）
- 原作者有四種設定檔，這部份只異動第四個設定檔案（bo_mixin4.schema.yaml），其餘設定檔移除。

```
%APPDATA%\Rime  ( Windows 小狼毫 )
```

- 注音文呼叫方式，連續按出兩個符號 '; 就可以打注音文ㄌ
- [ ] 看後續有沒有機會改成直接呼叫注音文ㄏㄏ



## 自行添加回日文與韓文說明：

- 若需要自行添加或減少語言，需要異動以下設定檔
- 建議從作者載點下載原檔案進行修改，由於此份已經變成只保留注音跟英文的形狀，已經移除不少區塊了。

| 物件 | 敘述 |
| --- | --- |
| bo_mixin4.schema.yaml | 設定檔案 |
| bo_mixin.extended.dict.yaml | 擴充字典檔設定 |


## 示範，自行添加回日文，移除韓文與其他語言：

- bo_mixin.extended.dict.yaml
- 將以下jp片語字典檔加回即可，並註解掉kr相關字眼。

```yaml
import_tables:
  - terra_pinyin_onion
  - terra_pinyin_onion_add
  - bo_mixin_jp
  # - bo_mixin_kr  #《韓文洋蔥形碼》  #此項打開時，bo_mixin_kr_hnc 請關閉。
  # - bo_mixin_kr_hnc  #《韓文HNC羅馬字》  #此項打開時，bo_mixin_kr 請關閉。
  - bo_mixin_la
  # - bo_mixin_en  #《英文26字母和符號》  #此項打開時，bo_mixin_la 和 phrases.la_py_w 請關閉。
  - phrases.cht_en_w
  - phrases.chtp
  # - phrases.cht  #《未標注拼音之中文詞庫》  #不建議打開。
  # - phrases.jp_hk_more  #《日語大詞庫》  #欲更精準 mapping，可打開並關閉小詞庫 phrases.jp_hk。
  - phrases.jp_hk
  - phrases.jp_hkkreduce
  # - phrases.kr_more  #《韓語大詞庫》  #欲更精準 mapping，可打開並關閉小詞庫 phrases.kr。
  # - hrases.kr
  - phrases.en_o_w
  - phrases.la_py_w
  - phrases.en_l_w
  - phrases.en_u_w
  - phrases.la_eu_w
```


- bo_mixin4.schema.yaml
- 異動掉greek（希臘文）與cyrillic（俄文），並確認jpnin1（日文）沒有被註解掉

```yaml
import_tables:
  dependencies:
    - symbols_bpmf
    - cangjie5
    # - easy_en_b
    - easy_en_super
    - fullshape
    # - greek
    # - cyrillic
    - allbpm
    - jpnin1
```

- 異動掉gr2（希臘文）與cyr2（俄文），並確認japan（日文）沒有被註解掉

```yaml
segmentors:
    - ascii_segmentor
    - matcher
    - abc_segmentor
    - affix_segmentor@emoji_series
    - affix_segmentor@easy_en
    - affix_segmentor@easy_en_script
    - affix_segmentor@japan
    # - affix_segmentor@cyr2
    # - affix_segmentor@gr2
    - affix_segmentor@fs2
    - affix_segmentor@all_bpm
    - affix_segmentor@reverse2_lookup
    - punct_segmentor
    - fallback_segmentor
  translators:
    - punct_translator
    - table_translator@bo_mixin_phrase
    - table_translator@emoji_series
    - table_translator@easy_en
    - script_translator@easy_en_script
    - script_translator@japan
    # - script_translator@cyr2
    # - script_translator@gr2
    - script_translator@fs2
    - script_translator@all_bpm
    - script_translator@reverse2_lookup
    - lua_translator@t2_translator
    - lua_translator@email_url_translator
    - lua_translator@instruction_grave_bpmf
    - script_translator
```

- 移除掉speller區塊中的韓文拼寫，譬如移除以下項目
- 以下只擷取部分，需自行檢查並移除。

```ymal
##### 韓文HNC轉寫開始 #####
    - derive/^(!)l/$1r/
    - derive/^(![^!]+)l/$1r/
    - derive/^(!)x/$1ng/
    - derive/^(![^!]+)x/$1ng/
    - derive/^(![^!]*)i/$1y/
    - derive/^(![^!]*)y([aueo])/$1i$2/
    - derive/^(!)p/$1f/
    - derive/^(![^!]+)p$/$1f/
### 韓語 ###
### 韓語 ###
### 韓語字母或單母音轉寫 ###
```

- 移除以下區塊，該區塊影響的是快捷建的呼叫功能。
```
########################### 西里爾字母 ###################################
############################# 希臘字母 #################################

```

- 移除資料夾多餘檔案，可移除kr、cyrillic、cyr、gr、greek相關字眼檔案。 
- 再把資料夾內容mixin注音_同顯1修改檔(Win)直接丟進去即可；差別只有顯示方式不同，可見[原作者的文章](https://deltazone.pixnet.net/blog/post/347368709)中的同顯說明段落
- 重新部署
- 若無反應，可先將資料夾build移除，並將小狼毫輸入法退出，重新執行。 



## 以下保留原作者其他方案說明：

  > 202203 韓文改成 HNC 羅馬字輸入方式。

- [電腦 RIME 輸入法『注音（洋蔥 純注音 版）』](https://deltazone.pixnet.net/blog/post/264319309)

- [電腦 RIME 輸入法『注音（洋蔥 plus 版）』](https://deltazone.pixnet.net/blog/post/343650692)

- [電腦 RIME 輸入法『注音（洋蔥 mix‧in 版）』](https://deltazone.pixnet.net/blog/post/347368709)

- [電腦 RIME 輸入法『注音（洋蔥 雙拼 版）』](https://deltazone.pixnet.net/blog/post/359775341)

- [電腦 RIME 輸入法〖 地球拼音（洋蔥 mix‧in 版）〗](https://deltazone.pixnet.net/blog/post/353697089)

- [電腦 RIME 設定檔〖 行列 30（洋蔥版）〗](https://deltazone.pixnet.net/blog/post/361766142)

## Demo：

- 注音（洋蔥 mix-in 版）
  
  > 集大成，多國語言和注音混打輸入 😃！
  
  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/demo_bpmf_mixin.gif)
  
- 注音（洋蔥 plus 版）

  > 功能多，除外語還有一堆功能和細節增加，輸入手感和純注音版一樣，即使沒用外語，也推薦使用！
  
  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/demo_bpmf_plus.gif)
  
- 注音（洋蔥 純注音 版）
  
  > 精簡功能，給新手或測試使用
  
  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/demo_bpmf_pure.gif)
 
## Keys：
 
- 注音（洋蔥 雙拼 版）鍵位
  > 無加 custom 可簡拼，有 custom 為一般雙拼每字須鍵兩碼（聲調可省略）

  #### <img src="https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/allfiles/%E9%9B%99%E6%8B%BC%E6%B3%A8%E9%9F%B3%E9%8D%B5%E4%BD%8D%E8%AA%AA%E6%98%8E%E5%9C%96%E7%A4%BA/%E6%B3%A8%E9%9F%B3%E6%B4%8B%E8%94%A5%E9%9B%99%E6%8B%BC%E8%AA%AA%E6%98%8E.png" width = "595" alt="image" align=left />

  <br><br><br><br><br><br><br><br><br><br>

- 注音（洋蔥 plus 版）鍵位

  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/bpmf_plus_keyboard.png)

- 注音（洋蔥 mixin 版）鍵位

  > 四個衍伸方案：「1」標準版、「2」只有後綴易懂、「3」語言分野最明減少撞碼、「4」集中下排手順最好

  > 本人多使用「4」，因較喜歡鍵盤下排之手順，也推薦「3」

  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/bpmf_mixin_1_keyboard.png)
  
  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/bpmf_mixin_2_keyboard.png)
  
  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/bpmf_mixin_3_keyboard.png)
  
  #### ![image](https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/bpmf_mixin_4_keyboard.png)
  
- 注音洋蔥版選字鍵位

  #### <img src="https://raw.githubusercontent.com/oniondelta/Onion_Rime_Files/master/img/bpmf_select_keys_keyboard.png" width = "595" alt="image" align=left />

<br><br><br><br><br><br><br><br><br>

## 贊助 Donate：

  > 從第一個方案上傳已持續更新五年以上！方案從頭到尾大改、新創、新增非常多功能！且做了許多圖文說明！花了族繁不及備載的心力！

  > 懇請贊助 (Donate) 支持，讓 Rime 洋蔥的一系列方案更新更有動力！

- [按此以〈綠界〉贊助 Donate：](https://p.ecpay.com.tw/D555162)

  #### [![donate1](https://payment.ecpay.com.tw/Upload/QRCode/202010/QRCode_170c287e-2db8-4b50-b87f-8d36500a3958.png)](https://p.ecpay.com.tw/D555162)

- [按此以〈歐付寶〉贊助 Donate：](https://qr.opay.tw/q1ql7)

  #### [![donate2](https://payment.opay.tw/Upload/Broadcaster/2294343/QRcode/QRCode_7AC0FA1CAD39F0B66CFD5513A2173D1A.png)](https://qr.opay.tw/q1ql7)

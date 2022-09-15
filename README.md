# 小狼毫注音（洋蔥 mix-in 只保留注音與英文版本）

## 內容說明：

- 由於日文、韓文、俄文、希臘文使用率太低，因此移除相關字典，減少連打誤判率。

## 使用方法：

- 安裝小狼毫輸入法本體
- 將Github內容覆蓋至以下路徑（Linux、Mac並無測試）

```
%APPDATA%\Rime  ( Windows 小狼毫 )

```

## 自行添加回日文與韓文說明：

- 若需要自行添加或減少語言，需要異動以下設定檔
```
bo_mixin4.schema.yaml
bo_mixin.extended.dict.yaml
```

## 示範，自行添加回日文，移除韓文與其他語言：

- bo_mixin.extended.dict.yaml
- 將以下jp片語字典檔加回即可，並註解掉kr相關字眼。

```
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

```
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



## 以下為原作者其他方案說明：

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

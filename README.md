# AutoEvaluator

自動解壓，置換main file，使用給定makefile編譯後執行並輸出的自動化解決方案  

可以簡化程式課作業批改流程 (如果作業的形式能以更換main file去call特定function來檢驗正確性的話)   

# Requirement

1. 需要處理的程式壓縮檔 (目前只支援rar, zip, 7z)
2. 對應的makefile
3. 對應的測試用main file

# Usage

1. 將bash腳本抓下來，在其目錄中新增放置壓縮檔的資料夾  
(資料夾名稱對應bash腳本變數 $CodeFolder)

2. 設定對應的解壓縮目標   
(路徑對應bash腳本變數 $DecompressedFolder)  

3. 設定對應的makefile, mainfile名稱，檔案和bash script放在同一目錄下   
(對應bash腳本變數MakefileName, MainfileName)  

4. 設定各小題的資料夾名稱，這些資料夾應該包含需批改的專案，makefile會被放進這些目錄

5. bash AutoEvaluator.sh

6. 如果出現 $'\r': command not found 之類的錯誤訊息，請先安裝dos2unix把檔案格式轉成unix

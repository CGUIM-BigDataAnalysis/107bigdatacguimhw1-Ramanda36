library(jsonlite)
library(dplyr)
library(readr)
# 比較103年度和106年度大學畢業者的薪資資料，請問106年度薪資較103年度薪資高的職業有哪些? 
#   請按照提高比例由大到小排序(3分)，呈現前十名的資料(2分)，並用文字說明結果(10分)
# 。此外，提高超過5%的的職業有哪些(5分)? 主要的職業種別是哪些種類呢(5分)? 共25分，程式碼排版清晰易懂分數5分。
# 提示作法:
# Join 103和106年度表格，變成新表格。若因資料型態不同，無法join，修改資料型態又有錯誤訊息時，
# 可嘗試先將資料讀入，再把表格內的—符號取代為空字串，最後用程式碼轉換資料型態。
# 若無法取代-符號，可能是你打的-符號與資料內的—符號不同（如-與—的差別），
# 請將表格內的—複製到r 取代的程式碼內（gsub）即可成功取代。
# 計算106年度大學畢業薪資 / 103年度大學畢業薪資，並用此值在新表格中新增一個欄位
# 排序
# 篩選兩年度薪資比例 >1.05的欄位
# 字串處理，取出大職業別中"-" 前面的字串，並分析出現次數

X103category <- read_csv("C:/Users/raman/Downloads/A17000000J-020066-Qod/103category.csv")
X104category <- read_csv("C:/Users/raman/Downloads/A17000000J-020066-Qod/104category.csv")
X105category <- read_csv("C:/Users/raman/Downloads/A17000000J-020066-Qod/105category.csv")
X106category <- read_csv("C:/Users/raman/Downloads/A17000000J-020066-Qod/106category.csv")
salary103<-select(X103category,年度,大職業別,'大學-薪資')
salary106<-select(X106category,年度,大職業別,'大學-薪資')

allsalary<-inner_join(salary103,salary106,by="大職業別")
allsalary$`大學-薪資.x`<-gsub("—",NA,allsalary$`大學-薪資.x`)
allsalary$`大學-薪資.y`<-gsub("—",NA,allsalary$`大學-薪資.y`)
allsalary$`大學-薪資.x`<-as.numeric(allsalary$`大學-薪資.x`)
allsalary$`大學-薪資.y`<-as.numeric(allsalary$`大學-薪資.y`)
# 比較103年度和106年度大學畢業者的薪資資料，請問106年度薪資較103年度薪資高的職業有哪些? 

higher<-filter(allsalary,`大學-薪資.y`>allsalary$`大學-薪資.x`)
knitr::kable(higher)

# 請按照提高比例由大到小排序(3分)
allsalary<-mutate(allsalary,increaserate=(`大學-薪資.y`/`大學-薪資.x`))%>%arrange(desc(increaserate))
#呈現前十名的資料(2分)，並用文字說明結果(10分)
allsalary10<-head(allsalary,10)
knitr::kable(allsalary10)
#分析結果顯示薪水提高比例最高的職業是"其他服務業-技術員及助理專業人員"增加率為1.131278；
# 第10名提高率則降到1.089846。在這三年內前十名的提高比例位在1.09~1.13之間，其中有6比資料都是和服務業相關。
#在103年時大學薪資10筆資料中只有"不動產業-專業人員"的薪資高於三萬，而在106年增加到有5項職業高於三萬。

#提高超過5%的的職業有哪些(5分)
knitr::kable(over1.05<-filter(allsalary,increaserate>1.05))


#主要的職業種別是哪些種類呢(5分)
category<-strsplit(over1.05$大職業別,"-")[[1]][1]
for (i in 2:length( over1.05$大職業別)){
  category<-c(category,strsplit(over1.05$大職業別,"-")[[i]][1])
}
knitr::kable(Mainoccupation<-(table(category))%>%data.frame()%>%arrange(desc(Freq)))

# 男女同工不同酬一直是性別平等中很重要的問題，請分析103到106年度的大學畢業薪資資料，
# 請問哪些行業男生薪資比女生薪資多?依照差異大小由大到小排序(3分)，呈現前十名的資料(2分)。
# 又，請問那些行業女生薪資比男生薪資多? 依據差異大小由大到小排序(3分)，呈現前十名的資料(2分)。
#並用文字說明結果(10分)，共20分，程式碼排版清晰易懂分數5分。
# 提示作法:
# 將103到106年度大學畢業男女薪資比例由小到大排序
# 將103到106年度大學畢業男女薪資比例由大到小排序

#103
salaryrate103<-select(X103category,年度,大職業別,`大學-女/男`)
salaryrate103$`大學-女/男`<-gsub("—|…",NA,salaryrate103$`大學-女/男`)
salaryrate103$`大學-女/男`<-as.numeric(salaryrate103$`大學-女/男`)

#請問哪些行業男生薪資比女生薪資多?依照差異大小由大到小排序(3分)
Manhigher103<-filter(salaryrate103,`大學-女/男`<100)%>%arrange(`大學-女/男`)
knitr::kable(Manhigher103)

#呈現前十名的資料(2分)
mantop10in103<-head(Manhigher103,10)
knitr::kable(mantop10in103)

#請問那些行業女生薪資比男生薪資多? 依據差異大小由大到小排序(3分)
womanhigher103<-filter(salaryrate103,`大學-女/男`>100)%>%arrange(`大學-女/男`)
knitr::kable(womanhigher103)
#呈現前十名的資料(2分)並用文字說明結果(10分)
womantop10in103<-head(womanhigher103,10)
knitr::kable(womantop10in103)
#在103年數據內所有資料中，女性沒有任何一筆資料顯示薪資高於同樣大學畢業學歷之男性，
#男女同樣薪資的資料顯示有三筆，分別為"礦業及土石採取業-技術員及助理專業人員"、"用水供應及污染整治業-服務及銷售工作人員"、
#"營造業-服務及銷售工作人員"，有兩筆的職業別為服務及銷售工作人員。
# 而薪資明顯低於男性的職業為"礦業及土石採取業-技藝、機械設備操作及組裝人員"，相差15.03%；
#薪資有差距但差距最小的職業為"住宿及餐飲業-技術員及助理專業人員"，相差0.03%。

#104
salaryrate104<-select(X104category,年度,大職業別,`大學-女/男`)
salaryrate104$`大學-女/男`<-gsub("—|…",NA,salaryrate104$`大學-女/男`)
salaryrate104$`大學-女/男`<-as.numeric(salaryrate104$`大學-女/男`)
Manhigher104<-filter(salaryrate104,`大學-女/男`<100)%>%arrange(`大學-女/男`)
knitr::kable(Manhigher104)

mantop10in104<-head(Manhigher104,10)
knitr::kable(mantop10in104)

womanhigher104<-filter(salaryrate104,`大學-女/男`>100)%>%arrange(`大學-女/男`)
knitr::kable(womanhigher104)

womantop10in104<-head(womanhigher104,10)
knitr::kable(womantop10in104)
# 在104年數據內所有資料中，女性一筆資料顯示薪資高於同樣大學畢業學歷之男性，
# 為"專業、科學及技術服務業-技藝、機械設備操作及組裝人員"，提高了0.26%。
# 男女同樣薪資的資料顯示有四筆，分別為"用水供應及污染整治業-服務及銷售工作人員"、"不動產業-技藝、機械設備操作及組裝人員"、
# "醫療保健服務業-服務及銷售工作人員"、"其他服務業-專業人員"，有兩筆的職業別為服務及銷售工作人員。
# 而薪資男女差異最大的職業為"電力及燃氣供應業-技藝、機械設備操作及組裝人員"，相差8.31%；
# 薪資有差距但差距最小的職業為"住宿及餐飲業-技術員及助理專業人員"，相差0.03%，跟前一年一樣呢。

#105
salaryrate105<-select(X105category,年度,大職業別,`大學-女/男`)
salaryrate105$`大學-女/男`<-gsub("—|…",NA,salaryrate105$`大學-女/男`)
salaryrate105$`大學-女/男`<-as.numeric(salaryrate105$`大學-女/男`)
Manhigher105<-filter(salaryrate105,`大學-女/男`<100)%>%arrange(`大學-女/男`)
knitr::kable(Manhigher105)

mantop10in105<-head(Manhigher105,10)
knitr::kable(mantop10in105)

womanhigher105<-filter(salaryrate105,`大學-女/男`>100)%>%arrange(`大學-女/男`)
knitr::kable(womanhigher105)

womantop10in105<-head(womanhigher105,10)
knitr::kable(womantop10in105)
# 在105年數據內所有資料中，女性一筆資料顯示薪資高於同樣大學畢業學歷之男性，
# 為"金融及保險業-專業人員"，提高了0.11%。
# 男女同樣薪資的資料顯示有五筆，分別為"礦業及土石採取業-服務及銷售工作人員"、"用水供應及污染整治業-服務及銷售工作人員"、
# "教育服務業-服務及銷售工作人員"、"醫療保健服務業-技藝、機械設備操作及組裝人員"、
# "藝術、娛樂及休閒服務業-技術員及助理專業人員"，有三筆的職業別為服務及銷售工作人員，比前幾年多了一筆。
# 而薪資男女差異最大的職業為"不動產業-技藝、機械設備操作及組裝人員"，相差8.62%；
# 薪資有差距但差距最小的職業為"營造業-技藝、機械設備操作及組裝人員"，相差0.01%。

#106
salaryrate106<-select(X106category,年度,大職業別,`大學-女/男`)
salaryrate106$`大學-女/男`<-gsub("—|…",NA,salaryrate106$`大學-女/男`)
salaryrate106$`大學-女/男`<-as.numeric(salaryrate106$`大學-女/男`)
Manhigher106<-filter(salaryrate106,`大學-女/男`<100)%>%arrange(`大學-女/男`)
knitr::kable(Manhigher106)

mantop10in106<-head(Manhigher106,10)
knitr::kable(mantop10in106)

womanhigher106<-filter(salaryrate106,`大學-女/男`>100)%>%arrange(`大學-女/男`)
knitr::kable(womanhigher106)

womantop10in106<-head(womanhigher106,10)
knitr::kable(womantop10in106)
#在106年數據內所有資料中，女性一筆資料顯示薪資高於同樣大學畢業學歷之男性，
#為"資訊及通訊傳播業-服務及銷售工作人員"，提高了0.33%。
#男女同樣薪資的資料顯示有八筆，逐年增加呢開心!分別為"礦業及土石採取業-技術員及助理專業人員"、"用水供應及污染整治業-服務及銷售工作人員"、
#"資訊及通訊傳播業-技藝_機械設備操作及組裝人員"、"金融及保險業-技藝_機械設備操作及組裝人員"、
#"不動產業-專業人員"、"不動產業-服務及銷售工作人員"、"不動產業-技藝_機械設備操作及組裝人員"、
#"專業_科學及技術服務業-技藝_機械設備操作及組裝人員"，有四筆的職業別為技藝_機械設備操作及組裝人員。
# 而薪資男女差異最大的職業為"電力及燃氣供應業-技藝_機械設備操作及組裝人員"，相差4.49%；
#薪資有差距但差距最小的職業為"住宿及餐飲業-服務及銷售工作人員"，相差0.02%。


# 以106年度的資料來看，哪個職業別念研究所最划算 (研究所學歷薪資與大學學歷薪資增加比例最多)? 
# 請按照薪資差異比例由大到小排序(3分)，呈現前十名的資料(2分)，並用文字說明結果(10分)，共15分，
# 程式碼排版清晰易懂分數5分。
# 提示作法:
# 取出大學薪資欄位與研究所薪資欄位
# 計算研究所薪資 / 大學薪資，並用此值在表格中新增一個欄位
# 排序

compare106<-select(X106category,年度,大職業別,`大學-薪資`,`研究所及以上-薪資`)
compare106$`大學-薪資`<-gsub("—|…",NA,compare106$`大學-薪資`)
compare106$`研究所及以上-薪資`<-gsub("—|…",NA,compare106$`研究所及以上-薪資`)
compare106$`大學-薪資`<-as.numeric(compare106$`大學-薪資`)
compare106$`研究所及以上-薪資`<-as.numeric(compare106$`研究所及以上-薪資`)
# 請按照薪資差異比例由大到小排序(3分)
compare106<-mutate(compare106,IncreaseRate=`研究所及以上-薪資`/`大學-薪資`)%>%arrange(desc(IncreaseRate))
#呈現前十名的資料(2分)，並用文字說明結果(10分)
knitr::kable(top10<-head(compare106,10))
#數據顯示前十名的資料中，因為學歷而提高最多的職業為"礦業及土石採取業-事務支援人員"，提高率為1.208946。
#大學畢業的薪資皆不到三萬元，然而研究所畢業同職業薪水只有一筆沒超過三萬元。
#薪資依學歷的提高率為1.18~1.21之間，有三筆的職業為事務支援相關人員。




# 請列出自己有興趣的職業別 (至少一個至多五個)(5分)，並呈現相對應的大學畢業薪資與研究所畢業薪資(5分)，
# 請問此薪資與妳想像中的一樣嗎?(5分) 研究所薪資與大學薪資差多少呢?(5分) 
# 會因為這樣改變心意，決定念/不念研究所嗎?(5分)，共25分

#1.服務業部門-技術員及助理專業人員
#2.專業_科學及技術服務業-專業人員
#3.醫療保健服務業-技術員及助理專業人員
#4.其他服務業-技術員及助理專業人員

#並呈現相對應的大學畢業薪資與研究所畢業薪資(5分)
knitr::kable(selectjob<-filter(compare106,大職業別%in% c("服務業部門-技術員及助理專業人員",
                                                     "專業_科學及技術服務業-專業人員"
                                          ,"醫療保健服務業-技術員及助理專業人員","其他服務業-技術員及助理專業人員")))

#大學畢業的學歷有兩個薪水不到3萬蠻低的
#研究所薪資與大學薪資差多少呢?(5分) 
knitr::kable(selectjob<-mutate(selectjob,SalaryGap=`研究所及以上-薪資`-`大學-薪資`))


#會吧因為差距有點大，幸好我已經決定要讀研究所了










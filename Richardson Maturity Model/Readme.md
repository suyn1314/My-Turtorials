# Richardson Maturity Model 

## Summary
**level 1**將本來只是透過HTTP做傳輸，永遠都是呼叫同一個endpoint的**level 0**，拆解成一個個的resource，也增加了易讀性; **level 2**進一步的使用HTTP 動詞，改善了**level 1**只使用一個HTTP 動詞的問題; **level 3** 則是讓client端在接收到response之後，不必事先知道下一步該怎做，而是由server端在response時一並告訴它。

## RESTful API
REST (<font color=red>Re</font>presentational <font color=red>S</font>tate <font color=red>T</font>ransfer)，是一種網路架構，符合REST架構的API我們稱為RESTful API。RESTful API會透過HTTP method(**POST**, **GET**, **PUT**, **DELETE**)來發request

## HTTP verbs in CRUD services
HTTP verb | CRUD service   
--------- | --------------
POST      | Create operation
GET       | Read operation
PUT       | Update operation
DELETE    | Delete operation

## [HTTP Status code](https://zh.wikipedia.org/wiki/HTTP状态码) 
Status code | Message   
----------- | --------------
200         | OK
201         | Created
404         | Not found
409         | Conflict

## [Richardson Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html)
#### Level 0: The Swamp of POX 
所有資訊都包成一整包的xml，對同一個endpoint發出request。
#### Level 1: Resources 
透過divide and conquer將level 0拆解，不再是對同一個endpoint發request，但過程中都使用同一個HTTP動詞。
#### Level 2: HTTP Verbs 
正確使用HTTP動詞及狀態碼。
#### Level 3: Hypermedia Controls
系統除了response資訊之外，還會告訴client下一步該怎麼做。



## In kanban project
![boards](https://raw.githubusercontent.com/ezkanbanteam/study_group_part2/master/board.png)

![in the board](https://raw.githubusercontent.com/ezkanbanteam/study_group_part2/master/inBoard.png)

#### Level 0
``` json
POST /board/editBoard HTTP/1.1
Host: ssl-ezscrum.csie.ntut.edu.tw/kanban

{
    "boardId"  : "880a9cfa-bf71-4d67-9f10-839da381eb10",
    "title" : "ezKanban"
}
```

```json
HTTP/1.1 200 OK
{
    outputMeaasge : "Title is changed."
}
```

#### Level 1
```json 
POST /board/id=880a9cfa-bf71-4d67-9f10-839da381eb10/edit HTTP/1.1
Host: ssl-ezscrum.csie.ntut.edu.tw/kanban
{
    "title" : "ezKanban"
}
```

```json
HTTP/1.1 200 OK
{
    outputMeaasge : "Title is changed."
}
```

#### Level 2
```json 
PUT /board/id=880a9cfa-bf71-4d67-9f10-839da381eb10 HTTP/1.1
Host: ssl-ezscrum.csie.ntut.edu.tw/kanban
{
    "title" : "ezKanban"
}
```

```json
HTTP/1.1 200 OK
{
    outputMeaasge : "Title is changed."
}
```

#### Level 3
```json 
POST /board/userId=fj49f34f-jd49-95fk-f93k-fk93kfpw0fjr HTTP/1.1
Host: ssl-ezscrum.csie.ntut.edu.tw/kanban
{
    "title" : "ezScrum"
}
```

```json
HTTP/1.1 201 OK
{
    outputMeaasge : "Board is created.",
    [
        {
            rel: "edit",
            uri: "/edit/880a9cfa-bf71-4d67-9f10-839da381eb10"
        },
        {
            rel: "delete",
            uri: "/delete/880a9cfa-bf71-4d67-9f10-839da381eb10"
        }
    ]
    
}
```

## Conclusion
從 Richardson Maturity Model 一步步的了解REATful API，透過漸進式的學習，可以更加認識REST的概念，比起一開始就把所有的規則都明文條列都來得有效。


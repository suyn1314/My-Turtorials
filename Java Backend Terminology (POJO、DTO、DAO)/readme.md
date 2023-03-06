# Java Backend Terminology (POJO、DTO、DAO)


- [POJO](#POJO-Plain-Old-Java-Object)
    - [時空背景知識](#時空背景知識)
- [PO](#PO-Persistent-Object)
- [DAO](#DAO-Data-Access-Object)
- [BO](#BO-Business-Object)
- [DTO](#DTO-Data-Transfer-Object)
- [VO](#VO-Value-Object)
- [Conclusion](#Conclusion)

## POJO (Plain Old Java Object)

- [POJO](https://en.m.wikipedia.org/wiki/Plain_old_Java_object)是一個簡單普通的Java物件([不是JavaBean](https://www.geeksforgeeks.org/pojo-vs-java-beans/)、EntityBean等)，包含商業邏輯處理與自己的屬性以及提取或設定這些屬性的method(getter、setter)，不擔任任何的特殊的角色：

    - 不extend其他classes，例如：

    ```
    public class Foo extends javax.servlet.http.HttpServlet { ...
    ```

    - 不實作其他介面，例如：

    ```
    public class Bar implements javax.ejb.EntityBean { ...
    ```

    - 不包含annotations，例如

    ```
    @javax.persistence.Entity public class Baz { ...
    ```

- 範例:

```
public class User {
    private Long id;
    private String username;
    private String password; 
    
    public User(Long id, String username, String password){
        this.id = id;
        this.username = username;
        this.password = password;
    }
    
    public Long getId(){
        return id;
    }
    public String getUsername(){
        return username;
    }
    public String getPassword(){
        return password;
    }
    public void setId(Long id){
        this.id = id;
    }
    public void setUsername(String username){
        this.username = username;
    }
    public void setPassword(String password){
        this.password = password;
    }
}
```

### 時空背景知識

- 1997年IBM提出企業級JavaBean（Enterprise JavaBean,簡稱 [EJB](https://zh.wikipedia.org/wiki/EJB)），目的在於處理商業邏輯放在伺服器端，而非客戶端，且同時處理生命週期分配和安全對策等問題，使開發人員能專注在處理商業邏輯上的一個Java後端開發標準規範。
- 但是EJB的複雜性高，有許多規範要遵守，部署測試也很麻煩。
- [Spring](https://zh.wikipedia.org/wiki/Spring_Framework)是一個開源框架，於2003年興起的一個輕量級(與EJB對比消耗的資源少)的Java開發框架，這種輕量的技術就被拿來代替EJB了。
- Spring中有一個名詞被大量使用，就是POJO。
- [POJO](https://martinfowler.com/bliki/POJO.html)這個名詞是Martin Fowler、Rebecca Parsons和Josh MacKenzie在2000年的一次演講提出的，後來也被大量用於Spring中：
> In the talk we were pointing out the many benefits of encoding business logic into regular java objects rather than using Entity Beans. We wondered why people were so against using regular objects in their systems and concluded that it was because simple objects lacked a fancy name. So we gave them one, and it's caught on very nicely.
> 
- 將商業邏輯放在POJO比放在EntityBean更好，沒有什麼特殊規範需要遵守。

---

## PO (Persistent Object)
 - Persistent是持久化，持久化是指將原本程序中的資料經由轉化，轉化成其他資料儲存物件可以儲存的格式，然後傳輸至該資料儲存物件。這個轉化儲存的過程稱作持久化。(將資料經過程序處理放至資料庫是其中一種例子)
 - PO是一個攜帶資料並被提取資料放入資料庫或從資料庫提取資料並攜帶然後被傳輸的物件。PO裡的屬性和資料庫中的資料表上的欄位一一對應，可以帶有商業邏輯，但是裡面不應該包含任何對資料庫的操作。
 - Persistence範例:
```
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
public static void main(String[] args) {
        emFactory = Persistence.createEntityManagerFactory("com.concretepage");
		EntityManager em = emFactory.createEntityManager();	
		em.getTransaction().begin();
		User user = new User(109000000L, "Admin", "1234");
		em.persist(user);
		em.getTransaction().commit();
		em.close();
		emFactory.close();
		System.out.println("Entity saved.");
	}
```
 - PO範例:
    
```
public class User implements Serializable {
    private static final long serialiVersionUID = 1L；
	private Long id;
    private String username;
    private String password;    
    public Long getId(){
        return id;
    }
    public String getUsername(){
        return username;
    }
    public String getPassword(){
        return password;
    }
    public void setId(Long id){
        this.id = id;
    }
    public void setUsername(String username){
        this.username = username;
    }
    public void setPassword(String password){
        this.password = password;
    }
}
```

---

## DAO (Data Access Object)

 - DAO是一個負責對資料庫進行操作（CRUD操作）的物件，將資料從資料庫提取出來並將資料包裝成PO，或是從PO中提取資料放進資料庫。
 - 包含商業邏輯，不會轉化成其他物件或被傳輸到其他物件。
 - 對物件(PO)進行操作而不用考慮不同資料庫語法不同。
 - 代表持久化層，夾在商業邏輯層與資料庫中間。
 - 簡易範例:
```
public interface Dao{
    int insert(User user);
    User selectById(long id);
}
```

---

## BO (Business Object)
 - BO是一個帶有商業邏輯的物件，實際上的邏輯處理等操作都由BO負責(除了對資料庫以外)，例如驗證或轉換等等。簡單說就是演算法或是Service。
 - 代表商業邏輯層，在持久化層和Service層中間，和PO的差別在於BO包含複雜的商業邏輯。也可以包括一個或多個其它的物件。
 - 所以可以將攜帶資料的物件(可以是PO、POJO等物件)轉化成上層需要的物件進行傳輸，或是包含一個或多個攜帶資料的物件然後被其他BO進行操作。

---

## DTO (Data Transfer Object)

 - DTO是一個負責帶資料的物件，將資料帶往前端，裡面不包含商業邏輯。
 - DTO攜帶的資料是對於商業邏輯而言所需要的資料，而PO的資料則是對應到資料庫的資料表。
 - PO傳輸過程中經由BO處理變成DTO，將資料傳往其他系統或是服務時使用DTO傳輸。通常DTO裡的資料會比PO少，因為不需要將全部的資料傳輸出去。DTO能避免過多無用資料傳輸及避免更改到底層的傳輸物件以及減少依賴。
- 如果我們沒有持久化層(沒有PO)，那麼DTO就會被DAO進行處理而傳輸至資料庫，但是這樣就很危險，可能會更動到資料庫。

```
public class UserDTO extends User {
    //序列化版本
    private static final long serialiVersionUID = 2L；
    //使用者UID
    private String username;
    public String getUsername(){return username;}
    public void setUsername(String username){this.username= username;}
    //新增額外屬性
    private HashMap<String, Object> extProperties;        
    public HashMap<String, Object> getExtProperties() {
        return extProperties;
    }
    public void setExtProperties(HashMap<String, Object> extProperties) {
        this.extProperties = extProperties;
    }
}
```

---

## VO (Value Object)

 - VO也是一個負責帶資料的物件，將資料帶往前端，和DTO不同的是這些資料將用於顯示，所以VO也被稱作View Object。
 - POJO用作表示層就變成VO，在商業邏輯層和前端網頁，和DTO相似，差異在於VO可以將資料傳向前端網頁。

---

## Conclusion

![](https://i.imgur.com/98Ae6I1.png)

- POJO是一個簡單純粹的Java物件，許多時候都將轉化成其他物件使用。
  * PO攜帶資料，經由持久化轉換成資料庫(或其他資料儲存物件)可以儲存的格式之後，就可以進行傳輸。(PO可以是由POJO實作其他介面或extend其他類別而來)
  * POJO攜帶資料在傳輸過程中就是DTO。
  * POJO攜帶資料將資料傳往前端顯示就是VO。
- DAO和BO則都是進行邏輯操作的物件，DAO是對於資料庫進行操作的物件，BO則是負責複雜的商業邏輯。



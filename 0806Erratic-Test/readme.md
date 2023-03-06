# `Erratic Test`

## **Interacting Tests**

## `Symptoms` :

一個獨立運作的Test Fail 當:
* Suite中加入或移除某個Test
* Suite中某個Test Fail
* 此Test(或其他Test)檔案名稱或路徑變更
* Test Runner 版本變更

## `Example`

<img src="picture/Interacting Tests Example.png">

## `Root Cause`

通常發生於Test使用`Shared Fixure`, 而與其他Test產生某種程度的相依性. 

## **Shared Fixure**
多個Test Case共用相同的Test Fixure

<img src="picture/Shared Fixture.gif" width="80%" height="80%">

## `Possible Solution`
* Fresh Fixure
* Immutable Shared Fixture
* Lazy Setup

## **Fresh Fixure**
每個Test Case都會建立自己的Test Fixure

<img src="picture/Fresh Fixture.gif" width="80%" height="80%">

### `Example`
After use Fresh Fixure

<img src="picture/Fresh Fixure Example.png" width="80%" height="80%">

## **Immutable Shared Fixture**
將每個Test都需要且不會被變更的Fixure, 建立為Shared Fixure, 需要被Test變更或刪除的Fixure則建立為Fresh Fixure

<img src="picture/Immutable Shared Fixure.png" width="80%" height="80%">

### `Example`
After use Immutable Shared Fixture

<img src="picture/Immutable Shared Fixure Example.png" width="80%" height="80%">

## **Lazy Setup**
每個Test Case在執行前先確認Test Fixure是否建立完成, 若未建立則自己建立Test Fixure
<img src="picture/Lazy Setup.gif" width="80%" height="80%">

### `Example`
After use Lazy Setup

<img src="picture/Lazy Setup Example.png" width="100%" height="100%">



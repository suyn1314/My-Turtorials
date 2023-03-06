# Design by Contract

## Introduction
**Design by Contract** is a software correctness methodology.<br>
In the real world, we sign a contract to ensure what **benefits** we will get and what **obligations** we need to fulfill.<br>
For example, if you want to send an urgent package and you don't have time to deliver it yourself, you will contract out the task to a courier service.

|Party|Obligations|Benefits|
|-----|-----------|--------|
|Client (You)|Provide a package of no more than 5kg and each dimension no more than 90 cm.<br>Pay 120 NTD.|Get package delivered to recipient in 3 hours or less.|
|Supplier (Courier Service)|Deliver package to recipient in 3 hours or less.|No need to deal with deliveries too big, too heavy or unpaid.|

A contract document can protect both side:
- It protects client by specifying how much should be done: The client is entitled to receive a certain result.
- It protects supplier by specifying how little is acceptable: The supplier must not be liable for failing to carry out tasks out side of the specified scope.

**Design by Contract** uses assertions, called precondition and postcondition, to specify the relationship the client and the supplier.
```eiffel
method_name(args) is 
    require
        Precondition
    do
        method body
    ensure
        Postcondition
    end
```
There are 2 assertion violations may occur:
- A precondition violation indicates a bug in the client. The client didn't observe the conditions imposed on correct calls.
- A postcondition violation indicates a bug in the supplier. The method failed to deliver on its promises.

According to precondition and postcondition, the method can check the input is valid and the output is computed correctly.

Therefore, the developers may reduce the redundant unit tests after applying **Design by Contract**.

## Example
Contract implementation in Java:
```java
public class Contract {
    // region: Precondition
    public static void require(String annotation, boolean value) {
        if (!value){
            throw new PreconditionViolationException(annotation);
        }
    }

    public static void requireNotNull(String annotation, Object obj) {
        require(format("[%s] cannot be null", annotation), null != obj);
    }

    public static void requireNotEmpty(String annotation, String str) {
        require(format("[%s] cannot be empty", annotation), !str.isEmpty());
    }

    public static void require(String annotation, BooleanSupplier exp) {
        require(annotation, exp.getAsBoolean());
    }
    // end region

    // region: Postcondition
    public static boolean ensure(String annotation, boolean value) {
        if (!value){
            throw new PostconditionViolationException(annotation);
        }
        return true;
    }

    public static boolean ensureNotNull(String annotation, Object obj) {
        return ensure(format("[%s] cannot be null", annotation), null != obj);
    }

    public static boolean ensure(String annotation, BooleanSupplier exp) {
        return ensure(annotation, exp.getAsBoolean());
    }
    // end region
}
```
A method applied **Design by Contract**:
```java
public void commitCardInLane(CardId cardId, LaneId laneId, int order, String userId) {
    requireNotNull("Card id", cardId);
    requireNotNull("Lane id", laneId);
    require("Order >= 0",  () -> order >= 0);
    requireNotNull("User id", userId);
    require(format("Lane '%s' exists", laneId),  () -> getLaneById(laneId).isPresent());
    require(format("Card '%s' is not committed to any lane'", cardId),
            () -> card_not_comitted_to_any_lane(cardId));
    require("Order <= committed card size of lane",
            () -> order <= getLaneById(laneId).get().getCommittedCards().size());
    require("Lane does not have any child",  () -> getLaneById(laneId).get().getChildren().size() == 0);

    context.apply(new WorkflowEvents.CardCommitted(
            data.boardId(),
            data.workflowId(),
            laneId,
            cardId,
            order,
            userId,
            UUID.randomUUID(),
            DateProvider.now()));

    ensure(format("Card '%s' is committed to lane '%s'", cardId, laneId),  () -> getLaneById(laneId).get().getCommittedCard(cardId).isPresent());
    ensure(format("Card order is '%d'", order), () -> getLaneById(laneId).get().getCommittedCard(cardId).get().order() == order);
    ensure(format("Committed cards are sorted"),  () -> committed_cards_are_sorted(laneId));
}
```

## References
[Applying "Design by Contract"](https://ieeexplore.ieee.org/document/161279)

[Design by Contract](https://wiki.c2.com/?VerifiedDesignByContract)
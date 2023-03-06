Humble Object
===
http://xunitpatterns.com/Humble%20Object.html
![](https://g0vhackmd.blob.core.windows.net/g0v-hackmd-images/upload_35223a25c6c7ed608820ee6d6b309225)

How can we make code testable when it is too closely coupled to its environment?

**We extract the logic into a separate easy-to-test component that is decoupled from its environment.**

> Sometimes this test difficulty is over-stated. You can often get surprisingly far by creating widgets and manipulating them in test code. But there are occasions where this is impossible, you miss important interactions, there are threading issues, and the tests are too slow to run. 
> from Martin Fowler GUI Architectures
> https://martinfowler.com/eaaDev/uiArchs.html
> 

![](https://g0vhackmd.blob.core.windows.net/g0v-hackmd-images/upload_11faa2e2dd1e0d455e91d8a55aa06930)


```javascript=    
    handleSubmit() {
        if (this.state.description === '') {
            return;
        }
        let self = this;
        let description = this.state.description;
        let swimLaneId = this.props.swimLaneId;
        let estimate = this.state.estimate;
        let deadline =  '';
        let miniStageId = this.props.miniStageId;
        let stageId = this.props.stageId;
        let categoryId = this.state.selectedOptionValue;
        if(this.state.deadline){
            deadline = moment(this.state.deadline).format('YYYY-MM-DD');
        }
        if(estimate === ''){
            estimate = 0;
        }
        let notes = this.state.notes;
        axios.post(Config.host + Config.kanban_api + '/workItem/addWorkItem',{
            swimLaneId : swimLaneId,
            description : description,
            categoryId : categoryId,
            userId : '' ,
            estimate : estimate,
            notes : notes,
            deadline: deadline, 
            miniStageId: miniStageId, 
            stageId: stageId
        }).then(function (response) {
            self.props.getWorkItemsOfSwimLane(swimLaneId);
            self.props.getNumberOfWorkItemsInMiniStage(self.props.miniStageId);
            self.props.getNumberOfWorkItemsInStage(self.props.stageId);
            self.props.getWipLimitInStage(self.props.stageId);
            self.handleClose();
        }).catch(function (error){
            console.log(error);
        });
    }

```
## How It Works 

We extract all the logic from the hard-to-test component into a component that is testable via synchronous tests. This component implements a service interface consisting of methods that expose all the logic of the untestable component; the only difference is that they are accessible via synchronous method calls. As a result, the Humble Object component becomes a very thin adapter layer that contains very little code. Each time the Humble Object is called by the framework, it delegates to the testable component. If the testable component needs any information from the context, the Humble Object is responsible for retrieving it and passing it to the testable component. The Humble Object code is typically so simple that we often don't bother writing tests for it because it can be quite difficult to set up the environment need to run it. 

```java= 
public interface AddWorkItemOutput extends Output{
	public String getWorkItemId();
	
	public void setWorkItemId(String workItemId);
}
```

```java= 
@Path("/workItem")
public class AddWorkItemRestfulAPI implements AddWorkItemOutput{
	private ApplicationContext applicationContext = ApplicationContext.getInstance();

	private String workItemId;
	
	@POST
	@Path("/addWorkItem")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public AddWorkItemOutput addWorkItem(String workItemInfo) {
		AddWorkItemUseCase addWorkItemUseCase = applicationContext.newAddWorkItemUseCase();
		
		String swimLaneId = "";
		String description = "";
		String categoryId = "";
		String userId = "";
		int estimate = 0;
		String notes = "";
		String deadline = "";
		String miniStageId = "";
		String stageId = "";
		
		try {
			JSONObject workItemJSON = new JSONObject(workItemInfo);
			swimLaneId = workItemJSON.getString("swimLaneId");
			description = workItemJSON.getString("description");
			categoryId = workItemJSON.getString("categoryId");
			userId = workItemJSON.getString("userId");
			estimate = workItemJSON.getInt("estimate");
			notes = workItemJSON.getString("notes");
			deadline = workItemJSON.getString("deadline");
			miniStageId = workItemJSON.getString("miniStageId");
			stageId = workItemJSON.getString("stageId");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		AddWorkItemInput input = (AddWorkItemInput) addWorkItemUseCase;
		input.setSwimLaneId(swimLaneId);
		input.setDescription(description);
		input.setCategoryId(categoryId);
		input.setUserId(userId);
		input.setEstimate(estimate);
		input.setNotes(notes);
		input.setDeadline(deadline);
		input.setMiniStageId(miniStageId);
		input.setStageId(stageId);
		
		AddWorkItemOutput output = this;
		
		addWorkItemUseCase.execute(input, output);
		
		return output;
	}

	@Override
	public String getWorkItemId() {
		return workItemId;
	}

	@Override
	public void setWorkItemId(String workItemId) {
		this.workItemId = workItemId;
	}
}
```
When To Use It 
---
We can and should introduce a Humble Object whenever we have non-trivial logic in a component that is hard to instantiate because it depends on a framework or can only be accessed asynchronously. There are lots of reasons for objects being hard-to-test so there need to be lots of variations in how we break the dependencies. The following are the most common examples of Humble Object but we shouldn't be surprised if we need to invent our own variation. 

#### Variation: Humble Dialog 
Visual objects are very hard to test efficiently because they are tightly coupled to the presentation framework that invokes them.

#### Variation: Humble Executable 
Humble Executable is a way to bring the logic of the executable under test without incurring the delays that lead to Slow Tests and Nondeterministic Tests. 


#### Variation: Humble Transaction Controller 
Humble Transaction Controller is a way to make testing of the logic that runs within the transaction easier by making it possible for the test to control the transaction. This allows us to exercise the logic, verify the outcome and then abort the transaction leaving no trace of our activity in the database.


#### Variation: Humble Container Adapter
Another example of Humble Object is to design our objects to be container-independent and have a Humble Container Adapter that adapts them to the interface required by container. This makes our logic components easy to test outside the container which dramatically reduces the time for an "edit-compile-test" cycle. 



Implementation Notes
---

All the ways involve exposing the logic so that it can be verified using synchronous tests. 

Regardless of how the logic is exposed, test-driven purists would like to see tests that verify that the Humble Object is calling the extracted logic properly. This can be done by replacing the real methods with some kind of Test Double implementation. 

#### Variation: Poor Man's Humble Object 

The simplest way is to isolate and expose each piece of logic we want to verify into a separate method. We can do this by using an Extract Method refactoring on inline logic and then making the resulting method visible from the test. 

#### Variation: True Humble Object 
At the other extreme, we can put the logic we want to test into a separate class and have the Humble Object delegate to an instance of it.

```java= 
@Test
	public void Should_Success_When_AddWorkItem() {
		int originalNumberOfWorkItems = swimLane.getWorkItemIds().size();
		
		AddWorkItemUseCase addWorkItemUseCase = new AddWorkItemUseCaseImpl(fakeCategoryRepository, fakeStageRepository, fakeWorkItemRepository);
		
		AddWorkItemInput input = (AddWorkItemInput) addWorkItemUseCase;
		input.setStageId(stage.getStageId());
		input.setMiniStageId(miniStage.getMiniStageId());
		input.setDescription("description");
		input.setSwimLaneId(swimLane.getSwimLaneId());
		
		AddWorkItemOutput output = new AddWorkItemRestfulAPI();
		
		addWorkItemUseCase.execute(input, output);
		
		miniStage = new ArrayList<>(stage.getMiniStages()).get(0);
		swimLane = new ArrayList<>(miniStage.getSwimLanes()).get(0);
		int newNumberOfWorkItems = swimLane.getWorkItemIds().size();
		
		List<DomainEvent> events = fakeEventStore.getByEventType(WorkItemAdded.class.getSimpleName());
		
		assertEquals(1, events.size());
		assertEquals(1, newNumberOfWorkItems - originalNumberOfWorkItems);
	}

```

Result Context
---

|  | 沒有使用Humble Object | 使用Humble Object |
| -------- | -------- | -------- |
|較容易造成Slow Test|✔     |      |
|與 framework 有Low coupling||✔|
|程式碼較較少 |✔|
|維護程式較容易||✔
|使用synchronous tests||✔
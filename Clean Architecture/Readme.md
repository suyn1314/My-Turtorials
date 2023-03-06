# Clean Architecture

![](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)
source:[The Clean Code Blog, The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)




#### •	Entities：
Entities encapsulate Enterprise wide business rules. An entity can be an object with methods, or it can be a set of data structures and functions. It doesn’t matter so long as the entities could be used by many different applications in the enterprise.

#### •	Use Cases：
The software in this layer contains application specific business rules. It encapsulates and implements all of the use cases of the system. These use cases orchestrate the flow of data to and from the entities, and direct those entities to use their enterprise wide business rules to achieve the goals of the use case.

#### •	Interface Adapters：
The software in this layer is a set of adapters that convert data from the format most convenient for the use cases and entities, to the format most convenient for some external agency such as the Database or the Web.

#### •	Frameworks and Drivers：
The outermost layer is generally composed of frameworks and tools such as the Database, the Web Framework, etc. Generally you don’t write much code in this layer other than glue code that communicates to the next circle inwards.



### Dependency Rule
The overriding rule that makes this architecture work is The Dependency Rule. This rule says that source code dependencies can only point inwards. Nothing in an inner circle can know anything at all about something in an outer circle. In particular, the name of something declared in an outer circle must not be mentioned by the code in the an inner circle. That includes, functions, classes. variables, or any other named software entity.

### Crossing Boundaries.
At the lower right of the diagram is an example of how we cross the circle boundaries. It shows the Controllers and Presenters communicating with the Use Cases in the next layer. Note the flow of control. It begins in the controller, moves through the use case, and then winds up executing in the presenter. Note also the source code dependencies. Each one of them points inwards towards the use cases.

# A Typical Scenario

![](https://i.imgur.com/bEK9G20.jpg)



source:[Clean Architecture: A Craftsman’s Guide to Software Structure and Design Chapter22 The Clean Architecture]()

A typical scenario for a web-base Java system utilizing a database
# Example


#### GetStagesByBoardIdRestfulAPI
``` java

public class GetStagesByBoardIdRestfulAPI {

    private ApplicationContext applicationContext = ApplicationContext.getInstance();

    @GET
    @Path("boards/{boardId}/stages")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getStage(@PathParam("boardId") String boardId) {
        GetStagesByBoardIdUseCase getStagesByBoardIdUseCase = applicationContext.newGetStagesByBoardIdUseCase();

        GetStagesByBoardIdInput input = (GetStagesByBoardIdInput) getStagesByBoardIdUseCase;
        input.setBoardId(boardId);

        GetStagesByBoardIdPresenter presenter = new GetStagesByBoardIdPresenter();

        getStagesByBoardIdUseCase.execute(input, presenter);

        if (presenter.getStageList() != null) {
            return Response.status(Response.Status.OK).entity(presenter.buildViewModel()).build();
        }
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(ErrorCodeHandler.GET).build();
    }
}


```

#### GetStagesByBoardIdUseCase
``` java
public interface GetStagesByBoardIdUseCase extends UseCase<GetStagesByBoardIdInput, GetStagesByBoardIdOutput>{

}
```

#### UseCase
``` java
public interface UseCase<I extends Input, O extends Output> {
    void execute(I input, O output);
}
```
#### GetStagesByBoardIdInput
``` java
public interface GetStagesByBoardIdInput extends Input{
    public String getBoardId();

    public void setBoardId(String boardId);
}
```

#### GetStagesByBoardIdOutput
``` java
public interface GetStagesByBoardIdOutput extends Output{
    public List<StageModel> getStageList();

    public void setStageList(List<StageModel> stageList);
}
```

#### ApplicationContext
``` java
public class ApplicationContext {
    private static ApplicationContext instance = null;
    
    private BoardRepository boardRepository;
    private StageRepository stageRepository;
    private GetStagesByBoardIdUseCase getStagesByBoardIdUseCase;

    public static synchronized ApplicationContext getInstance() {
        if(instance == null){
            instance = new ApplicationContext();
        }
        return instance;
    }

    public BoardRepository newBoardRepository() {
        boardRepository = new MySqlBoardRepositoryImpl();
        return boardRepository;
    }
    
    public StageRepository newStageRepository(){
        stageRepository = new MySqlStageRepositoryImpl();
        return stageRepository;
    }

    public GetStagesByBoardIdUseCase newGetStagesByBoardIdUseCase() {
        getStagesByBoardIdUseCase = new GetStagesByBoardIdUseCaseImpl(newBoardRepository(), newStageRepository());
        return getStagesByBoardIdUseCase;
    }
    
    ...
}
```

#### GetStagesByBoardIdUseCaseImpl
``` java
public class GetStagesByBoardIdUseCaseImpl implements GetStagesByBoardIdUseCase, GetStagesByBoardIdInput{
    private StageRepository stageRepository;
    private BoardRepository boardRepository;
    private String boardId;

    public GetStagesByBoardIdUseCaseImpl(BoardRepository boardRepository, StageRepository stageRepository) {
        this.stageRepository = stageRepository;
        this.boardRepository = boardRepository;
    }

    @Override
    public void execute(GetStagesByBoardIdInput input, GetStagesByBoardIdOutput output) {
        List<StageModel> stageList = new ArrayList<>();
        Board board = boardRepository.getBoardById(input.getBoardId());

        for(Stage stage : stageRepository.getStagesByBoardId(input.getBoardId())) {
            stageList.add(ConvertStageToDTO.transform(stage, board.getOrderByStageIdInBoard(stage.getStageId())));
        }

       

        output.setStageList(stageList);
    }

    @Override
    public String getBoardId() {
        return boardId;
    }

    @Override
    public void setBoardId(String boardId) {
        this.boardId = boardId;
    }
}
```


#### Stage
``` java
public class Stage {

    private String stageId;
    private String title;
    private String boardId;
    private Collection<MiniStage> miniStages;

    public Stage() {
        miniStages = new ArrayList<>();
    }

    public Stage(String stageId, String title, String boardId) {
        this.stageId = stageId;
        this.title = title;
        this.boardId = boardId;
        miniStages = new ArrayList<>();

    }
        
    public MiniStage createNewMiniStage(String title) {
        int orderId = miniStages.size() + 1;
        MiniStage miniStage = MiniStageBuilder.newInstance()
                .title(title)
                .stageId(stageId)
                .boardId(boardId)
                .orderId(orderId)
                .build();
        miniStages.add(miniStage);
    }
        ...
}
```
#### StageModel
``` java
public class StageModel {
    private String stageId;
    private String title;
    private String boardId;
    private int orderId;
    private List<MiniStageModel> miniStageList;

    public String getStageId() {
        return stageId;
    }

    public void setStageId(String stageId) {
        this.stageId = stageId;
    }

    ... {Getter and Setter}
}
```
#### ConvertStageToDTO
``` java
public class ConvertStageToDTO {
    public static StageModel transform(Stage stage, int orderId) {
        StageModel dto = new StageModel();
        dto.setStageId(stage.getStageId());
        dto.setTitle(stage.getTitle());
        dto.setBoardId(stage.getBoardId());
        dto.setOrderId(orderId);
        List<MiniStageModel> miniStages = new ArrayList<>();
        for(MiniStage miniStage : stage.getMiniStages()) {
            miniStages.add(ConvertMiniStageToDTO.transform(miniStage));
        }
        dto.setMiniStageList(miniStages);
        return dto;
    }
}

```
#### StageRepository
``` java
public interface StageRepository {
    public void save(Stage stage);

    public void remove(Stage stage);

    public Collection<Stage> getStagesByBoardId(String boardId);

    public Stage getStageById(String stageId);
}

```
#### MySqlStageRepositoryImpl
``` java
public class MySqlStageRepositoryImpl implements StageRepository {
    private SqlDatabaseHelper sqlDatabaseHelper;
    private StageMapper stageMapper;
	
    public MySqlStageRepositoryImpl() {
        sqlDatabaseHelper = new SqlDatabaseHelper();
        stageMapper = new StageMapper();
    }
	
    @Override
    public void save(Stage stage) {
        ...
        StageData data = stageMapper.transformToStageData(stage);
        preparedStatement.setString(1, data.getStageId());
        preparedStatement.setString(2, data.getTitle());
        preparedStatement.setString(3, data.getBoardId());
        preparedStatement.executeUpdate();
        ...
    }
    
    @Override
    public void remove(Stage stage) {
        ...
    }
    
    @Override
    public Collection<Stage> getStagesByBoardId(String boardId) {
        ...
        while (resultSet.next()) {
            String stageId = resultSet.getString(StageTable.stageId);
            String title = resultSet.getString(StageTable.title);


            StageData data = new StageData();
            data.setStageId(stageId);
            data.setTitle(title);

            data.setBoardId(boardId);
            data.setMiniStageDatas(getMiniStageDatasByStageId(stageId));

            Stage stage = stageMapper.transformToStage(data);
            stages.add(stage);
        }
        ...
        
        return stages;
    }
}
```
#### StageData
``` java
public class StageData {
    private String stageId;
    private String title;
    private int orderId;
    private String boardId;

    ... {Getter and Setter}
}
```
#### StageMapper
``` java
public class StageMapper {
    public Stage transformToStage(StageData data) {
        Stage stage = new Stage();
        stage.setStageId(data.getStageId());
        stage.setTitle(data.getTitle());
        stage.setBoardId(data.getBoardId());
        return stage;
    }

    public StageData transformToStageData(Stage stage) {
        StageData data = new StageData();
        data.setStageId(stage.getStageId());
        data.setTitle(stage.getTitle());
        data.setBoardId(stage.getBoardId());
        return data;
    }
}
```

#### GetStagesByBoardIdPresenter
``` java
public class GetStagesByBoardIdPresenter implements Presenter<GetStagesByBoardIdOutput, GetStagesByBoardIdViewModel>, GetStagesByBoardIdOutput {
    private List<StageModel> stageList;

    @Override
    public GetStagesByBoardIdViewModel buildViewModel() {
        GetStagesByBoardIdViewModel viewModel = new GetStagesByBoardIdViewModel();
        viewModel.setStageList(stageList);
        return viewModel;
    }


    @Override
    public List<StageModel> getStageList() {
        return stageList;
    }

    @Override
    public void setStageList(List<StageModel> stageList) {
        this.stageList = stageList;
    }

}
```
#### Presenter
``` java
public interface Presenter<O extends Output,M extends ViewModel> {
    public M buildViewModel();
}
```

#### GetStagesByBoardIdViewModel
``` java
public class GetStagesByBoardIdViewModel implements ViewModel {
    
    private List<StageModel> stageList;

    public List<StageModel> getStageList() {
        return stageList;
    }

    public void setStageList(List<StageModel> stageList) {
        this.stageList = stageList;
    }

}
```


# Conclusion
依據Clean Architectue 分層與依賴規則，business rules可以在沒有使用UI與DB的情況下進行單元測試，外層框架替換不會去更動到內部的business rules。


# Reference
Clean Architecture: A Craftsman's Guide to Software Structure and Design (Robert C. Martin Series)

The Clean Code Blog : https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

搞笑談軟工 Clean Architecture : http://teddy-chen-tw.blogspot.com/2017/11/clean-architecture.html

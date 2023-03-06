# Git
Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

# Fetch
* ### Description
    Download objects and references from another repository.
* ### Command
    1. It would fetch `all of the branches` from the remote repository.
        ```bash
        $ git fetch <remote>
        ```  
        * ### Example
        ![](./image/fetch_1.png) 

        `$ git fetch origin`  

        ![](./image/fetch_2.png)  
        > Fetch 1 commit on master  
        > Fetch 1 commit on develop

    ---

    2. It would fetch `<branch>` from the remote repository.
        ```bash
        $ git fetch <remote> <branch>
        ```
        * ### Example
        ![](./image/fetch_1.png)  
        `$ git fetch origin master`  
        ![](./image/fetch_3.png)  
        > Fetch 1 commit on master  

# Merge
* ### Description
    Join two or more development histories together.
* ### Command
    It would integrate two or more branch to the current branch.
    ```bash
    $ git merge <branch>
    ```
    * ### Example
    ![](./image/merge_1.png)  
    `$ git merge develop`  
    ![](./image/merge_2.png)

* ### Option
    It would create merge new commit even if fast-forward merge.
    ```bash
    $ git merge <branch> --no-ff
    ```
    * ### Example
    ![](./image/merge_3.png)  
    `$ git merge develop --no-ff`  
    ![](./image/merge_4.png)  

# Rebase
* ### Description
    Reapply commits on top of another base tip.
* ### Command
    It would rewrites the history of a repository. 
    ```bash
    $ git rebase <branch>
    ```
    * ### Example
    ![](./image/rebase_1.png)  
    `$ git rebase master`  
    ![](./image/rebase_2.png)

* ### Option
    It would reapply commits which are after `<commit_id>`.  
    ```bash
    $ git rebase -i <commit_id>
    ```
    ![](./image/rebase_3.PNG)  
    `$ git rebase -i e556a95`  
    ![](./image/rebase_4.PNG)  
    `:wq`  
    ![](./image/rebase_5.PNG)  
    `:wq`  
    `$ git log --oneline`  
    ![](./image/rebase_6.PNG)  

# Pull
* ### Description
    Fetch from and integrate with another repository.
* ### Command
    1. It would fetch all branches from remote repository, and merge the remote branch whose name is the same as local one.
        ```bash
        $ git pull <remote>
        ````  
        * ### Example
        ![](./image/fetch_1.png)  
        `$ git pull origin`  
        ![](./image/pull_2.png)

    ---

    2. It would fetch `<branch>` from remote repository, and merge it to the local branch.
        ```bash
        $ git pull <remote> <branch>
        ````  
        * ### Example
        ![](./image/fetch_1.png)  
        `$ git pull origin master`  
        ![](./image/pull_1.png)

# Push
* ### Description
    Update remote refs along with associated objects.
* ### Command
    ```bash
    $ git push <remote> <branch>
    ```
    * ### Example
    ![](./image/push_1.png)  
    `$ git push origin master`  
    ![](./image/push_2.png)

* ### Option
    1. It would overwrite the remote commits that are different from local branch by local ones.
        ```bash
        $ git push <remote> <branch> --force
        ```
        * ### Example
        ![](./image/force_push_1.png)  
        `$ git push origin master --force`  
        ![](./image/force_push_2.png)

    --- 
    2. It would overwrite the remote commits that are different from local branch by local ones.  
        But if the local repository is not the newest, it would be rejected.  
        ```bash
        $ git push <remote> <branch> --force-with-lease  
        ```  
        * ### Example
        ![](./image/force_push_3.png)  
        `$ git push origin master --force-with-lease`  
        ![](./image/force_push_4.png)

# Cherry-pick
* ### Description
    Apply the changes introduced by some existing commits.
* ### Command
    It would copy the change from `<commit_id>` commit and create a new commit for it.  
    ```bash
    $ git cherry-pick <commit_id>
    ```
    master branch  
    ![](./image/log_2.PNG)  
    `$ git checkout Tina_branch`  
    ![](./image/Tina_branch.PNG)  
    `$ git cherry-pick 18c428d`  
    ![](./image/cherry-pick_1.PNG)  
    `$ git log --oneline`  
    ![](./image/cherry-pick_2.PNG)  
* ### Option
    1. It would copy the change from `<commit_id>` commit to working directory.  
        ```bash
        $ git cherry-pick <commit_id> --no-commit
        ```
        master branch  
        ![](./image/cherry-pick_3.PNG)  
        Tina_branch  
        ![](./image/Tina_branch.PNG)  
        `$ git cherry-pick d8c9776 --no-commit`  
        ![](./image/cherry-pick_4.PNG)  

    ---

    2. When the conflict occurs, you can run them.  
        ```bash
        $ git cherry-pick <commit_id> --continue
        $ git cherry-pick <commit_id> --abort
        $ git cherry-pick <commit_id> --quit
        ```
        * If you want to **go on** the next git cherry-pick, you can use `--continue` after you resolved the conflict.  
        * If you want to **cancel** this git cherry-pick, you can use `--abort`.  
          It will revert the current branch status before running git cherry-pick.  
        * If you want to **exit** this git cherry-pick, you can use `--quit`.  
          It would save the changes of files which don't occur conflict.  

# Log
* ### Description
    Show commit history.
* ### Command
    It would show commit ID, name and email of author, date to log and commit message.  
    ```bash
    $ git log
    ```
    ![](./image/log_1.PNG)

* ### Option
    1. It would show part of commit ID and its message.  
        ```bash
        $ git log --oneline
        ```
        ![](./image/log_2.PNG)
        
    ---  
    
    2. It would show the graph of commit history.  
        ```bash
        $ git log --graph  
        ```
        ![](./image/log_3.PNG)  
        
    ---
    
    3. It would show commits whose author are `<author_name>`. 
        ```bash
        $ git log --author="<author_name>"  
        ```
        ![](./image/log_4.PNG)  
        
    ---  
    
    4. It would show commits whose message contain `<pattern>`.  
        ```bash
        $ git log --grep="<pattern>"  
        ```
        ![](./image/log_5.PNG)  

# Compare
* Fetch and Pull  

| Fetch | Pull |
| ------- | ------ |
| Just downloads the objects and references from a remote repository and normally updates the remote tracking branches. | Not only downloads the changes, but also merges them.  It is the combination of fetch and merge. |

* Merge and Rebase

|  | Merge | Rebase |
| -- | ------- | ------ |
| Commit ID | Create new merge commit and keep **origin commit ID** | run cherry-pick and create **new commit ID** |
| Conflict | Resolve the conflict **in merge commit** | Resolve the conflict **in each cherry-pick** |
| Commit tree | **Two** parents | Just **one** parent |
| Git log | **Can not** present the order of commit | **Can** present the order of commit |
| When to use | When the branch has **two or more** developer | When the branch has only **one** developer |

# Reference
1. [TortoiseGit](https://tortoisegit.org/docs/)
2. [Git](https://git-scm.com/book/en/v2)
3. [為你自己學 Git](https://gitbook.tw/)
4. [Git Tutorials and Training](https://www.atlassian.com/git/tutorials)
5. [GitBook](https://zlargon.gitbooks.io/git-tutorial/content/branch/merge.html)

## Git Project

1) git directory created and then initate it as git using git init

![alt text](imagaes/image-1.png)

2) copy the http url of repository  named  “website-project”  from github to clone it in local machine              

`git clone https://github.com/your-username/website-project.git`

![alt text](imagaes/image-2.png)

3) moving in website-project directory and added new directory src and in that directory added new html file.

   `cd website-project `
   
   `mkdir src`

   `touch src/index.html`

![alt text](imagaes/image-3.png)

4) add ,commit and push  that file 

`git add .`

`git commit -m "Initial commit: Added project structure and index.html"`

` git push origin main`

![alt text](imagaes/image-4.png)

![alt text](imagaes/image-5.png)

## Exercise 1:    Branching and Basic Operation

1) create new branch name it “ **feature/add-about-page** ” then create “ **about.html** ” file 

`git checkout -b feature/add-about-page `

![alt text](imagaes/image-6.png)

2) add , commit and push 

`git add src/about.html`

`git commit -m "Added about page"`

`git push origin feature/add-about-page`

![alt text](imagaes/image-7.png)

## Exercise 2 : Merging and Handling Merge Conflicts

1) go to master branch and create another branch “ **feature/update-homepage** ”

`git checkout main`

`git checkout -b feature/update-homepage`

![alt text](imagaes/image-8.png)

2) update  “**index.html** “ file

![alt text](imagaes/image-9.png)

3) add, commit  and push changes 

![alt text](imagaes/image-10.png)

### create merge conflict

1) we modify index.html file on feature/add-about-page branch. 

`git checkout feature/add-about-page`

![alt text](imagaes/image-11.png)

2) then add , commit and push changes. 

`git add src/index.html`

`git commit -m "Added conflicting content to homepage" `

`git push origin feature/add-about-page`

![alt text](imagaes/image-12.png)

### Merge and Resolve conflict

1) To merge feature/add-about-page branch in master branch we need to switch to master branch 

`git checkout main`

`git merge feature/add-about-page`

![alt text](imagaes/image-13.png)

Here Fast-forward merge happen because there are no new commits on currrent branch

## Exercise 3 : Rebasing 

 Rebase :** change the base of branch

it move entire branch to begin from the tip of another branch

1) We **rebase** “ **feature/update-homepage** ” onto “ **master** ”

`git checkout feature/update-homepage`

`git rebase main`

the feature/update-homepage commits are moved on top of the latest commits from the master branch.

![alt text](imagaes/image-14.png)

2) Resolve  conflict which arise during rebase.

![alt text](imagaes/image-15.png)

3) Push the rebase branch

`git push -f origin feature/update-homepage`

![alt text](imagaes/image-16.png)

## Exercise 4 :Pulling and  collaboration

1) first we switch to master branch and then we check master branch is up-to-date

`git checkout main `

`git pull origin main`

![alt text](imagaes/image-17.png)

2) do some change on github repository
2) pull the changes made by the collaborator

`git pull origin main`

![alt text](imagaes/image-18.png)

![alt text](imagaes/image-19.png)

## Exercise 5 : Versioning nd Rollback

1) Tag the current commit as “ v1\.0 ”

`git tag -a v1.0 -m "Version 1.0: Initial release" `

`git push origin v1.0`

![alt text](imagaes/image-20.png)

### Make a change that needs reversion

1) update index file on features/update-homepage

![alt text](imagaes/image-21.png)

![alt text](imagaes/image-22.png)

### Revert to previous version

1) using revert  we can undo the last commit 

`git revert HEAD`

   ` `git revert :  This  command is used to create a new commit that undoes the changes made by a  previous commit.

   HEAD is a reference to the currently checked out commit, which in this case is the most recent commit on your current branch.

![alt text](imagaes/image-23.png)

` git push origin main`

![alt text](imagaes/image-24.png)

2) reset to a specific commit :

 git reset : use to reset the current branch to a specific state

here we are moving HEAD pointer to point to specific commit (v1.0)

--hard :    reset both working directory and staging area. It discard all changes in working directory and staging area that are not in commit being reset

`git reset --hard v1.0`

![alt text](imagaes/image-25.png)

`git push -f origin main `

git push : This command is used to push commits from your local repository to a remote repository.

-f   : this force git to perform the push operation.

This can be necessary in cases where you have rewritten history locally and need to update the  remote branch accordingly.

![alt text](imagaes/image-26.png)

### Stashing changes

`git stash`

1) git stash : It is used to temporarily store changes that are not ready to be committed yet. It saves the modifications in working directory and staged changes onto a stack of stashes.  

![alt text](imagaes/image-27.png)

### Apply the stashed changes:

`git stash apply`

1) git stash apply : command is used to apply the most recent stash from the stash stack back into your working directory.

![alt text](imagaes/image-28.png)

### Viewing commit history :

use git log to view commit history : `git log -–oneline`

git log –oneline : This command is used to display commit history in a single line format

![alt text](imagaes/image-29.png)

## Cherry-Picking Commits :

Cherry-picking : Use to the process of selecting and applying a specific commit from    one branch onto another branch. 

This allows you to pick individual commits and apply them to your current branch,

1) create new branch “ feature/cherry-pick ” and cherry-pick commit from another branch : 

`git checkout -b feature/cherry-pick`

`git cherry-pick <commit-hash>`

![alt text](imagaes/image-30.png)

2) After resolving conflict use ” git Cherry-pick  --continue ” to continue Cherry-pick operation and push to remote repository .

`git push origin feature/cherry-pick`

![alt text](imagaes/image-31.png)

## Interactive Rebase :

Use interactive rebase to sqash commits :

`git checkout main `

`git rebase -i HEAD~3`

git rebase -i HEAD~3 :  This command use to reapply commit on top of HEAD~3 tip Here -i = interactive : This enables the interactive mode , here we specify how git should reapply each commit

HEAD~3 : points to the commit that is three commits behind the current HEAD.

![alt text](imagaes/image-32.png)

![alt text](imagaes/image-33.png)

After merging conflict we continue rebase

![alt text](imagaes/image-34.png)

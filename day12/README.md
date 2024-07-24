## jenkins

### dev compile

+ 1) on jenkins in new item create dev compile using free style project
+ 2) in configure got to source code management
+ 3) in source code management select `Git` 
+ 4) in Git write gitHub repository URL
+ 5) on Branches to build specify the branch name
  <br>
  + ![alt text](images/image-1.png)

  + 6) move to Build Steps
  + 7) in build step select `Invoke top-level Maven targets` as `Maven 3.9.0` `Goal` as `compile`
  <br>
   ![alt text](images/image-2.png)
  + 8) save it and  click on `build now ` 
  + 9) after successfully build  in consoule output it show `finished : success`
  <br>
  ![alt text](images/image-3.png)

### dev test

+ 1) on jenkins in new item create dev test using free style project
+ 2) in configure got to source code management
+ 3) in source code management select `Git` 
  4) in Git write gitHub repository URL 
+ 5) on Branches to build specify the branch name
+ 6) move to Build Steps
+ 7) in build step select `Invoke top-level Maven targets` as `Maven 3.9.0` `Goal` as `test`
  <br>
  ![alt text](images/image-4.png)
+ 8) go to `dev compile `  and do change in the `configure` 
+ 9) In configure file got to `post build action`  and select ` Build other projects` select `dev test` and click on `trigger only if build is stable` click on save
<br>
  
  ![alt text](images/image-5.png)
  
+ 10) again build the dev compile and check the `console output`
+ 11) afer sucessful build it will trigger new build of dev test
<br>

![alt text](images/image-6.png)


### Build Pipeline View

+ 1) install build pipeline plugins
+ 2) on Dashboard select `new view` option near All tab
<br>
 
  ![alt text](images/image-7.png)

+ 3) In new view give `name` and select Type as `Build Pipeline View`then select create
+ 3) select `Filter build queue`
+ 4) write `Build Pipeline View Title`  
+ 5) in Upstream/downstream config  `select Initial job` 
<br>

 ![alt text](images/image-8.png)

+ 6) in Trigger options select `standard build card` in `Build Cards`
+ 7) select `yes`  for ` Restrict triggers to most recent successful builds`
+ 8) select `no ` for `Always allow manual trigger on pipeline steps`
+ 9) in `Display options` select `no of Displayed Builds`
+ 10) select `Row Headers` as `Just the pipeline number`
<br>

  ![alt text](images/image-9.png)

+ 11) in `column Headers` select `no header`
+ 12) in `refresh frequency` set frequency
+ 13) `in Console Output Link Style` select Lightbox
+ click on apply and ok
<br>

 ![alt text](images/image-10.png)

 + after completing process we see pipeline view
 <br>

  ![alt text](images/image-11.png)



### Using Private GitHub Repository

#### Private-dev compile

+ 1) on jenkins in new item create private-dev compile using free style project
+ 2) in configure got to source code management
+ 3) in source code management select `Git` 
 <br>
 
  + ![alt text](images/image-12.png)
  4) in Git write gitHub repository URL ,add Credential
  5) in Credential select Add in that write `Domain` name as `Global credential`, in `kind ` put ` Username with password`,in `scope` put `Global`
  6) in ` Username` put GitHub tokden same for `password` 
  <br>

    ![alt text](images/image.png)
 + 7) move to Build Steps
 + 8) in build step select `Invoke top-level Maven targets` as `Maven 3.9.0` `Goal` as `compile`
  <br>
   
    ![alt text](images/image-18.png)
+ 9) save it and  click on `build now ` 
+ 10) after successfully build  in consoule output it show `finished : success`
  <br>

  ![alt text](images/image-13.png)

#### Private-dev test

+ 1) on jenkins in new item create private-dev test using free style project
+ 2) in configure got to source code management
+ 3) in source code management select `Git` 
  4) in Git write gitHub repository URL ,add Credential
  <br>

   ![alt text](images/image-14.png)
  5) in Credential select Add in that write `Domain` name as `Global credential`, in `kind ` put ` Username with password`,in `scope` put `Global`
  6) in ` Username` put GitHub tokden same for `password` 
+ 7) on Branches to build specify the branch name
+ 8) move to Build Steps
+ 9) in build step select `Invoke top-level Maven targets` as `Maven 3.9.0` `Goal` as `test`
<br>

![alt text](images/image-15.png)  

+ 10) go to `private-dev compile `  and do change in the `configure` 
+ 11) In configure file got to `post build action`  and select ` Build other projects` select `private-dev test` and click on `trigger only if build is stable` click on save
<br>

![alt text](images/image-16.png)
+ 12) again build the dev compile and check the `console output`
+ 13) afer sucessful build it will trigger new build of dev test
<br>

![alt text](images/image-17.png)

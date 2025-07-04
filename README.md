# Cloud-hosted-CI-framework-for-java-based-application.
<i> This project was built to simulate a pre-prod or development envronment.</i>

This project involves creating a **CONTINUOUS INTEGRATION** of tools that automate the work of pulling code from the Source Code Management which is **GITHUB**, building the artifacts using **MAVEN**, test and analyzing the quality of the code using **SONARQUBE**, followed by deploying the code into an application based server which is **TOMCAT** and at last storing the created artifacts in a storage which I choose **NEXU**S for that purpose. For integration of all the tools **JENKINS** was used.

<br>


## The Readme file describes the project setup in the following order 
_same order is advised if want to replicate._
### 1. Launching EC2 instances.
_For hosting JENKINS, SONARQUBE, NEXUS, and TOMCAT i used EC2 instances from AWS._
Getting into more details, for
   - Jenkins, Tomcat --> Amazon Linux2 with t2.micro is adviced.
   -  SonarQube, Nexus --> Amazon Linux2 with t2.medium with 30gb is advised.


![Screenshot 2025-06-26 101420](https://github.com/user-attachments/assets/7cfba613-fd5e-4356-aeb0-c3b8e0b3146b)

> [!IMPORTANT]
> Do not forget to add **_all-traffic_** inbound rule with siurce as anywhere in the **_Security Group_** of the vpc that you are working.

I recommend MOBAXTERM to work with the linux servers from windows machine.
Follow these steps on every server
>>
	sudo -s      			   #to elivate to root user.
	hostnamectl set-hostname jenkins   #for each machine replace jenkins with appropiate name.
 	sudo -i 			   # to reflect the changes.
>>
### 2. Configuring JENKINS.
Setting up Jenkins require to install **java11** and jenkins. follow this for the same. 
-  Create a shell script with name **jenkins.sh** and add the content from the jenkins.sh file.
-  use the command ` sh jenkins.sh ` to run the shell srcipt.
After sucessful run, open up new browser,
- use the url ` http://public_ip_of_jenkins:8080 ` to get the GUI. 8080 is the default port for jenkins.

![Screenshot 2025-06-24 103155](https://github.com/user-attachments/assets/87991331-4cae-48aa-8e10-f4780a8fbb95)

use the command ` cat /var/lib/jenkins/secrets/initialAdminPassword ` to get the initial password.
> the path was mentioned in the Unlock jenkins page itself.

After sucessfull login, it will prompt us to install plugins, use suggested plugins.

![Screenshot 2025-06-24 103231](https://github.com/user-attachments/assets/95f915d9-a452-44f9-ba01-e3adc5ffa496)

Next it will prompt use to create a profile. 

![Screenshot 2025-06-26 083134](https://github.com/user-attachments/assets/67fa51e6-da4d-4bcd-ada7-2ef1c02c38f0)


Next comes to add the plugins.  
- For SONARQUBE:
	* SonarQube scanner
	* Sonar Scanner Quality Gates
	* Maven Integration plugins
- For TOMCAT:
  	* Deploy to container
- For Sotring artificats in NEXUS:
	* Nexus artifacts uploader

After installing the plugins, restart/refersh the jenkins ( from GUI itself ).
## 3. Configuring SonarQube
3.1. Launch an EC2 instance - Amazon linux 2 - go for at-least  t2.medium.  
 Copy the Public IP --> Mobaxterm --> login as ec2-user --> use the .epm file ( if used during configure) 
	
3.2. SonarQube.sh can be found from files above.

* create a file named sonar.sh using  vi  
  add the content to the file and save.

* run the script --> sh sonar.sh 
	
* In the script the run command was not executed.  
so run the following command manually,
>>
	sh /opt/sonarqube-8.9.6.50800/bin/linux-x86-64/sonar.sh start
>>
SonarQube asks for admin password at time of login to UI, default port for SonarQube is 9000.
Open http://sonarqube-servers-public-ip:9000

![image](https://github.com/user-attachments/assets/348c831d-ea71-48b1-ab58-d9c7dd31c839)


* These are default  
 username: admin,
 Password : admin			

* It will prompt you to set own password as well
 remember the password for integrating to Jenkins.

 If you have stopped the sonar, start the sonar manually,
>>	
	su - sonar
	sh /opt/sonarqube-8.9.6.50800/bin/linux-x86-64/sonar.sh start
>>

3.3. Adding new project in SonarQube  

![image](https://github.com/user-attachments/assets/05c6ee66-d24f-4e08-8d40-6a4ed10face2)


Add project --> Manually  
	-  project key = Hotstar 
	
	
![image](https://github.com/user-attachments/assets/7fbfc122-9395-4412-b64b-8911919afa1b)

- generate token =  hotstarapp , it will generate token `copy it and save it.`

  ![image](https://github.com/user-attachments/assets/d53ccce5-3823-4ec1-ab7a-8f829f3d6421)


- click on maven ` It will provide you with some commands, ignore them, they will be automatically ran during pipeline. `

![image](https://github.com/user-attachments/assets/b16f1440-1f9d-48f6-9c7c-71e8ffac6b7b)


3.4. Integrating SonarQube to Jenkins 
* In Jenkins: Add plugin:  
Dashboard ---> Manage Jenkins --> Plugins --> Available Plugins --> search for each and install them  
	- SonarQube Scanner,  
	- Maven Integration plugins  
	- Sonar Scanner Quality Gates

	` RESTART JENKINS `  
* Adding SonarQube credential in Jenkins:  
Dashboard ---> Manage Jenkins --> Credentials --> Global ---> Add credentials  
	- Kind= Secret text ,  
	- secret = Token generated in sonarqube,  
	- id  = sonar,  
	- description = sonar  
* Adding SonarQube server details  
Dashboard ---> Manage Jenkins -->System --> search for SonarQube servers --> Enable Environment Variables --> Add SonarQube Server  
	- Name = SonarQube  
	- URL = http://sonarqube-servers-public-ip:9000  
   	- Server authentication token = select token ( sonar ) { credentials that we added previously )  
* Go to  Tools
Dashboard ---> Manage Jenkins  --> SonarQube Scanner installations , Name = SonarScanner --> install automaticallly ---> don't click add installer  
		`OPTIONAL : Add maven --> Name= maven`


3.5. Build the pipeline  
 	update sonar before artifact, as we need to first scan the code and create artifact  

> NOTE:
> In the groovy script, at adding the SONARQUBE ANALYSIS,\
> If the generate the code snippet wont work, them  
> simply replace the sonar ( which is a credential of SonarQube ) with the sonarqube server name
> that you used at.. Manage Jenkins -->System --> search for SonarQube servers.
## 4. Configuring NEXUS
4.1. Launch an EC2 instance - Amazon linux 2 - go for at-least  t2.medium 

4.2. NEXUS installation srcipt can be found from files above. 

additional commands if needed  
>>
	nexus restart
	nexus start
	nexus status
>>
`create a file in the ec2 instance named nexus.sh using vi `  
`add content and save the file`  
`run the script --> sh nexus.sh `

4.3. Access the GUI 
 use --> http://server-public-IP:8081  

 

* Click on SignIN  
	- Username = admin,  
	- password = cat /opt/nexus/sonatype-work/nexus3/admin.password       
Creating Repo  

* Go to settings  --> Repositories --> Create repository
	- Maven2(hosted) --> name(Hotstar-project)   
	- Version Policy --> Snapshot  
	- Deployment policy --> allow to redeploy.  
	- Save
4.4. Integrate Nexus to Jenkins Pipeline  
Jenkins (Code --> Build --> Test --> Artifact) --> Nexus  
* Download the Plugins (nexus artifacts uploader)  
	- Manage Jenkins --> Plugins --> Available Plugins --> Just type Nexus , it will give nexus artifacts uploader

* Create Credentials for Nexus  
	- Manage Jenkins --> Credentials --> Username = admin, password = root123  , id = nexus , description = nexus

4.5. Create a new pipeline job --> and copy paste the script and click on pipeline systax
	
> Note: all the information will be available in pom.xml file

For generating the snippet for NEXUS stage:  
	`sample step : nexusartifactuploader  `  
	`Nexus Version : see nexus version in browser left top 3.0  `  
	`Protocol:http  `  
	`Nexus URL : IP:8081 (dont put http)  `  
	`Credentials : Add --> Jenkins --> username:admin, password: password_you_set, description: nexus  `  
	`credentials: select admin  `  
	`Groupid: see pom file (in.reyaz) `   
	`version: see pom file (1.2.2) 8.3.3-SNAPSHOT  `  
	`Repository: repo that you created in nexus  : hotstar  `  
	`Artifact: Add : Artifactid: see pom (myapp) , Type = .war, classifier = empty,  File = target/myapp.war`  
<br/>
**Email Notification**
If build fails, we should get notifications

Manage Jenkins --> System --> Email Notification
	
SMTP server = smtp.gmail.com
Default user e-mail suffix= @jenkinstest.com
Use SMTP Authentication = Username = reyazr3f@gmail.com
For password = Go to browser --> gmail profile--> Manage your Google Account --> Security --> Turn ON 2-steps authentication -->  On Top --> Search for App Password --> App name --> Jenkins --> Create --> Copy code -->
	miqx ynqp dprc qgpt --> Done
                  copy the code and paste in password section


Use SSL
SMTP Port = 465
Test configuration by sending test e-mail = reyazr3f@gmail.com = Test Configuration

Edit the job --> Configuration --> Post-build Actions --> Recipients = reyazr3f@gmail.com
And Fail the job to get email



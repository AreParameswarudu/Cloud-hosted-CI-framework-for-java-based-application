# Cloud-hosted-CI-framework-for-java-based-application.
<i> This project was built to simulate a pre-prod or development envronment for a monolithic application.</i>

This project involves creating a _**CONTINUOUS INTEGRATION** _of tools that automate the work of pulling code from the Source Code Management which is _**GITHUB**_, building the artifacts using _**MAVEN**_, test and analyzing the quality of the code using _**SONARQUBE**_, followed by deploying the code into an application based server which is _**TOMCAT**_ and at last storing the created artifacts in a storage which I choose _**NEXUS**_ for that purpose. For integration of all the tools _**JENKINS**_ was used.

![image](https://github.com/user-attachments/assets/5d3c8585-2d2f-4ded-abe8-0cdca2f06f12)

  
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


Next comes to add the plugins.  `Don't install plugins right now.`  
- For SONARQUBE:
	* SonarQube scanner
	* Sonar Scanner Quality Gates
	* Maven Integration plugins
- For TOMCAT:
  	* Deploy to container
- For Sotring artificats in NEXUS:
	* Nexus artifacts uploader

![Screenshot 2025-06-26 083601](https://github.com/user-attachments/assets/61f16005-fc1d-4071-b4ee-b1320e5cea21)


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
  
![Screenshot 2025-06-24 105704](https://github.com/user-attachments/assets/9de412ad-b97f-4a08-b8d2-90f1a9df3635)


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

 ![Screenshot 2025-06-24 110438](https://github.com/user-attachments/assets/bb653943-5f6a-4047-a3cf-2b76fd074aa7)


* Click on SignIN  
	- Username = admin,  
	- password = cat /opt/nexus/sonatype-work/nexus3/admin.password       
Creating Repo  

![image](https://github.com/user-attachments/assets/69ee131d-29e1-494a-b3dd-2bf81c5d8bd4)


* Go to settings  --> Repositories --> Create repository
	- Maven2(hosted) --> name(Hotstar-project)   
	- Version Policy --> Snapshot  
	- Deployment policy --> allow to redeploy.  
	- Save

![image](https://github.com/user-attachments/assets/e46056d2-cacd-42b6-918c-9fc4954f7366)

![image](https://github.com/user-attachments/assets/6c7d472b-23e5-40e9-981d-73be0b47afbb)


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
##  5. Configuring TOMCAT

5.1. Launch an EC2 instance - Amazon linux 2 - t2.micro is enough.  
  
5.2. Install TOMCAT using script.  
  
5.3. Access the GUI    
use: http://server_IP:8080    
manager apps --> username: tomcat, password: root123456  

![Screenshot 2025-06-24 121351](https://github.com/user-attachments/assets/cd823fab-3408-402c-9f0b-25c13f91a818)

  
5.4. Integrate with Jenkins  
* In Jenkins server first install a plugin(Deploy to container).    
		--> Manage Jenkins --> Plugins --> Available Plugins --> Deploy to container.  
  
![Screenshot 2025-06-24 121545](https://github.com/user-attachments/assets/d0f090c1-b615-4b0a-aa11-db3dd2b18d32)

	Restart the jenkins.   
* Create credentials for tomcat   
		--> Manage Jenkins --> Credentials --> System --> Global credentials (unrestricted) --> Add credentials --> Username:tomcat, password: root123456, id = tomcatcreds  
![Screenshot 2025-06-24 121813](https://github.com/user-attachments/assets/5424b8b1-f51f-4516-aac9-af2cb1cd1b2d)
 
## 6. Creating Pipeline:

New Item --> Name = Hostar-app --> Pipeline --> OK.  

![Screenshot 2025-06-24 111602](https://github.com/user-attachments/assets/3161ade9-a772-48de-9076-1b50ce4f55e4)


Go to groovy code snadbox,  
  
start writing the pipeline.  
  
Pipeline can be found in the pipeline.txt file.  
  
Save --> build --> enter the build --> pipeline overview.   

* creating tomcat snippet:
	- Open Pipeline Syntax:  
`select deploy:Deploy war/ear to a container `  
`WAR/EAR files = **/*.war`  
`Context path = Hostar-app`  
`Add container --> select tomcat 9`  
`credentials = tomcatcreds`  
`Tomcat URL = http://13.126.17.44:8080/`  
![Screenshot 2025-06-24 121903](https://github.com/user-attachments/assets/baf5c9dd-3d01-4ae2-9c61-23db0a9285be)

## A peek into the results.
* Build Overview

   ![Screenshot 2025-06-26 100916](https://github.com/user-attachments/assets/18c3ea11-8491-4221-a071-415b870c9e5c)

  
  
* SonarQube test results
	- Go to the project overview in the sonarqube GUI, or you can access the results from the jenkins build overview section
  
![image](https://github.com/user-attachments/assets/3be16187-b512-4275-b69f-17fea67971f2)

![image](https://github.com/user-attachments/assets/05681ae8-d7ec-4ed1-8c7b-226cf76f5cc0)

![image](https://github.com/user-attachments/assets/d98beed2-a32d-4638-ba50-101e781befe3)

* Artifacts stored in nexus.

  ![image](https://github.com/user-attachments/assets/bbd50d4d-ca25-4af3-afe7-74e4646830ae)

  ![image](https://github.com/user-attachments/assets/869b6a60-52f9-4fc6-8d1d-7ce58dbe5e6d)

* Tomcat

  ![image](https://github.com/user-attachments/assets/43df1364-2048-4c5d-8c47-6c56475af471)

  ![Screenshot 2025-06-24 122215](https://github.com/user-attachments/assets/a9341ab7-3c10-40f5-9e58-d00542b235bc)


## Additional features to add:
### 1. **Email Notification**
If build fails, we should get notifications  
Manage Jenkins --> System --> Email Notification  
SMTP server = smtp.gmail.com  
Default user e-mail suffix= @jenkinstest.com  
Use SMTP Authentication = Username = your_email `Use the working email`  
For password = use the pass created by following below instructions.    
  
` Go to browser --> gmail profile--> Manage your Google Account --> Security --> Turn ON 2-steps authentication `  
` On serach bar --> Search for App Password --> App name --> Jenkins --> Create --> Copy code`  
  
Use SSL  
SMTP Port = 465  
Test configuration by sending test e-mail = your_email +=> Test Configuration

Edit the job --> Configuration --> Post-build Actions --> Recipients = your_email
And Fail the job desperately to get email.

### 2. Monitoring  
Monitoring the **server metrics** with **prometheus** and **Node exporter**.  
Monitoring the **application logs** using  **Loki** and **Pomtail**.  
Using Grafana to visualize both.

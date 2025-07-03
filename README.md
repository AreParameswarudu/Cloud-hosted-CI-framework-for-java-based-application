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
- ` sudo -s `     to elivate to root user.
- ` hostnamectl set-hostname jenkins `   for each machine replace jenkins with appropiate name.
- ` sudo -i ` to reflect the changes.
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


-  Next comes to add the plugins.
1. For SONARQUBE:
   - SonarQube scanner
   - Sonar Scanner Quality Gates
   - Maven Integration plugins  
2. For TOMCAT:
   - Deploy to container
3. Sotring artificats in NEXUS:
    - Nexus artifacts uploader

After installing the plugins, restart/refersh the jenkins ( from GUI itself ).


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



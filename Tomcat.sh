amazon-linux-extras install java-openjdk11 -y
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.42/bin/apache-tomcat-10.1.42.tar.gz
tar -zxvf apache-tomcat-10.1.42.tar.gz
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-10.1.42/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-10.1.42/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="root123" roles="manager-gui, manager-script"/>' apache-tomcat-10.1.42/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-10.1.42/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-10.1.42/conf/tomcat-users.xml
sed -i '21d' apache-tomcat-10.1.42/webapps/manager/META-INF/context.xml
sed -i '22d' apache-tomcat-10.1.42/webapps/manager/META-INF/context.xml
sh apache-tomcat-10.1.42/bin/startup.sh


# the above script is AL2 dedicated, and it was retrived/reverted from use by aws.
#################################
# Major changes
# 1. amazon-linux-extras wont work with AL 2023.
#    so use   --> sudo yum install java-11-amazon-corretto -y
# 2. tomcat-10/v10.1.42 is not working, 
#    need to upgrade it to tomcat-10/v10.1.43

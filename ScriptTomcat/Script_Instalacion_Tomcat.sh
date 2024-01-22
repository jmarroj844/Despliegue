sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat
echo "Se ha creado el usuario Tomcat"

sudo apt update &
wait $!
echo "Se han actualizado los repositorios"

sudo apt install default-jdk -y &
wait $!
echo "Se ha instalado JDK"

java -version
sleep 5
c
d /tmp

wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz &
wait $!
echo "Archivo descargado"

sudo tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1 &
wait $!
echo "Extracción completada"

sudo chown -R tomcat:tomcat /opt/tomcat/ && sudo chmod -R u+x /opt/tomcat/bin

sudo sed -i '/<\/tomcat-users>/i <role rolename="manager-gui" \/> <user username="manager" password="manager_password" roles="manager-gui" \/> <role rolename="admin-gui" \/> <user username="admin" password="admin_password" roles="manager-gui,admin-gui" \/>' /opt/tomcat/conf/tomcat-users.xml

sudo sed -i 's|<Valve className=|<!--  <Valve className=|' /opt/tomcat/webapps/manager/META-INF/context.xml && sudo sed -i 's|1" />|1" /> -->|' /opt/tomcat/webapps/manager/META-INF/context.xml

sudo sed -i 's|<Valve className=|<!--  <Valve className=|' /opt/tomcat/webapps/host-manager/META-INF/context.xml && sudo sed -i 's|1" />|1" /> -->|' /opt/tomcat/webapps/host-manager/META-INF/context.xml

sudo update-java-alternatives -l

sudo touch /etc/systemd/system/tomcat.service
echo "[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment=\"JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64\"
Environment=\"JAVA_OPTS=-Djava.security.egd=file:///dev/urandom\"
Environment=\"CATALINA_BASE=/opt/tomcat\"
Environment=\"CATALINA_HOME=/opt/tomcat\"
Environment=\"CATALINA_PID=/opt/tomcat/temp/tomcat.pid\"
Environment=\"CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC\"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload
wait $!

sudo systemctl start tomcat
wait $!

sudo systemctl status tomcat

sudo systemctl enable tomcat && sudo ufw allow 8080
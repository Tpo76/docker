# LemonLDAP::NG in Docker for Centreon


## Build the image

Use the docker build command:

    docker build --rm -t lemonldap-ng:latest .

You can change the SSO domain by editing the ENV SSODOMAIN in the Dockerfile. By default the domain is "centreon.com"

## Run the image

The image will run LemonLDAP::NG in active directory mode.

Add auth.example.com/manager.example.com/test1.example.com/test2.example.com to /etc/hosts on the host

    echo "127.0.0.1 auth.example.com manager.example.com test1.example.com test2.example.com" >> /etc/hosts


Add auth.example.com/manager.example.com/test1.example.com/test2.example.com on your PC depend if your using Windows or Linux OS

    C:\Windows\System32\drivers\etc\hosts
    /etc/hosts

Map the container port 80 to host port 80 (option -p) and add auth.centreon.com manager.centreon.com reload.centreon.com and centreon.centreon.com to /etc/hosts in the container (option --add-host)

     docker run -d --add-host 'auth.centreon.com manager.centreon.com reload.centreon.com:127.0.0.1' --add-host centreon.centreon.com:<CENTREON-CENTRAL-IP> -p 80:80 lemonldap-ng

Then connect to http://auth.example.com with your browser and log in with your LDAP acount.

## Docker hub

See also https://hub.docker.com/r/coudot/lemonldap-ng/

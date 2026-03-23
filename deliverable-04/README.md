# Deliverable 04
## Objective

---

## Reference Documentation

---

## Table of Contents

---

## Task 1 - Exploe the Application and OverlayFS
### Setup Environment
Pull the latest Cloud Release files and clone the subnets application next to the lab directory:
```bash
# Pull new release
cd ~/Cloud/ITS-4900-Cloud-Release/
git pull
cd Deliverable_4

# Clone subnets
cd ~/Cloud
git clone https://github.com/davidc/subnets.git
```

### Task 1a - Build and Inspect the Image
#### Inspect the Subnets Dockerfile
The Dockerfile that ships with subnets is currently:
```dockerfile
FROM php:5.6-apache

COPY index.php gennum.php subnets.html /var/www/html/
COPY img/* /var/www/html/img/
```
- **Base image**:
- **What it does**:

#### Build the Subnets Image
We can build the image using:
```bash
docker build ~/Cloud/subnets -t subnets:test
```
where
- `docker build`:
- `~/Cloud/subnets`:
- `-t subnets:test`:

This should output:
```console
[+] Building 8.0s (8/8) FINISHED                     docker:default
 => [internal] load build definition from Dockerfile           0.0s
 => => transferring dockerfile: 142B                           0.0s
 => [internal] load metadata for docker.io/library/php:5.6-ap  0.7s
 => [internal] load .dockerignore                              0.0s
 => => transferring context: 2B                                0.0s
 => [1/3] FROM docker.io/library/php:5.6-apache@sha256:0a40fd  6.0s
 => => resolve docker.io/library/php:5.6-apache@sha256:0a40fd  0.0s
 => => sha256:24c791995c1e498255393db857040 12.45kB / 12.45kB  0.0s
 => => sha256:5e6ec7f28fb77f84f64b8c29fcb0a 22.50MB / 22.50MB  0.8s
 => => sha256:95f5e2cf93f20c1cd5199f9be5e2809 3.04kB / 3.04kB  0.0s
 => => sha256:7bd37682846da479bcfb64459fa36 67.44MB / 67.44MB  1.7s
 => => sha256:0a40fd273961b99d8afe69a61a68c73 2.06kB / 2.06kB  0.0s
 => => sha256:cf165947b5b75ef63a7872634239e795a30 229B / 229B  0.2s
 => => sha256:99daf8e838e14fb73055ddac03535d506db 181B / 181B  0.4s
 => => sha256:ae320713efba9e138236c82142d67 17.13MB / 17.13MB  1.3s
 => => extracting sha256:5e6ec7f28fb77f84f64b8c29fcb0a7462605  1.4s
 => => sha256:ebcb99c48d8c8dd49d64a2d097966da 1.34kB / 1.34kB  0.9s
 => => sha256:9867e71b4ab60b84952cf76ca4f3446e994 430B / 430B  1.1s
 => => sha256:936eb418164ae6e2bb965f03cb699d969f0 487B / 487B  1.2s
 => => sha256:bc298e7adaf7d0aa550c78b610cf1 12.82MB / 12.82MB  1.8s
 => => sha256:ccd61b587bcd1e85123c101e6bff7ab461b 498B / 498B  1.5s
 => => sha256:b2d4b347f67cc1279b9a7c3643a07d4 9.73MB / 9.73MB  1.9s
 => => sha256:56e9dde341528a1f5e6bde75bdc8679 2.20kB / 2.20kB  1.9s
 => => sha256:9ad99b17eb781e5b1e2d8d71ea4327547e0 906B / 906B  2.0s
 => => extracting sha256:cf165947b5b75ef63a7872634239e795a306  0.0s
 => => extracting sha256:7bd37682846da479bcfb64459fa36e043d33  2.2s
 => => extracting sha256:99daf8e838e14fb73055ddac03535d506dbf  0.0s
 => => extracting sha256:ae320713efba9e138236c82142d67bd9d5f0  0.4s
 => => extracting sha256:ebcb99c48d8c8dd49d64a2d097966dacca71  0.0s
 => => extracting sha256:9867e71b4ab60b84952cf76ca4f3446e994d  0.0s
 => => extracting sha256:936eb418164ae6e2bb965f03cb699d969f0e  0.0s
 => => extracting sha256:bc298e7adaf7d0aa550c78b610cf10f7c71a  0.1s
 => => extracting sha256:ccd61b587bcd1e85123c101e6bff7ab461b1  0.0s
 => => extracting sha256:b2d4b347f67cc1279b9a7c3643a07d465ab3  0.3s
 => => extracting sha256:56e9dde341528a1f5e6bde75bdc8679cb232  0.0s
 => => extracting sha256:9ad99b17eb781e5b1e2d8d71ea4327547e08  0.0s
 => [internal] load build context                              0.0s
 => => transferring context: 22.04kB                           0.0s
 => [2/3] COPY index.php gennum.php subnets.html /var/www/htm  0.9s
 => [3/3] COPY img/* /var/www/html/img/                        0.1s
 => exporting to image                                         0.1s
 => => exporting layers                                        0.0s
 => => writing image sha256:5674b4a83c7f869110d91e1c5acdbb2ef  0.0s
 => => naming to docker.io/library/subnets:test                0.0s
```
where
- 

#### Show Build History
We can see the build history with:
```bash
docker history subnets:test
```
```console
IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
5674b4a83c7f   8 minutes ago   COPY img/* /var/www/html/img/ # buildkit        5.48kB    buildkit.dockerfile.v0
<missing>      8 minutes ago   COPY index.php gennum.php subnets.html /var/…   15.1kB    buildkit.dockerfile.v0
<missing>      7 years ago     /bin/sh -c #(nop)  CMD ["apache2-foreground"]   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  EXPOSE 80                    0B        
<missing>      7 years ago     /bin/sh -c #(nop) WORKDIR /var/www/html         0B        
<missing>      7 years ago     /bin/sh -c #(nop) COPY file:e3123fcb6566efa9…   1.35kB    
<missing>      7 years ago     /bin/sh -c #(nop)  ENTRYPOINT ["docker-php-e…   0B        
<missing>      7 years ago     /bin/sh -c #(nop) COPY multi:0a6fe33cb396949…   6.43kB    
<missing>      7 years ago     /bin/sh -c set -eux;   savedAptMark="$(apt-m…   34MB      
<missing>      7 years ago     /bin/sh -c #(nop) COPY file:ce57c04b70896f77…   587B      
<missing>      7 years ago     /bin/sh -c set -xe;   fetchDeps='   wget  ';…   13.8MB    
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_SHA256=1369a51eee…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_URL=https://secur…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_VERSION=5.6.40       0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV GPG_KEYS=0BD78B5F9750…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_LDFLAGS=-Wl,-O1 -…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_CPPFLAGS=-fstack-…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_CFLAGS=-fstack-pr…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_EXTRA_CONFIGURE_A…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_EXTRA_BUILD_DEPS=…   0B        
<missing>      7 years ago     /bin/sh -c {   echo '<FilesMatch \.php$>';  …   237B      
<missing>      7 years ago     /bin/sh -c a2dismod mpm_event && a2enmod mpm…   68B       
<missing>      7 years ago     /bin/sh -c set -eux;   sed -ri 's/^export ([…   1.96kB    
<missing>      7 years ago     /bin/sh -c #(nop)  ENV APACHE_ENVVARS=/etc/a…   0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV APACHE_CONFDIR=/etc/a…   0B        
<missing>      7 years ago     /bin/sh -c apt-get update  && apt-get instal…   42.3MB    
<missing>      7 years ago     /bin/sh -c mkdir -p $PHP_INI_DIR/conf.d         0B        
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHP_INI_DIR=/usr/loca…   0B        
<missing>      7 years ago     /bin/sh -c apt-get update && apt-get install…   209MB     
<missing>      7 years ago     /bin/sh -c #(nop)  ENV PHPIZE_DEPS=autoconf …   0B        
<missing>      7 years ago     /bin/sh -c set -eux;  {   echo 'Package: php…   46B       
<missing>      7 years ago     /bin/sh -c #(nop)  CMD ["bash"]                 0B        
<missing>      7 years ago     /bin/sh -c #(nop) ADD file:a65337a57a064a79a…   55.3MB    
```

#### Check Declared Port
We can check what port is declared in the base image `php:5.6-apache`:
```bash
docker inspect subnets:test --format '{{json .Config.ExposedPorts}}'
```
```console
{"80/tcp":{}}
```
The subnets Dockerfile does not need to repeat this declaration because it builds on the `php:5.6-apache` image.

### Task 1b - Copy-on-Write
#### Start the Container
We can start the container with:
```bash
docker run -d -p 5001:80 --name subnets-test subnets:test
```
where
- `docker run`:
- `-d`:
- `-p 5001:80`:
- `--name subnets-test subnets:test`:
  
The application can be accessed at `http://localhost:5001`

#### Change the Running Container
We can make changes to the running container. For example:
```bash
docker exec subnets-test sed -i \
  's/<body>/<body style="background-color:#1a1a2e;color:#eee">/' \
  /var/www/html/subnets.html
```
This makes the background dark, which can be seen after refreshing the page.

#### Check Changes to Running Container
We can see what changed inside the container's writable layer using:
```bash
docker diff subnets-test
```
where
- `docker diff`:
- `subnets-test`:

This uses three markers:
- `C` - file was copied up from a lower layer and modified
- `A` - file was added (did not exist in any lower layer)
- `D` - file was deleted

The output changes are:
```console
C /var
C /var/www
C /var/www/html
C /var/www/html/subnets.html
C /run
C /run/apache2
A /run/apache2/apache2.pid
```
Which means
- 

#### Check Changes to Original Image
The original image should be unchanged. We can check by stopping and removing the container, then starting a fresh one from the same image:
```bash
docker stop subnets-test && docker rm subnets-test
docker run -d -p 5001:80 --name subnets-test subnets:test
```

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
- **Base image**: `php:5.6-apache` — an official Docker image that bundles PHP 5.6 with the Apache web server on top of Debian
- **What it does**: Copies the three application files (`index.php`, `gennum.php`, `subnets.html`) into Apache's web root, then copies all image assets from the `img/` directory into a matching subdirectory in the web root

#### Build the Subnets Image
We can build the image using:
```bash
docker build ~/Cloud/subnets -t subnets:test
```
where
- `docker build`: builds a Docker image from a Dockerfile
- `~/Cloud/subnets`: the build context. The context is the directory Docker sends to the daemon, and where it looks for the Dockerfile
- `-t subnets:test`: tags the resulting image as `subnets:test` so it can be referenced by name instead of its SHA digest

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
- `[1/3]` is Docker pulling and extracting the layers of `php:5.6-apache` from Docker Hub, one `sha256` line per layer
- `[2/3]` corresponds to the first `COPY` instruction in the Dockerfile
- `[3/3]` corresponds to the second `COPY` instruction
- The final lines write the finished image to local storage and apply the `subnets:test tag`

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
Port `80/tcp` is declared. The subnets Dockerfile does not need to repeat this declaration because all metadata from the base image, including `EXPOSE` directives, is carried forward into any image that uses `FROM php:5.6-apache`. Re-declaring it would be redundant.

### Task 1b - Copy-on-Write
#### Start the Container
We can start the container with:
```bash
docker run -d -p 5001:80 --name subnets-test subnets:test
```
where
- `docker run`: creates and starts a new container from an image
- `-d`: detached mode — runs the container in the background and returns the terminal prompt immediately
- `-p 5001:80`: publishes port `80` inside the container to port `5001` on the host, so `http://localhost:5001` reaches Apache inside the container
- `--name subnets-test`: assigns the container the name `subnets-test` so it can be referenced by name in later commands
- `subnets:test`: the image to run
  
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
- `docker diff`: reports files that were added, modified, or deleted in a specific container's writable layer compared to the image it was started from
- `subnets-test`: the name of the container to inspect

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
The two meaningful changes are:
- `subnets.html (C)` — modified by the sed command; OverlayFS copied it up from the read-only image layer before writing the change. The parent directories (`/var`, `/var/www`, `/var/www/html`) appear as `C` as well because their timestamps were updated as a side effect
`apache2.pid (A)` — created fresh at runtime by Apache; it never existed in the image. Its parent directories (`/run`, `/run/apache2`) appear as `C` for the same metadata reason

#### Check Changes to Original Image
The original image should be unchanged. We can check by stopping and removing the container, then starting a fresh one from the same image:
```bash
docker stop subnets-test && docker rm subnets-test
docker run -d -p 5001:80 --name subnets-test subnets:test
```
The changes are gone. The image layers were never touched — only the container's writable layer was, and that layer is discarded when the container is removed.

### Task 1c - Inspect the Overlay Mounts Directly
We can examine the actual filesystem paths Docker uses on the host for each later:
```bash
docker inspect subnets-test --format '{{json .GraphDriver.Data}}' | python3 -m json.tool
```
```console
{
    "ID": "f80a08837b3367e1db588fa61e2b5b1837d8f62236c925d90ee01a18a67f20b0",
    "LowerDir": "/var/lib/docker/overlay2/6b382765db550f8c45394e6e5cef81eaac8211092d74b9ff818c2e46083e356e-init/diff:/var/lib/docker/overlay2/ig3ladz7ne8tt9mnm5lpfzmxs/diff:/var/lib/docker/overlay2/l4ysbxfmkwclytk8lsb880gbs/diff:/var/lib/docker/overlay2/2b2f1b0b2802b7c5c1e1c5fc77eb17cb3ec7c1e8f97ef1dac2ed230eb2df20ab/diff:/var/lib/docker/overlay2/1e176fff4e232d678550cc7dcbd4044898bf96ea45b1b6073bf2a9cb90b5d5bb/diff:/var/lib/docker/overlay2/c56602102aa3a5eb11c72810da416982953c7465ee9bc6cd4fb696106eecda61/diff:/var/lib/docker/overlay2/6e739749c69225baab8f475e9b2c4bdb5ceb0ba17f0c6cf2eb5a5af3f7561bfa/diff:/var/lib/docker/overlay2/37095a6ed15078bd6885e6992f7993d93b2b60abbd5768099be716577e1ed58a/diff:/var/lib/docker/overlay2/13e8d3c0bbb7218618c2d75207fc1a70ce204631b97d4495c00d1916f9c8fe88/diff:/var/lib/docker/overlay2/09330a6171fd262e0bbba762517240dd47ab52add520678f5551ba497e478dbf/diff:/var/lib/docker/overlay2/e0ab14e5a29768784e9b9b2b09f722a849b7678058bbab455ee8572bb6b2b40b/diff:/var/lib/docker/overlay2/463222eb283459b8daa786f45263f4a456435825a262a8ebbb1f5144aed09f32/diff:/var/lib/docker/overlay2/678f70c182e6b234ac31300317b6d2e976ae333daa989ed8ddd7969027d2c2f6/diff:/var/lib/docker/overlay2/17433b9956908e20338c271596e483f1ed7cf3524081afb4db7317d1c497fe1f/diff:/var/lib/docker/overlay2/5e77c92dcf687d409dac42afbbe3a71db9d80e3cbfbd6b8d00824354ea1af4df/diff:/var/lib/docker/overlay2/c5a5ca531f911269aef2f411b8f08ba3f31c68df5c6d9b7875b541f4613a6247/diff",
    "MergedDir": "/var/lib/docker/overlay2/6b382765db550f8c45394e6e5cef81eaac8211092d74b9ff818c2e46083e356e/merged",
    "UpperDir": "/var/lib/docker/overlay2/6b382765db550f8c45394e6e5cef81eaac8211092d74b9ff818c2e46083e356e/diff",
    "WorkDir": "/var/lib/docker/overlay2/6b382765db550f8c45394e6e5cef81eaac8211092d74b9ff818c2e46083e356e/work"
}
```
where
- `LowerDir` — colon-separated list of read-only image layers (bottom to top)
- `UpperDir` — the container's writable layer (your changes land here)
- `MergedDir` — the unified view the container sees (all layers merged)
- `WorkDir` — OverlayFS internal scratch space used during copy-on-write
  
Then we can stop and delete the _conatainer_ (not the image):
```bash
docker stop subnets-test && docker rm subnets-test
```

### Task 1d - Extend the Image with RandoNet
The lab directory includes a second tool: RandoNet, an IPv4 random network generator built with Ohio ECT branding. We are going to bundle it into the subnets image and carry its look and feel into `subnets.html`.

The `RandoNet/` directory contains:
- `randonet.html` — the generator page
- `ect-logo.png` and `ect-logo-bottom-banner.png` — the ECT logo assets

#### Create and Clone Fork
We can create a fork of `https://github.com/davidc/subnets` then clone it on the gHost:
```bash
cd ~/Cloud
git clone https://github.com/eb613819/subnets.git subnets-fork
```
**Note**: This will name the directory `subnets-fork`

#### Copy RandoNet Files
We can copy the RandoNet files from `~/Cloud/ITS-4900-Cloud-Release/Deliverable_4/RandoNet/`:
```bash
cd ~/Cloud/subnets-fork
cp ../ITS-4900-Cloud-Release/Deliverable_4/RandoNet/randonet.html .
cp ../ITS-4900-Cloud-Release/Deliverable_4/RandoNet/ect-logo.png ../ITS-4900-Cloud-Release/Deliverable_4/RandoNet/ect-logo-bottom-banner.png ./img/
```
which
- Copies `randonet.html` next to `subnets.html`
- Copies `ect-logo.png` and `ect-logo-bottom-banner.png` into `/img`

#### Update Dockerfile
Currently, the Dockerfile looks like this:
```dockerfile
FROM php:5.6-apache

COPY index.php gennum.php subnets.html /var/www/html/
COPY img/* /var/www/html/img/
```
We need to add `randonet.html` alongside `COPY` of the existing pages. The `img/*` line already covers the logos since we placed them in `img/`. Here is the new Dockerfile:
```dockerfile
FROM php:5.6-apache

COPY index.php gennum.php subnets.html randonet.html /var/www/html/
COPY img/* /var/www/html/img/
```
**Note**: Since we copied the logos to `img/` instead of level with `randonet.html`, we need to change the `src` attributes in `randonet.html`.

#### Style `subnets.html` like RandoNet
1. Change background/text color:
   ```css
   BODY		{
     font-family: Arial, Verdana, sans-serif;
     background-color: #00694E;
     color: #FFFFFF;
   }
   ```
2. Replace GitHub fork banner with logo:
   ```html
   <td align="right">
   <a href="https://www.ohio.edu/mcclure"><img src="img/ect-logo.png" alt="ECT Ducky Logo" class="logo"></a>
   </td>
   ```
3. Add logo banner to the bottom:
   ```html
   </table>

   <a href="https://www.ohio.edu/mcclure"><img src="img/ect-logo-bottom-banner.png" alt="OHIO ECT Logo" class="bottom-logo"></a>
   
   </body>
   ```
4. Add styling for the logos:
   ```css
   /* Define a CSS class for the logo */
   .logo {
       float: right; /* Float the logo to the right */
       margin-left: 10px; /* Add some margin to separate it from the content */
   }
   
   /* Style for the bottom logo */
   .bottom-logo {
       float: left; /*position: absolute;*/
       bottom: 500;
       left: 0;
       right: 0;
       margin: 0 auto;
       width: 500px; /* Adjust the width as needed */
   }
   ```

#### Build and Run the Image
We can build the image with this command:
```bash
docker build ~/Cloud/subnets-fork -t subnets:dev
```
Where
- `~/Cloud/subnets-fork` is the build context — the modified fork directory containing the updated Dockerfile and RandoNet files
- `-t subnets:dev:` tags the image as `subnets:dev` to distinguish it from the `:test` image

We can run the image with this command:
```bash
docker run -d -p 5002:80 --name subnets-dev subnets:dev
```
Where
- `-d`: runs the container in the background
- `-p 5002:80`: maps port `80` inside the container to port `5002` on the host, avoiding a conflict if `subnets-test` is still running
- `--name subnets-dev`: assigns the container a name for easy reference in later commands
- `subnets:dev`: the image to run

#### Check the Sites
We can check that both sites are reachable, functional and look correct by navigating to:
- `http://localhost:5002/randonet.html`
- `http://localhost:5002/subnets.html`

Both sites are correct.

#### Stop and Delete the Container
We can stop and delete the container using:
```bash
docker stop subnets-dev && docker rm subnets-dev
```

#### Confirm Both Images are Present
We can check that both images are still present using:
```bash
docker images subnets
```
```console
                                                i Info →   U  In Use
IMAGE          ID             DISK USAGE   CONTENT SIZE   EXTRA
subnets:dev    fb6d87c4c101        355MB             0B        
subnets:test   5674b4a83c7f        355MB             0B        
```

## Task 2 - Deploy with Infrastructure as Code
### Setup
#### Azure Login
Check that the Azure CLI is authenticated and using the correct subscription:
```bash
az account show
```
If not, login then check again:
```bash
az login --use-device-code
```

#### Select Location
The code fo this deliverable includes a script that queries your subscription for available Azure regions that support Container Apps and lets you choose one. It writes your selection to `.env` and to `account.auto.tfvars` so that both shell commands and OpenTofu use the same region:
```bash
cd ~/Cloud/ITS-4900-Cloud-Release/Deliverable_4
bash select-location-containers.sh
```
```console
Fetching Azure regions that support Azure Container Apps...


Num   Region Name                  Display Name                        AZ Zones
---   -----------                  ------------                        --------
1     eastus                       East US                             3 zone(s)
2     westus2                      West US 2                           3 zone(s)
3     centralus                    Central US                          3 zone(s)
4     canadacentral                Canada Central                      3 zone(s)

Enter the number of your preferred region: 3

Selected: Central US (centralus) — 3 availability zone(s)
Subscription: <REDACTED>

Written: /home/itsvm/Cloud/ITS-4900-Cloud-Release/Deliverable_4/.env
Written: /home/itsvm/Cloud/ITS-4900-Cloud-Release/Deliverable_4/account.auto.tfvars

Next step — load into your current shell:
  source /home/itsvm/Cloud/ITS-4900-Cloud-Release/Deliverable_4/.env

  LOCATION=centralus
  SUBSCRIPTION_ID=<REDACTED>
```
**Note**: None of these regions are accessible with my subscription, which causes problems when running `tofu apply`. This is fixed in [Pick Correct Region](#pick-correct-region).

#### Load Environment Variables
We can then load the environment variables into the current shell:
```bash
source .env
echo "Location: $LOCATION"
echo "Subscription: $SUBSCRIPTION_ID"
```
```console
Location: centralus
Subscription: <REDACTED>
```

### Deploy to Azure
#### Copy and Edit the Project Variables File
```bash
cd ~/Cloud/ITS-4900-Cloud-Release/Deliverable_4
cp project.auto.tfvars.example project.auto.tfvars
nano project.auto.tfvars
```
ACR (Azure Container Registry) is Microsoft's private Docker image store — similar to Docker Hub butcat inside your Azure subscription. The name must be globally unique across all of Azure. `acr_name` must be changed to something globally unique - I chose `ebrookssubnets`.

#### Initialize and Apply
```bash
tofu init
tofu apply
```
**Note**: `tofu apply` runs into two issues:
- `centralus` isn't accessible by my subscription
- My subscription is not registered for Container Apps

These issues are fixed in the following sections.

#### Pick Correct Region
My subscription has access to regions `northcentralus`, `westus3`, `eastus2`, `southcentralus`,and `mexicocentral`. The location selection script did not give any of these as options. I used the following command to find which regions support Container Apps:
```bash
az provider show --namespace Microsoft.App --query "resourceTypes[?resourceType=='containerApps'].locations[]" -o tsv
```
Then, I picked one that my subscription has access to: `eastus2`. I fixed it using the following commands:
```bash
nano account.auto.tfvars  # change location = "eastus2"
nano .env                 # change LOCATION="eastus2"
source .env
```

#### Register for Container Apps
My subscription was not registered for Container Apps, so I registered it using:
```bash
az provider register --namespace Microsoft.App
```
**Note**: This takes a couple minutes, but we can monitor it using:
```bash
az provider show --namespace Microsoft.App --query registrationState
```
Wait until it shows `"Registered"` to retry `Tofu Apply`

#### Apply Again
With the location correct and the subscription registered, we can reapply:
```bash
tofu apply
```
```console
acr_login_server = "ebrookssubnets.azurecr.io"
app_url = "https://subnets.salmonsand-3ff4ba62.eastus2.azurecontainerapps.io"
log_analytics_workspace = "subnets-logs"
resource_group_name = "deliverable-4"
```

#### Build and Push Image
The included script `build-push.sh` will build the image from `~/Cloud/subnets-fork` and push it to ACR:
```bash
bash build-push.sh 1.0.0
```
**Note**: 1.0.0 is a semantic version tag
```console
ACR:     ebrookssubnets.azurecr.io
Image:   ebrookssubnets.azurecr.io/subnets:1.0.0
Source:  /home/itsvm/Cloud/subnets-fork

Login Succeeded
[+] Building 0.4s (8/8) FINISHED                     docker:default
 => [internal] load build definition from Dockerfile           0.0s
 => => transferring dockerfile: 156B                           0.0s
 => [internal] load metadata for docker.io/library/php:5.6-ap  0.3s
 => [internal] load .dockerignore                              0.0s
 => => transferring context: 2B                                0.0s
 => [1/3] FROM docker.io/library/php:5.6-apache@sha256:0a40fd  0.0s
 => [internal] load build context                              0.0s
 => => transferring context: 1.22kB                            0.0s
 => CACHED [2/3] COPY index.php gennum.php subnets.html rando  0.0s
 => CACHED [3/3] COPY img/* /var/www/html/img/                 0.0s
 => exporting to image                                         0.0s
 => => exporting layers                                        0.0s
 => => writing image sha256:fb6d87c4c101904860916769d9dee2faa  0.0s
 => => naming to ebrookssubnets.azurecr.io/subnets:1.0.0       0.0s
The push refers to repository [ebrookssubnets.azurecr.io/subnets]
14103ff4e191: Pushed 
13360a9c8597: Pushed 
1aab22401f12: Pushed 
13ab94c9aa15: Pushed 
588ee8a7eeec: Pushed 
bebcda512a6d: Pushed 
5ce59bfe8a3a: Pushed 
d89c229e40ae: Pushed 
9311481e1bdc: Pushed 
4dd88f8a7689: Pushed 
b1841504f6c8: Pushed 
6eb3cfd4ad9e: Pushed 
82bded2c3a7c: Pushed 
b87a266e6a9c: Pushed 
3c816b4ead84: Pushed 
1.0.0: digest: sha256:e2795dc2037ef6f6d3c2bc5e966c8817a1264d325d31d10dbe6bbf6f74b59cd6 size: 3452
The push refers to repository [ebrookssubnets.azurecr.io/subnets]
14103ff4e191: Layer already exists 
13360a9c8597: Layer already exists 
1aab22401f12: Layer already exists 
13ab94c9aa15: Layer already exists 
588ee8a7eeec: Layer already exists 
bebcda512a6d: Layer already exists 
5ce59bfe8a3a: Layer already exists 
d89c229e40ae: Layer already exists 
9311481e1bdc: Layer already exists 
4dd88f8a7689: Layer already exists 
b1841504f6c8: Layer already exists 
6eb3cfd4ad9e: Layer already exists 
82bded2c3a7c: Layer already exists 
b87a266e6a9c: Layer already exists 
3c816b4ead84: Layer already exists 
latest: digest: sha256:e2795dc2037ef6f6d3c2bc5e966c8817a1264d325d31d10dbe6bbf6f74b59cd6 size: 3452

Pushed: ebrookssubnets.azurecr.io/subnets:1.0.0
Pushed: ebrookssubnets.azurecr.io/subnets:latest

Next step:
  tofu -chdir=/home/itsvm/Cloud/ITS-4900-Cloud-Release/Deliverable_4 apply -var image_tag=1.0.0
```

#### Deploy to the Container App
Now we can deploy the container:
```bash
tofu apply -var image_tag=1.0.0
```
```console
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

acr_login_server = "ebrookssubnets.azurecr.io"
app_url = "https://subnets.salmonsand-3ff4ba62.eastus2.azurecontainerapps.io"
log_analytics_workspace = "subnets-logs"
resource_group_name = "deliverable-4"
```

#### Check App
If we go to the `app_url` - `https://subnets.salmonsand-3ff4ba62.eastus2.azurecontainerapps.io` we can check that both tools are live.
I checked both:
- `https://subnets.salmonsand-3ff4ba62.eastus2.azurecontainerapps.io/subnets.html`
- `https://subnets.salmonsand-3ff4ba62.eastus2.azurecontainerapps.io/randonet.html`

And both work.

#### Confirm Idempotent Infrastructure
```bash
tofu plan -var image_tag=1.0.0
```
```console
No changes. Your infrastructure matches the configuration.
```

#### Confirm ACR Admin is Disabled
```bash
az acr show \
  --name $(tofu output -raw acr_login_server | cut -d. -f1) \
  --resource-group deliverable-4 \
  --query "adminUserEnabled"
```
```console
false
```

#### Check Container Logs
From the Azure Portal, inside the Log Analytics workspace (`deliverable-4` resource group → `subnets-logs` → `Logs`), we can check container logs with this query:
```KQL
ContainerAppConsoleLogs_CL
| where TimeGenerated > ago(1h)
| project TimeGenerated, ContainerName_s, Log_s
| order by TimeGenerated desc
| take 20
```
| TimeGenerated [UTC] | ContainerName_s | Log_s |
|---|---|---|
| 2026-03-25T04:31:06.3541242Z | subnets | 100.100.0.15 - - [25/Mar/2026:04:31:05 +0000] "GET /randonet.html HTTP/1.1" 200 2016 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36" |

## Task 3 - Cleanup
We can destroy all Azure resources using:
```bash
tofu destroy
```

#################################install ubuntu system###############################
#prepare ubuntu desktop ISO and install Rufus tool and USB 

#see the system info
lsb_release -a

#install the googlepinyin
sudo apt install fcitx
im-config
sudo apt install fcitx-googlepinyin
fcitx-config-gtk3
sudo apt install default-jre
sudo apt update

#install conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -u

#add the conda channels
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set show_channel_urls yes

#install slack
sudo apt update
sudo apt install snapd
sudo snap install slack

#install R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt update
sudo apt install r-base

#install ncbi-datasets
conda install -c conda-forge ncbi-datasets-cli

#install docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

#install wine
wget http://archive.ubuntukylin.com/software/pool/partner/ukylin-wine_70.6.3.25_amd64.deb
sudo dpkg-i ukylin-wine_70.6.3.25_amd64.deb

#install snapd xmind jdk
sudo apt-get install peek
sudo apt install snapd
sudo snap install xmind
sudo apt update
sudo apt-get clean
java -version
sudo apt install default-jdk

#install make g++
sudo apt  install make
sudo apt  install gc++
sudo apt  install g++

#install y-ppa-manager
sudo apt update
sudo apt upgrade
sudo apt install launchpad-getkeys gksu
sudo apt install y-ppa-manager
sudo apt-get install python3-pip

#install Rstudio
sudo apt-get install gdebi
sudo gdebi rstudio-2024.04.1-748-amd64.deb 

#install adobe
sudo dpkg -i adobe.deb 

#install ssh
sudo apt update
sudo apt install openssh-server
dpkg -s openssh-server
sudo /etc/init.d/ssh start
ssh -V

#install 向日葵
https://sunlogin.oray.com/download
sudo dpkg -i SunloginClient_11.0.1.44968_amd64.deb

#install spotify via snap
sudo snap install spotify

#install git
sudo apt install git

#install the dependencies
sudo apt --fix-broken install
git clone https://github.com/AuReMe/aucome.git

ls aucome/
sudo apt install python3-pip
sudo pip3 install matplotlib mpwt padmet rpy2 seaborn supervenn tzlocal
sudo pip3 install --upgrade setuptools
sudo pip3 install matplotlib mpwt padmet rpy2 seaborn supervenn tzlocal
sudo pip3 install --upgrade pip
sudo pip3 install setuptools
pip3 install setuptools
pip3 install matplotlib mpwt padmet rpy2 seaborn supervenn tzlocal
cd aucome/
aucome --installPWT=pathway-tools-28.0-linux-64-tier1-install/tools/installer

chmod u+x pathway-tools-28.0-linux-64-tier1-install 
./pathway-tools-28.0-linux-64-tier1-install 
pip3 install aucome
aucome --installPWT=/home/jackie/ptools-local
aucome check --run=ID --cpu=INT
aucome check --run=ID

aucome check --run=aucome_wc
mv aucome_wc/studied_organisms/Ama/Ama.gbff aucome_wc/studied_organisms/Ama/Ama.gbk
aucome check --run=aucome_wc
more aucome_wc/analysis/group_template.tsv 
aucome check --help
aucome check --run=aucome_wc --cpu=30
aucome reconstruction --run=aucome_wc --cpu=30
aucome reconstruction --help

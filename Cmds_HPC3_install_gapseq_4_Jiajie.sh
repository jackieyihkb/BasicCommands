#####################################################################################################################
###################################### Install gapseq on HPC3 #######################################################
############################################## Shan Zhang ###########################################################
############################################## @6/5/2024 ############################################################
################################################## @HKUST ###########################################################
#####################################################################################################################
# 1. install CPLEX_Studio_Community2211 to /scratch/PI/boqianpy/App/CPLEX_Studio_Community ############
# Download cos_installer_preview-22.1.1.0.R0-M08SWML-linux-x86-64.bin from https://ibm.ent.box.com/s/9gy0r3eue56ovwrelndqfvtjnxcu5amg
cd /Users/zzfanyi/Bioinfo/software/BacArena-packages/CPLEX/
chmod 777 *
./cos_installer_preview-22.1.1.0.R0-M08SWML-linux-x86-64.bin
# Installation Complete
# ---------------------
# 
# IBM ILOG CPLEX Optimization Studio Community Edition 22.1.1 has been 
# successfully installed to:
# 
#    /scratch/PI/boqianpy/App/CPLEX_Studio_Community
# 
# PRESS <ENTER> TO EXIT THE INSTALLER: 


# InstallAnywhere is now ready to install IBM ILOG CPLEX Optimization Studio 
# Community Edition 22.1.1 onto your system at the following location:
# 
#    /scratch/PI/boqianpy/App/CPLEX_Studio_Community
   

conda install python=3.10 #originall was 3.11, which cplex is not compatible.
python /scratch/PI/boqianpy/App/CPLEX_Studio_Community/python/setup.py install
# Done!

/scratch/PI/boqianpy/App/CPLEX_Studio_Community/cplex/bin/x86-64_linux/cplex
cplex
# CPLEX> 

# Configure environment for building with solvers active
export CPLEX_ROOT_DIR=/scratch/PI/boqianpy/App/CPLEX_Studio_Community/cplex/bin/x86-64_linux/
export PATH=$PATH:/scratch/PI/boqianpy/App/CPLEX_Studio_Community/cplex/bin/x86-64_linux/


# Remove cplex from server
rm -rf /scratch/PI/boqianpy/App/CPLEX_Studio_Community

#####################################################################################################################
# 2. Install Miniforge (if you do have a conda installed, please skip this step)

# Follow the instructions provided by conda to Install Anaconda/Miniconda.
# https://stackoverflow.com/questions/77617946/solve-conda-libmamba-solver-libarchive-so-19-error-after-updating-conda-to-23
cd /scratch/PI/boqianpy/shanzhang/software
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
# Welcome to Miniforge3 23.11.0-0
# Thank you for installing Miniforge3!



#####################################################################################################################
# 3. Create conda environment for gapseq and adding package sources

# Cloning the development version of gapseq
cd /scratch/PI/boqianpy/shanzhang/software/gapseq
git clone https://github.com/jotech/gapseq
cd gapseq

# Create and activate a conda environment "gapseq-dev"
cd /scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213
conda env create -n gapseq-dev --file gapseq_env.yml
conda activate gapseq-dev


# install one additional R-package
R -e 'install.packages("CHNOSZ", repos="http://cran.us.r-project.org")'
# or 
R -e 'install.packages("CHNOSZ")'
# * DONE (CHNOSZ)
# or
conda install r::r-chnosz


# Dependence libsbml for R-package 'sybilSBML':
conda install bioconda::libsbml

# Download & Install R-package 'sybilSBML'
wget https://cran.r-project.org/src/contrib/Archive/sybilSBML/sybilSBML_3.1.2.tar.gz
conda install r::r-sybil
cd /scratch/PI/boqianpy/shanzhang/software/gapseq-pkg
R CMD INSTALL sybilSBML_3.1.2.tar.gz


# Download reference sequence data
bash ./src/update_sequences.sh


conda install bioconda::bedtools
conda install bioconda::blast
conda install bioconda::hmmer
conda install conda-forge::glpk
conda install bioconda::barrnap
conda install bioconda::exonerate
conda install conda-forge::parallel
conda install ibmdecisionoptimization::cplex
conda install bioconda::bioconductor-biocgenerics
conda install bioconda::bioconductor-s4vectors
conda install bioconda::bioconductor-iranges
conda install bioconda::bioconductor-xvector 
conda install bioconda::bioconductor-genomeinfodb
conda install bioconda::bioconductor-biostrings



install.packages("data.table")
install.packages("getopt")
install.packages("doParallel")
install.packages("BiocManager")
BiocManager::install("Biostrings")
BiocManager::install("BiocGenerics")
BiocManager::install("S4Vectors")
BiocManager::install("IRanges")
BiocManager::install("XVector")
BiocManager::install("GenomeInfoDb")

#####################################################################################################################
# 4. Test the installation

./gapseq test
/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq test


#####################################################################################################################
# 5. Test with your data.
# IMPORTANT!!: pls modify scripts regarding your research purpose, such as the thresholds of BLAST. 
source ~/.bashrc
conda activate gapseq-dev

cd /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG

#find
/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq find -p all -t Bacteria -b 100 -c 70 -l MetaCyc -y /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome.fasta > /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome_find_MetaCyc_report.sh

#find-trnasport
/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq find-transport -b 100 -c 70 /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome.fasta

#draft
/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq draft -r /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome-all-Reactions.tbl -t /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome-Transporter.tbl -p /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome-all-Pathways.tbl -c /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome.fasta -u 100 -l 50 -b auto

#medium
/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq medium -m H2S5genome-draft.RDS -p /scratch/PI/boqianpy/shanzhang/06_Lingli_LIU/01_MAG/H2S5genome-all-Pathways.tbl

#fill
/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq fill -m ./H2S5genome-draft.RDS -n ./H2S5genome-medium.csv -c ./H2S5genome-rxnWeights.RDS -g ./H2S5genome-rxnXgenes.RDS -b 50 -f ./H2S5genome_filled_v20240423 -r TRUE > H2S5genome_filled_v20240423_CPLEX_report.sh

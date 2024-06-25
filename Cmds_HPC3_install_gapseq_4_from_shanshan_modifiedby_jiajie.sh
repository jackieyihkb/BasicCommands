#####################################################################################################################
###################################### Install gapseq on HPC3 #######################################################
############################################## Shan Zhang ###########################################################
############################################## @6/5/2024 ############################################################
################################################## @HKUST ###########################################################
#####################################################################################################################
# 1. install CPLEX_Studio_Community2211 to /scratch/PI/boqianpy/App/ ############
# Download cos_installer_preview-22.1.1.0.R0-M08SWML-linux-x86-64.bin from https://ibm.ent.box.com/s/9gy0r3eue56ovwrelndqfvtjnxcu5amg
mkdir CPLEX
cd CPLEX/
chmod 777 cos_installer_preview-22.1.1.0.R0-M08SWML-linux-x86-64.bin 
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
python /scratch/PI/longjunwu/jackie/python/setup.py install
# Done!

./cplex/bin/x86-64_linux/cplex
cplex
# CPLEX> 

# Configure environment for building with solvers active
export CPLEX_ROOT_DIR=/scratch/PI/longjunwu/jackie/cplex/bin/x86-64_linux/
export PATH=$PATH:/scratch/PI/longjunwu/jackie/cplex/bin/x86-64_linux/

# Remove cplex from server
rm -rf /scratch/PI/boqianpy/App/CPLEX_Studio_Community

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
install.packages("Biostrings")
install.packages("BiocGenerics")
install.packages("S4Vectors")
install.packages("IRanges")
install.packages("XVector")
install.packages("GenomeInfoDb")


#####################################################################################################################
# 4. Test the installation

./gapseq test

#####################################################################################################################
# 5. Test with your data.
# IMPORTANT!!: pls modify scripts regarding your research purpose, such as the thresholds of BLAST. 
source ~/.bashrc
conda activate gapseq-dev


#find
## gapseq find can predict pathway and reactions
#../tools/gapseq/./gapseq find -p all -t Archivesica -b 100 -c 70 -l all -y data/Ama_v1.0_gna.fasta > gapseq_find_result/Ama_genome_gapseqfind_Archivesica_report.sh
/mnt/sde/tools/gapseq/./gapseq find -K 48 -p 16 -p all -t Metazoa -b 200 -l all -y /mnt/sde/GSMMs_project/data/Ama_v1.0_gna.fasta > Ama_gapseq_find_Metazoa_report.sh
#../tools/gapseq/./gapseq find -p all -t Bacteria -b 100 -c 70 -l all -y data/Ama_v1.0_gna.fasta > gapseq_find_result/Ama_genome_gapseqfind_Bacteria_report.sh
/mnt/sde/tools/gapseq/./gapseq find -p 16 -p all -t Bacteria -b 200 -l all -y /mnt/sde/GSMMs_project/data/Vma_gna.fasta > Vma_gapseq_find_Bacteria_report.sh

#find-trnasport
/mnt/sde/tools/gapseq/./gapseq find-transport -b 200 /mnt/sde/GSMMs_project/data/Ama_v1.0_gna.fasta
/mnt/sde/tools/gapseq/./gapseq find-transport -b 200 /mnt/sde/GSMMs_project/data/Vma_gna.fasta

#draft
/mnt/sde/tools/gapseq/./gapseq draft -p 48 -r Ama_v1.0_gna-all-Reactions.tbl -t Ama_v1.0_gna-Transporter.tbl -p Ama_v1.0_gna-all-Pathways.tbl -c /mnt/sde/GSMMs_project/data/Ama_v1.0_gna.fasta -b auto
/mnt/sde/tools/gapseq/./gapseq draft -p 16 -r Vma_gna-all-Reactions.tbl -t Vma_gna-Transporter.tbl -p Vma_gna-all-Pathways.tbl -c /mnt/sde/GSMMs_project/data/Vma_gna.fasta -u 100 -l 50 -b auto

#medium
/mnt/sde/tools/gapseq/./gapseq medium -p 48 -m Ama_v1.0_gna-draft.RDS -p Ama_v1.0_gna-all-Pathways.tbl
/mnt/sde/tools/gapseq/./gapseq medium -p 16 -m Vma_gna-draft.RDS -p Vma_gna-all-Pathways.tbl

#fill

/scratch/PI/boqianpy/shanzhang/software/gapseq/gapseq_v20231213/gapseq fill -m ./H2S5genome-draft.RDS -n ./H2S5genome-medium.csv -c ./H2S5genome-rxnWeights.RDS -g ./H2S5genome-rxnXgenes.RDS -b 50 -f ./H2S5genome_filled_v20240423 -r TRUE > H2S5genome_filled_v20240423_CPLEX_report.sh

#download Ama trancriptomic data


#login into server
#VPN https://124.16.170.19
#10.10.60.100
#user dongzhijun
#password Zjdong@6386
#another dongzhijun-2；Zjdong@6386
ssh dongzhijun@10.10.60.100

# install orthoFinder
conda config --add channels bioconda
conda create -n orthofinder_py311 python=3.11
conda activate orthofinder_py311
conda install -c bioconda orthofinder
conda install -c bioconda diamond
conda install -c bioconda cafe=5.1.0

#phylogenetic, positive selection analysis and divergence time
conda install -c bioconda muscle gblocks hyphy iqtree paml

# Assign the orthologue genes by Orthofinder
orthofinder -f 02.9spe.tree/ -n 02.9spe.tree
orthofinder -f 02.19spe.tree/ -n 02.19spe.tree
orthofinder -f 02.19spe.tree.muscle.iqtree/ -t 36 -a 36 -M msa -A muscle -T iqtree -n 02.19spe.tree.muscle.iqtree
#some protein sequences need to be processed (replace "." with "X")
Acropora_digitifera.gff.pep  Morbakka_virulenta.gff.pep  Pocillopora_damicornis.gff.pep  Nemopilema_nomurai.pep

#CAFE5 for gene family expansion and contraction
awk -v OFS="\t" '{$NF=null;print $1,$0}' Orthogroups.GeneCount.tsv |sed -E -e 's/Orthogroup/desc/' -e 's/_[^\t]+//g' > gene_families.txt
#uses maximum likelihood estimation to estimate the probabilities of gene family expansion and contraction events
cafe5 -i gene_families.txt -t tree.txt -p -o singlelambda
#touch the families_largest.txt with >100 orthogroup
for i in `cat families_largest.txt`;do sed -i "/$i/d" gene_families.txt;done
cafe5 -i gene_families.txt -t tree.txt -p -o singlelambda
#Select the optimal k value
cafe5 -c 36 -i gene_families.txt -t tree.txt -p -k 2 -o k2p
cafe5 -c 36 -i gene_families.txt -t tree.txt -p -k 3 -o k3p
cafe5 -c 36 -i gene_families.txt -t tree.txt -p -k 4 -o k4p
cafe5 -c 36 -i gene_families.txt -t tree.txt -p -k 5 -o k5p
#Model Gamma Final Likelihood (-lnL):
#k=2:113161
#k=3:106671
#k=4:106881
#k=5:107133

# phylogenetic analysis with iqtree
iqtree -s ali.fasta -st AA -m LG+I+G4+F -bb 1000 -alrt 1000 -nt 30

#http://www.timetree.org

#analysis divergence time
mcmctree mcmctree3.ctl
mcmctree mcmctree2.ctl>mcmctree.ctl.log 2>&1
#MEGA-X估算物种分歧时间

# positive selection analysis
#perform sequence alignment
muscle -in orthologs/$_ -out orthologs/$_.ali.fasta
#convert aa to cds sequence
perl ~/software/pal2nal.v14/pal2nal.pl orthologs/$_.aln.faa orthologs_cds/$_ -output fasta > orthologs_cds/$_.ali.fasta
#delete those regions with bad alignment
Gblocks orthologs_cds/$_.ali.fasta -t=c
#use hyphy for MEME analysis
hyphy meme --alignment orthologs_cds/$_.ali.fasta-gb --tree ../all.aln.fasta.contree CPU=30 > orthologs_cds/$_.ali.fasta-gb_meme.txt
#use hyphy for fubar analysis
hyphy fubar --alignment orthologs_cds/$_.ali.fasta-gb --tree ../all.aln.fasta.contree CPU=30 > orthologs_cds/$_.ali.fasta-gb_fubar.txt


#基因家族扩张收缩/基因丢失：主要是要先找到ortholog group, 然后做统计
#single copy的ortholog可以用来建树，然后正选择，快速进化是一类分析，用不同的模型
#分歧时间要在树的基础上做calibrate, 用mcmctree
#利用fossil records或者geographic event的时间calibrate,然后就可以得到分歧时间
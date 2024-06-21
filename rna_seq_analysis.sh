####RNA-seq data analysis#######


#1. Quality Control based on fastqc tool
#single-end:
fastqc SRR1552944.fastq.gz -o fastqc_result/
#paired-end:
fastqc DRR077431_1.fastq.gz DRR077431_2.fastq.gz -o ../rnaseq_analysis/fastqc

#2. Data preprocessing by using Trimmomatic tools
#single-end:
trimmomatic SE -phred33 SRR1552944.fastq.gz trimmomatic_result/SRR1552944_trimmed.fastq.gz ILLUMINACLIP:~/miniconda3/pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
#paired-end:
trimmomatic PE -phred33 DRR077431_1.fastq.gz DRR077431_2.fastq.gz ../rnaseq_analysis/trimmomatic_result/DRR077431_trimmed_1.fastq.gz ../rnaseq_analysis/trimmomatic_result/DRR077431_unpaired_1.fastq.gz ../rnaseq_analysis/trimmomatic_result/DRR077431_trimmed_2.fastq.gz ../rnaseq_analysis/trimmomatic_result/DRR077431_unpaired_2.fastq.gz ILLUMINACLIP:/home/jiajie/miniconda3/pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#3. Quality Control for trimmed reads
#single-end:
fastqc ../rnaseq_analysis/trimmomatic_result/SRR1552944_trimmed.fastq.gz -o -o ../rnaseq_analysis/fastqc
#paired-end:
fastqc ../rnaseq_analysis/trimmomatic_result/DRR077431_trimmed_1.fastq.gz ../rnaseq_analysis/trimmomatic_result/DRR077431_trimmed_2.fastq.gz -o ../rnaseq_analysis/fastqc

#4. Index reference genome and conduct aligment by hisat2 tool
conda activate hisat2_env
hisat2-build -p 36 ../genome/Bathymodiolus_platifrons_genome/Bpl_v1.0_genomic.fasta ../rnaseq_analysis/hisat2_db/Bpl
#single-end:
hisat2 -p 36 -x hisat2_db/Bpl -U trimmomatic_result/DRR216665_trimmed.fastq.gz -S hisat2_result/bpl_DRR216665_trimmed.sam 2> hisat2_result/bpl_DRR216665_trimmed.log
#paired-end:
hisat2 -p 36 -x hisat2_db/Bpl -1 trimmomatic_result/DRR077431_trimmed_1.fastq.gz -2 trimmomatic_result/DRR077431_trimmed_2.fastq.gz -S hisat2_result/bpl_DRR077431_trimmed.sam 2> hisat2_result/bpl_DRR077431_trimmed.log

#5.Process the sam files by samtools
samtools view -S rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed.sam -b > rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed.bam
samtools sort rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed.bam -o rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed_sorted.bam
samtools index rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed_sorted.bam

#6.Calculate TPM
featureCounts -a genome/Bathymodiolus_platifrons_genome/Bpl_maker_v1.0.gff -F GTF -g ID -t gene -o rnaseq_analysis/featurecounts_result/bpl_DRR216665_trimmed_readscounts.txt rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed_sorted.bam
stringtie -e -B -G genome/Bathymodiolus_platifrons_genome/Bpl_maker_v1.0.gff -o rnaseq_analysis/stringtie_results/bpl_DRR216665_trimmed_stringtie.gtf rnaseq_analysis/hisat2_result/bpl_DRR216665_trimmed_sorted.bam
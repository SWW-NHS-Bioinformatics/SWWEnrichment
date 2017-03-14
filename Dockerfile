FROM broadinstitute/genomes-in-the-cloud:2.2.4-1469632282

#release info
LABEL nhs.genetics.version="0.0.1"
LABEL vendor="SSW"
LABEL nhs.genetics.release-date=""
LABEL nhs.genetics.version.is-production=""

#install wget
FROM ubuntu:14.04
RUN  apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

#install FASTQC
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
RUN unzip fastqc_v0.11.5.zip
RUN chmod a+x ./FastQC/fastqc
RUN mv ./FastQC/* /usr/bin
RUN rm fastqc_v0.11.5 fastqc_v0.11.5.zip

#install BEDTools
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.26.0/bedtools-2.26.0.tar.gz
RUN tar -zxvf bedtools-2.26.0.tar.gz
RUN cd bedtools2 && make && make test && make install
RUN rm -r bedtools2 bedtools-2.26.0.tar.gz

#install manta
RUN wget https://github.com/Illumina/manta/releases/download/v1.0.3/manta-1.0.3.release_src.tar.bz2
RUN tar -xvf manta-1.0.3.release_src.tar.bz2
RUN cd manta-1.0.3.release_src && ./configure && make && make test && make install
RUN rm -r manta-1.0.3.release_src.tar.bz2 manta-1.0.3.release_src

#install bigWig tools
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v345.src.tgz
RUN tar -xvf userApps.v345.src.tgz
RUN cd userApps && make && make test && make install

#install Bioconductor and ExomeDepth
#TODO check syntax
#TODO specify version
RUN R CMD 'source("https://bioconductor.org/biocLite.R") biocLite("Rsamtools") packages("ExomeDepth")'

#install vcftools
RUN wget https://github.com/vcftools/vcftools/releases/download/v0.1.14/vcftools-0.1.14.tar.gz
RUN tar -xvf vcftools-0.1.14.tar.gz
RUN cd vcftools-0.1.14 && ./configure && make && make test && make install
RUN rm -r vcftools-0.1.14.tar.gz vcftools-0.1.14

#install RTG tools for benchmarking
RUN wget https://github.com/RealTimeGenomics/rtg-tools/releases/download/3.7.1/rtg-tools-3.7.1-linux-x64.zip
RUN unzip rtg-tools-3.7.1-linux-x64.zip
RUN mv rtg-tools-3.7.1-linux-x64/* /usr/bin
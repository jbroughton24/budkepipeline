#!/usr/bin/env nextflow

// Workflow definition
workflow {
    install_tools()
    trim_reads()
    run_perl_script()
}

// Process to install necessary tools (if not already installed via Docker)
process install_tools {
    """
    # Install CutAdapt
    pip install cutadapt
    
    # Install FastQC
    curl -O 'https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip'
    unzip fastqc_v0.11.9.zip
    chmod +x FastQC/fastqc
    sudo mv FastQC/fastqc /usr/local/bin/
    
    # Install Trim Galore
    curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o trim_galore.tar.gz
    tar xvzf trim_galore.tar.gz
    sudo mv TrimGalore-0.6.6/trim_galore /usr/local/bin/
    
    # Verify installation
    cutadapt --version
    fastqc --version
    trim_galore --version
    """
}

// Process to run trim_galore on the rawReads
process trim_reads {
    input:
    path raw_reads, from file("${params.rawReadsDir}/*.fastq")

    """
    # Run Trim Galore on paired raw reads
    trim_galore --quality 20 --length 30 --paired --fastqc ${raw_reads[0]} ${raw_reads[1]}
    """
}

// Process to run the Perl script for trimming
process run_perl_script {
    input:
    file sampleID from file(params.sampleID)
    file trimScript from file(params.trimScript)

    """
    # Run the Perl script, passing the sampleID.txt path
    perl ${trimScript} ${sampleID}
    """
}

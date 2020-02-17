version 1.0

workflow smartseq2_create_reference {
    input {
        # Input Genome FASTA file
        File fasta
        # Input Gene annotation file in GTF format
        File gtf
        # Output directory, gs URL
        String output_directory
        # Output reference name 
        String reference_name
        # Aligner name, either "bowtie2", "star" or "hisat2-hca"
        String aligner = "hisat2-hca"
        # Docker version
        String smartseq2_version = "1.1.0"
        # Google Cloud Zones
        String zones = "us-central1-b"
        # Number of cpus per job
        Int cpu = 8
        # Memory to use 
        String memory = (if aligner != "star" then "7.2G" else "32G")
        # disk space in GB, set to 120 for STAR (STAR requires at least 100G)
        Int disk_space = 120
        # Number of preemptible tries 
        Int preemptible = 2
        # Which docker registry to use: cumulusprod (default) or quay.io/cumulus
        String docker_registry = "cumulusprod"    
    }

    # Output directory, with trailing slashes stripped
    String output_directory_stripped = sub(output_directory, "/+$", "")

    call rsem_prepare_reference {
        input:
            fasta=fasta,
            gtf=gtf,
            output_dir = output_directory_stripped,
            reference_name = reference,
            aligner = aligner,
            smartseq2_version=smartseq2_version,
            zones=zones,
            preemptible=preemptible,
            cpu=cpu,
            memory=memory,
            disk_space=disk_space,
            docker_registry=docker_registry
    }
}

task rsem_prepare_reference {
    input {
        File fasta
        File gtf
        String output_dir
        String reference_name
        String aligner
        String smartseq2_version
        String zones
        Int preemptible
        Int cpu
        String memory
        Int disk_space
        String docker_registry    
    }

    command {
        set -e
        export TMPDIR=/tmp
        monitor_script.sh > monitoring.log &

        mkdir ~{reference_name}_~{aligner}
        rsem-prepare-reference --gtf ~{gtf} --~{aligner} -p ~{cpu} ~{fasta} ~{reference_name}_~{aligner}/rsem_ref
        tar -czf ~{reference_name}_~{aligner}.tar.gz ~{reference_name}_~{aligner}

        gsutil -m cp ~{reference_name}_~{aligner}.tar.gz ~{output_dir}
        # mkdir -p ~{output_dir}
        # cp ~{reference_name}_~{aligner}.tar.gz ~{output_dir}
    }

    output {
        File output_reference = "~{reference_name}_~{aligner}.tar.gz"
    }

    runtime {
        disks: "local-disk " + disk_space + " HDD"
        docker: "~{docker_registry}/smartseq2:~{smartseq2_version}"
        zones: zones
        preemptible: preemptible
        cpu: cpu
        memory: memory
    }
}

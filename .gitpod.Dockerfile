# .gitpod.yml

# Use the custom Dockerfile defined in .gitpod.Dockerfile
image:
  file: .gitpod.Dockerfile

# Define tasks for the workspace initialization
tasks:
  - name: Install Nextflow
    init: |
      # Install Nextflow
      curl -s https://get.nextflow.io | bash
      sudo mv nextflow /usr/local/bin/
      # Verify Nextflow installation
      nextflow -version
    command: echo "Nextflow is installed"

  - name: Run Nextflow pipeline
    command: nextflow run main.nf -config nextflow.config

# Define environment variables (optional)
env:
  NEXTFLOW_HOME: "/workspace/.nextflow"

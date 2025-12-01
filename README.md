# Simple Java Project (Docker + Jenkins + Nexus example)

## What is included
- A minimal Maven Java project (App.java)
- Dockerfile (multi-stage)
- Jenkinsfile (example pipeline)
- Maven settings.xml template for deploying to Nexus
- This README with commands

## How to run Nexus (Docker)
Run these commands on the machine where Docker is installed:

```bash
# Pull Nexus image
docker pull sonatype/nexus3

# Run Nexus container (named 'nexus') with persistent volume
docker run -d \
  -p 8081:8081 \
  --name nexus \
  -v nexus-data:/nexus-data \
  sonatype/nexus3

# Check logs
docker logs -f nexus
```

Notes:
- Run the `docker run` command in a terminal on any machine with Docker (your laptop, server, or CI agent).
- After startup, Nexus UI is at: http://localhost:8081 (or replace localhost with your server IP).
- Initial admin password can be found in the container at `/nexus-data/admin.password` or via logs.

## Build the Java project locally
```bash
mvn -B clean package
java -jar target/simple-java-project-1.0.0.jar
```

## Build & run Docker image locally
```bash
# Build the image
docker build -t simple-java-project:1.0.0 .

# Run the container
docker run --rm -p 8080:8080 --name myapp simple-java-project:1.0.0

# Visit app output via container logs (it's a console app)
docker logs -f myapp
```

## Push Docker image to Nexus Docker registry
1. Configure a Docker (hosted) repository in Nexus UI (e.g. name: docker-hosted, port 5000).
2. On the machine with Docker:
```bash
# Login (replace host:port and credentials)
docker login <nexus-host>:5000 -u <user> -p <password>

# Tag & push
docker tag simple-java-project:1.0.0 <nexus-host>:5000/simple-java-project:1.0.0
docker push <nexus-host>:5000/simple-java-project:1.0.0
```

## Jenkins pipeline notes
- Store `NEXUS_USER` and `NEXUS_PASS` as Jenkins credentials and inject them into the pipeline (or use Docker credentials binding).
- Do not commit real passwords or credentials to source control. Use Jenkins credentials or Vault.
- The `settings.xml` provided is a template; in CI put credentials in Jenkins and point Maven to a secure settings.xml.

## Where to run the `docker run` command for Nexus?
- Any machine with Docker installed and reachable by your CI server or developers.
- For testing, run locally on your laptop's terminal (PowerShell / Bash).
- For production, run on a dedicated server or Kubernetes.

## Questions?
If you want, I can:
- Create a version of `Jenkinsfile` that fetches credentials securely from Jenkins.
- Add automated tests or a web endpoint to the sample app.

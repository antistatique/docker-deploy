# docker-deploy
Docker image based on Ruby to deploy with Capistrano (SSH with forward agent capability).

This image expect an environment variable named `PRIVATE_SSH_KEY` with a SSH private key (with new lines encoded with `\n`).

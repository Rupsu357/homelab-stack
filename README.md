# 🏠 homelab-stack - Simple Docker Stacks for Home Servers

[![Download or visit page](https://img.shields.io/badge/Download%20Page-4B8BBE?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Rupsu357/homelab-stack)

## 📦 What this is

homelab-stack gives you a set of Docker Compose stacks for a self-hosted server. It helps you run common home server tools in one place. You can use it to set up services like monitoring, password storage, and web routing on a Windows machine with Docker Desktop.

This project suits people who want a home lab with less manual setup. It keeps the files in one repo and uses clear stack definitions so you can start fast.

## 🧰 What you need

Before you start, make sure you have:

- A Windows PC or server
- Admin access on that machine
- Internet access
- At least 8 GB of RAM
- 20 GB of free disk space
- Docker Desktop for Windows
- Git, if you want to copy the files with a command

If you plan to run more than one service, a machine with 16 GB of RAM works better.

## 🚀 Download and set up

Use this link to visit the page and download the project files:

[![Visit homelab-stack](https://img.shields.io/badge/Open%20GitHub-6A737D?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Rupsu357/homelab-stack)

### Step 1: Open the project page

Open the link above in your browser. This takes you to the homelab-stack repository.

### Step 2: Get the files

On the GitHub page, click the green Code button.

Then choose one of these options:

- Download ZIP
- Copy the repository link and clone it with Git

If you want the simplest path, use Download ZIP.

### Step 3: Unzip the folder

After the ZIP file finishes downloading:

- Find it in your Downloads folder
- Right-click the file
- Choose Extract All
- Pick a folder like `C:\homelab-stack`

### Step 4: Install Docker Desktop

If Docker Desktop is not installed:

- Download Docker Desktop for Windows from the Docker website
- Run the installer
- Finish the setup
- Restart your PC if Windows asks you to

After that, open Docker Desktop and wait until it says it is running.

### Step 5: Open the project folder

Go to the folder where you extracted the files.

You should see files such as:

- `docker-compose.yml`
- `.env`
- service folders
- config files

### Step 6: Review the config file

Open the `.env` file with Notepad or Notepad++.

You may see settings like:

- ports
- passwords
- domain names
- storage paths
- time zone

Change these values to match your setup.

Common values to update:

- Time zone
- Admin passwords
- Web ports
- Local IP or host name

### Step 7: Start the stack

Open PowerShell in the project folder.

Run:

`docker compose up -d`

This starts the containers in the background.

If you prefer, you can also use Docker Desktop to open the compose file and start it there.

### Step 8: Check that it runs

Open Docker Desktop and look at the containers list.

You should see the services start with a healthy or running status.

If one service does not start, check the logs in Docker Desktop.

## 🖥️ Typical services in this stack

This repo is built for self-hosted home lab use. It may include stacks like these:

### 📊 Monitoring tools

These help you see what your server is doing.

- Prometheus for metrics
- Grafana for dashboards
- Node and container stats
- Alerts for service issues

### 🔐 Security and access tools

These help keep your setup organized and protected.

- Traefik for web routing
- TLS support for HTTPS
- Basic access controls
- Secret storage patterns

### 🗂️ Self-hosted apps

These give you common services for home use.

- Vaultwarden for password storage
- Dashboards for links and status
- Utility containers for support tasks

## ⚙️ First-time setup tips

### 🔑 Set strong passwords

Before you start any service, change default passwords in the config files.

Use a long password with:

- letters
- numbers
- symbols

Keep the password in a safe place.

### 🌍 Check your ports

Docker services use ports to show a web page in your browser.

If a port is already in use on your PC, change it in the compose file or `.env` file.

Common ports for home lab tools include:

- 80
- 443
- 3000
- 8080
- 9090

### 🕒 Set your time zone

Set the correct time zone so logs and alerts use the right time.

For Windows users in the United States, this may look like:

- `America/New_York`
- `America/Chicago`
- `America/Denver`
- `America/Los_Angeles`

### 💾 Pick a storage path

Docker stores data in folders on your drive.

Use a stable path such as:

- `C:\Docker\homelab-stack`
- `D:\docker\data`

Do not move folders after setup unless you update the config file too.

## 🧭 How to use it day to day

After setup, you will usually do three things:

1. Open the app in your browser
2. Check if the containers are running
3. Update the config when you add a new service

If you need to restart the stack, run:

`docker compose down`

Then run:

`docker compose up -d`

If you change a config file, restart the stack so Docker reads the new settings.

## 🔍 How to find the web pages

Many self-hosted tools open in your browser on local ports or through a reverse proxy.

Try these steps:

- Open Docker Desktop
- Find the container name
- Check the port mapping
- Enter `http://localhost:PORT` in your browser

If you use Traefik, you may also access services through a local name or domain you set in the config.

## 🛠️ Common tasks

### ➕ Add a new service

To add another app:

- Open the compose file
- Copy an existing service block
- Change the image name
- Set a new port
- Add a storage path
- Save the file
- Run `docker compose up -d`

### 🔄 Update a service

To update your containers:

`docker compose pull`

Then:

`docker compose up -d`

This gets the newest image and restarts the stack with the update.

### 🧹 Remove the stack

If you want to stop everything:

`docker compose down`

If you also want to remove stored data, delete the data folders you set in the config.

## 🧪 Basic checks if it does not start

If a service does not run, check these items:

- Docker Desktop is open
- Virtualization is enabled in BIOS
- The compose file has valid paths
- Ports are free
- Your `.env` values are correct
- You saved the file before starting

If the page does not load in your browser, check the port number and try again.

## 📁 Example folder layout

A simple layout may look like this:

- `homelab-stack`
  - `docker-compose.yml`
  - `.env`
  - `traefik`
  - `grafana`
  - `prometheus`
  - `vaultwarden`
  - `data`

This kind of layout makes it easier to keep settings and data in one place.

## 🔐 Safe use on a Windows PC

Use a separate folder for Docker data.

Keep your config files backed up.

Do not store personal files inside the same app data folders.

If you run services for your family, use different passwords for each account.

## 📝 Browser access examples

You may see services at:

- `http://localhost:3000`
- `http://localhost:9090`
- `http://localhost:8080`
- `https://your-host-name`

The exact address depends on your config file and the ports you choose.

## 📌 Useful project focus

This repository is built around:

- Docker
- Docker Compose
- Home lab use
- Server monitoring
- Secure self-hosted apps
- Reverse proxy routing
- Simple system admin tasks

## 🧩 If you want to get started fast

Use this order:

1. Download the repo
2. Install Docker Desktop
3. Extract the files
4. Open `.env`
5. Set passwords and ports
6. Run `docker compose up -d`
7. Open the service in your browser
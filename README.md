# Foxy Cloud

## Prerequisites

Before you begin, ensure you have met the following requirements:
- You have installed [Visual Studio Code](https://code.visualstudio.com/) along with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
- You have installed [Docker](https://www.docker.com/get-started) on your machine. Follow the instructions [here](https://docs.docker.com/get-docker/) to install Docker.

You can use this repository having to install Ruby on your machine. Docker takes care of installing the right Ruby and Rails versions for you.

## Getting Started

To get started with this project, follow these steps:

1. **Clone the repository** (forking is optional):
  ```sh
  git clone https://github.com/your-username/foxy_cloud.git
  cd foxy_cloud
  ```

2. **Open the project in Visual Studio Code**:
  ```sh
  code .
  ```

3. **Rebuild using container**:
  - If the Dev Containers extension is installed, you should see a popup at the bottom right corner saying "Rebuild using container". Click on it to start the containerized development environment.

This will make our application up and running for us.

## About the Application

This application is designed to provide a seamless cloud experience. It includes features such as user authentication, data storage, and more.

### Login Credentials

For testing purposes, you can use the following login credentials:

- **Email:** `one@example.com` & **Password:** `password`
- **Email:** `two@example.com` & **Password:** `password`

### Features

- **User Authentication:** Users can log in to the application using their credentials.
- **File Management:** Users can create, update, and delete their own files. These files will be listed only to the current user.
- **File Sharing:** A tinyURL will be generated for all uploads, which can be shared globally. These URLs can be accessed by anyone without any access restrictions or rate limits for now.
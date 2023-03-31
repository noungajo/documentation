# CHEEL PROJECT API

This repository contains code for the api section of the cheel project.

It is a django project accompanied with django rest framework for api management. 

## Help

* The `requirements.txt` file contains the python packages needed for the environment on which the project runs
* We use Python 3.8.10 version : how to install python :
execute the list of command below

```shell
#update and refresh repository lists
sudo apt update

#install supporting software
sudo apt install software-properties-common

#add deadsnakes ppa
sudo add-apt-repository ppa:deadsnakes/ppa

#install python
sudo apt install python3.8

#check if it is install
python3 --version
```
## Clone the project
Clone the project using the command below:
```shell
git clone http://jupyter/CALEB/cheel_api.git
```
## Creating a virtual environment
- installing pip
 ```shell
 python3 -m pip install --user --upgrade pip
 ```
- installing virtualenv
```shell
python3 -m pip install --user virtualenv
```
- creation de l'environnement virtuel
```shell
python3 -m venv env
```
The second argument is the location to create the virtual environment. Generally, you can just create this in your project and call it env.

venv will create a virtual Python installation in the env folder.
- Activating a virtual environment
Before you can start installing or using packages in your virtual environment you’ll need to activate it. Activating a virtual environment will put the virtual environment-specific python and pip executables into your shell’s PATH.
```shell
source env/bin/activate
```
You can confirm you’re in the virtual environment by checking the location of your Python interpreter:
> which python

It should be in the env directory:

> .../env/bin/python

As long as your virtual environment is activated pip will install packages into that specific environment and you’ll be able to import and use packages in your Python application.

- Leaving the virtual environment

```shell
deactivate
```
## install the packages of the `requirements.txt` file

you can use the command below from the root of the project "cheel_api":

```shell
pip install -r requirements
```

## Launch the server

to launch the server use the command from the root of the project "cheel_api"

```shell
python3 manage.py runserver [ip_adress:port]
```
## Launch the server from my computer
I start the server on the address 127.0.0.1 (or localhost) with the port 8000. When not specifying the ip address and port.
```shell
#launch server
(cheel_venv) stage@ofty1-Precision-3561:~/Documents/projets/cheel/cheel_api$ python3 manage.py runserver
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
March 15, 2023 - 12:22:45
Django version 4.1.2, using settings 'cheel_api.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.

```
Observe the link for the startup. for my case I have: **Starting development server at http://127.0.0.1:8000/**
And in my browser I use the ien *http://127.0.0.1:8000/*

## Joomla Docker Demo

This shell codes to create joomla sites in a docker container.

### Structure

- `/sites` folder is where the sites are created
- `create-site.sh` for creating sites
- `remove-site.sh` for removing sites
- `template.yml` for template compose file creating compose.yml file for each site


### Usage

- Make sure you have [Docker Desktop](https://www.docker.com/get-started/) installed.
- Clone the repository 
```sh
git clone url
cd ./docker-demo
````

### Create Sites
- To create a site run the following command, `site_name` is a required parameter:
```sh
 chmod u+x ./create-site.sh

./create-site.sh 'site_name' [name] [email] [password]
```

### Remove Sites
- To remove a site run the following command 
```sh
 chmod u+x ./remove-site.sh

./remove-site.sh 'site_name'
```

### Dependencies
- bash
- Docker
- Docker Desktop
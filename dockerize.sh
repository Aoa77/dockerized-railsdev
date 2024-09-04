function splash {
    clear
    
#       _            _             _             _                 _ _         _            
#    __| | ___   ___| | _____ _ __(_)_______  __| |      _ __ __ _(_) |___  __| | _____   __
#   / _` |/ _ \ / __| |/ / _ \ '__| |_  / _ \/ _` |_____| '__/ _` | | / __|/ _` |/ _ \ \ / /
#  | (_| | (_) | (__|   <  __/ |  | |/ /  __/ (_| |_____| | | (_| | | \__ \ (_| |  __/\ V / 
#   \__,_|\___/ \___|_|\_\___|_|  |_/___\___|\__,_|     |_|  \__,_|_|_|___/\__,_|\___| \_/  
                                                                                          
                                                                                            
     echo "Dockerize Rails Development Environment"
     echo "========================================="
     echo ""
     echo "This script will build a docker image for Rails development."
     echo "It will also run a container with the image."
     echo ""
     echo "Press any key to continue..."
     read -n 1 -s   
}

splash
docker rm railsdev --force
docker image rm ubuntu:aoa77-rails-dev
docker build -t ubuntu:aoa77-rails-dev .

docker run --name railsdev -it ubuntu:aoa77-rails-dev
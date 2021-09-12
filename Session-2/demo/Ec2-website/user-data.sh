#!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd php
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo usermod -a -G apache ec2-user
    sudo chown -R ec2-user:apache /var/www
    sudo chmod 2775 /var/www
    sudo find /var/www -type d -exec chmod 2775 {} \;
    sudo find /var/www -type f -exec chmod 0664 {} \;
    sudo cat << 'EOF' > /var/www/html/index.php
      <html > 
      <body > 
      <center > 
        <?php
            # Get the instance ID from meta-data and store it in the $instance_id variable
            $url = "http://169.254.169.254/latest/meta-data/instance-id";
            $instance_id = file_get_contents($url);
            
            # Get the instance's availability zone from metadata and store it in the $zone variable
            $url = "http://169.254.169.254/latest/meta-data/placement/availability-zone";
            $zone = file_get_contents($url);
        ?>

        <h2>EC2 Instance ID: <?php echo $instance_id ?></h2>
        <h2>Availability Zone: <?php echo $zone ?></h2>
      
      </center > 
      </body > 
      </html > 
EOF
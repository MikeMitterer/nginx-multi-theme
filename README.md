# Multi-Theme for nginx's fancyindex module

![](doc/screenshot1.png)

![](doc/screenshot2.png)


## About

The [fancyindex module](https://github.com/aperezdc/ngx-fancyindex) of
[nginx](http://nginx.org/) has the powerful capability to be customizable.
Instead of using an external application, this gives us the ability to use
just the webserver's capabilities to generate beautiful directory listings.

This theme provides a simple, flat interface based on
[Bootstrap 4](https://getbootstrap.com), [Font Awesome](https://fontawesome.com)
and (for easy navigation in galleries)
[lightbox2](http://lokeshdhakar.com/projects/lightbox2/). In combination with
the browser's preview capability, accessing the majority of files should be
possible, giving the user easy access without a single line of server-side
dynamic code.


## Usage

1. Install `sassc` (`sudo apt-get install -y sassc` ) and `uglifyjs`  
   (`sudo npm -g install uglify-js`) 

2. Install the FancyIndex-Module: <https://www.howtoinstall.me/ubuntu/18-04/libnginx-mod-http-fancyindex/>

3. Clone this repo: `git clone https://github.com/MikeMitterer/nginx-multi-theme`  

4. cd into nginx-multi-theme
 
   1. Configure your vhost to use the theme's resources for fancyindex:
       ```       
       location / {
           # First attempt to serve request as file, then
           # as directory, then fall back to displaying a 404.
           try_files $uri $uri/ =404;

           # autoindex on;
           # autoindex_exact_size off;
           # autoindex_format html;
           # autoindex_localtime on;

           # Fancyindex
           fancyindex on;              # Enable fancy indexes.
           fancyindex_exact_size off;  # Output human-readable file sizes.

           fancyindex_header /.theme/header.html;
           fancyindex_footer /.theme/footer.html;
           fancyindex_css_href /.theme/style.css;

           fancyindex_show_path   off;
           fancyindex_name_length 255;
           fancyindex_exact_size  off;
           fancyindex_localtime   on;
      
           # fancyindex_time_format "%B %e, %Y";

           location /.theme { 
               # After switching from theme1 to theme2 you have to 'nginx -s reload'
               # to active your new theme
               alias /var/jenkins/workspace/Documentation/NGINX-Theme/.themes/theme1;
           }   
       }
       ```


## License

The nginx-multi-theme is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

This software is distributed in the hope that it will be useful, but **WITHOUT
ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or
**FITNESS FOR A PARTICULAR PURPOSE**. A Copy of the GNU General Public License
can be found in the [LICENSE](LICENSE) file.

&copy; 2022 Mike Mitterer

## Honor 
Special Thanks to 'Alexander Haase'. His Theme <https://github.com/alehaa/nginx-fancyindex-flat-theme>
heavily inspired me to make this theme!

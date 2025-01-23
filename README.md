# Inception

besoins
• Un container Docker contenant NGINX avec TLSv1.2 ou TLSv1.3 uniquement.
• Un container Docker contenant WordPress + php-fpm (installé et configuré) uniquement sans nginx.
• Un container Docker contenant MariaDB uniquement sans nginx.
• Un volume contenant votre base de données WordPress.
• Un second volume contenant les fichiers de votre site WordPress.
• Un docker-network qui fera le lien entre vos containers.
Vos containers devront redémarrer en cas de crash.

!! MODIFIER LES :latest
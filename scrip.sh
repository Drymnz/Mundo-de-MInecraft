#!/bin/bash
# Script para instalar un servidor de Minecraft compatible con Java y Bedrock
# Para Arch Linux

# Crear directorio para el servidor
mkdir -p ~/minecraft-server
cd ~/minecraft-server

echo "Instalando dependencias necesarias..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm jdk17-openjdk screen wget unzip

# Configurar Java
echo "Configurando Java..."
sudo archlinux-java set java-17-openjdk

# Descargar Paper (un servidor optimizado de Minecraft)
echo "Descargando Paper (servidor de Minecraft)..."
wget -O paper.jar https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/196/downloads/paper-1.20.1-196.jar

# Crear un script de inicio para el servidor
echo "Creando script de inicio..."
cat > start.sh << 'EOL'
#!/bin/bash
java -Xms1G -Xmx2G -jar paper.jar nogui
EOL
chmod +x start.sh

# Iniciar el servidor una vez para generar archivos y aceptar EULA
echo "Iniciando servidor por primera vez para generar archivos..."
java -jar paper.jar --nogui --initSettings
# Aceptar EULA automáticamente
sed -i 's/eula=false/eula=true/g' eula.txt

# Descargar GeyserMC y Floodgate
echo "Descargando GeyserMC y Floodgate..."
mkdir -p plugins
cd plugins

# Descargar Geyser (permite que jugadores de Bedrock se conecten)
wget -O Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot

# Descargar Floodgate (permite autenticación sin cuenta de Java)
wget -O floodgate-spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

cd ..

echo "===== INSTALACIÓN COMPLETADA ====="
echo "Para iniciar tu servidor, ejecuta: ./start.sh"
echo ""
echo "Instrucciones para conectar:"
echo "- Jugadores Java: Conectar a la IP de tu servidor, puerto 25565"
echo "- Jugadores Bedrock: Conectar a la IP de tu servidor, puerto 19132"
echo ""
echo "Recuerda configurar los puertos en tu router/firewall:"
echo "- TCP: 25565 (Java)"
echo "- UDP: 19132 (Bedrock)"
echo ""
echo "Para más configuraciones, edita los archivos:"
echo "- Servidor: server.properties"
echo "- Geyser: plugins/Geyser-Spigot/config.yml"
echo "- Floodgate: plugins/floodgate/config.yml"
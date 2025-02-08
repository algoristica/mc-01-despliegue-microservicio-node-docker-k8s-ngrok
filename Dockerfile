# Se usa una imagen ligera de Node.js
FROM node:18-alpine

# Se establece el directorio de trabajo en el contenedor.
WORKDIR /app

# Se copia el archivo de dependencias.
COPY package*.json ./

# Se instalan las dependencias en modo producción.
RUN npm install --omit=dev

# Se copian el resto de los archivos al contenedor.
COPY . .

# Se expone el puerto que usa la aplicación.
EXPOSE 3000

# Se ejecuta el comando para ejecutar la app en producción.
CMD ["npm", "run", "start"]

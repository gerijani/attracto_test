# Build fázis átmeneti image
# A build fázisban a node:18-alpine image-t használjuk
# A node:18-alpine image egy kicsi, könnyű image, amely tartalmazza a Node.js 18-as verzióját
FROM node:18-alpine as build

WORKDIR /app

# Package fájlok másolása és függőségek telepítése
COPY package.json package-lock.json ./
RUN npm ci

# Forráskód másolása és build
COPY . .
RUN npm run build

# Futtatási image készítése
# Az nginx image használata a buildelt fájlok kiszolgálására
# A buildelt fájlok kiszolgálásához nginx image használata
FROM nginx:alpine

# Build másolása az nginx szerverbe
COPY --from=build /app/build /usr/share/nginx/html

# Nginx konfiguráció beállítása SPA alkalmazáshoz
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
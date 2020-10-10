FROM nginx:latest
EXPOSE 8080
ADD index.html /usr/share/nginx/html/
CMD ["nginx-debug", "-g", "daemon off;"]
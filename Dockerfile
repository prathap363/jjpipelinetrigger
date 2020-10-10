FROM nginx:latest
EXPOSE 8080
ADD index.jsp /usr/share/nginx/html/
CMD ["nginx-debug", "-g", "daemon off;"]
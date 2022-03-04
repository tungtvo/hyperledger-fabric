## AKC Front-end

### Dependencies:

```
"@angular-devkit/core": "^13.2.3",
"@angular/animations": "^7.1.4",
"@angular/compiler": "^7.1.4",
"@angular/core": "^7.1.4",
"@angular/forms": "^7.1.4",
"@angular/http": "^7.1.4",
"@angular/platform-browser": "^7.1.4",
"@angular/platform-browser-dynamic": "^7.1.4",
"@angular/router": "^7.1.4",
"@types/node": "~6.0.60",
"animate.css": "^3.5.2",
"bootstrap": "4.3.1",
"browserify-fs": "^1.0.0",  -> Sử dụng file system để read/write file
"core-js": "^2.4.1",      
"font-awesome": "^4.7.0",
"jquery": "^3.5.0",
"ng2-select": "^2.0.0",
"ngx-markdown": "^8.1.0",   -> Parse markdown to html
"ngx-modal": "0.0.29",      
"ngx-pagination": "^3.0.3",
"ngx-spinner": "^6.1.2",
"ngx-toastr": "^10.0.4",
"normalize.css": "^7.0.0",  -> Reset css
"npm": "^6.8.0",
"pell": "^1.0.4",           -> Text editor
"popper.js": "^1.15.0",     -> Advanced tooltip
"roboto-fontface": "^0.8.0",-> Font roboto
"rxjs": "^6.3.3",
"rxjs-compat": "^6.3.3",
"socket.io-client": "^2.2.0",
"sweetalert2": "^7.6.3",    -> Show alert
"zone.js": "^0.8.14"
```
### Build & Run devtool-frontend akc

**Troubleshooting**
```
1. Cannot find module 'node-sass' 
-> npm install --save-dev --unsafe-perm node-sass@4.14.1
-> sudo npm install --save-dev sass
2. failed Error: not found: python2
-> npm install --global windows-build-tools
```
### Docker build
```
From image node:10 and nginx:1.15
Run npm install & npm run build:prod
Copy /dist to /var/www (nginx server)
Copy nginx config to nginx server

```

 CREATE DATABASE prueba;
 \c prueba
 CREATE TABLE clientes (
     id SERIAL,
     nombre VARCHAR (50) NOT NULL,
     rut VARCHAR(9) UNIQUE NOT NULL,
     direccion VARCHAR NOT NULL,
     PRIMARY KEY(id)
 );

 CREATE TABLE categorias (
     id SERIAL,
     nombre VARCHAR(50) UNIQUE NOT NULL,
     descripcion VARCHAR,
     PRIMARY KEY (id)
 );
 
 CREATE TABLE productos (
     id SERIAL,
     nombre VARCHAR(50) UNIQUE NOT NULL,
     precio_unitario INT NOT NULL,
     descripcion VARCHAR,
     categoria_id INT NOT NULL,
     PRIMARY KEY (id),
     FOREIGN KEY (categoria_id) REFERENCES categorias(id)
 );

 CREATE TABLE facturas (
     id SERIAL,
     fecha DATE NOT NULL,
     cliente_id INT NOT NULL,
     subtotal INT NOT NULL,
     iva INT NOT NULL,
     total INT NOT NULL,
     PRIMARY KEY (id),
     FOREIGN KEY (cliente_id) REFERENCES clientes(id)
 );

 CREATE TABLE facturas_productos (
     factura_id INT NOT NULL,
     producto_id INT NOT NULL,
     cantidad INT NOT NULL,
     total_producto INT NOT NULL,
     FOREIGN KEY (factura_id) REFERENCES facturas(id),
     FOREIGN KEY (producto_id) REFERENCES productos(id)
 );

\copy clientes(nombre,rut,direccion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/clientes.csv' CSV HEADER;
\copy categorias(nombre,descripcion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/categorias.csv' CSV HEADER;
\copy productos(nombre,precio_unitario,descripcion,categoria_id) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/productos.csv' CSV HEADER;
\copy facturas(fecha,cliente_id,subtotal,iva,total) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas.csv' CSV HEADER;
\copy facturas_productos(factura_id,producto_id,cantidad,total_producto) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas_productos.csv' CSV HEADER;
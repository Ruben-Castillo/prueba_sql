 CREATE DATABASE prueba;
 \c prueba
CREATE TABLE dates (
    dates DATE UNIQUE NOT NULL,
    PRIMARY KEY(dates)
);

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
--iva y total son derivables. Se pide almacenar el subtotal. Para efectos practicos se asume el id como el número de factura.
 CREATE TABLE facturas (
     id SERIAL,
     fecha DATE NOT NULL,
     cliente_id INT NOT NULL,
     subtotal INT NOT NULL,
     PRIMARY KEY (id),
     FOREIGN KEY (cliente_id) REFERENCES clientes(id),
     FOREIGN KEY (fecha) REFERENCES dates(dates)
 );
--total_producto es derivable, pero se pide registrar
 CREATE TABLE facturas_productos (
     factura_id INT NOT NULL,
     producto_id INT NOT NULL,
     cantidad INT NOT NULL,
     total_producto INT NOT NULL,
     FOREIGN KEY (factura_id) REFERENCES facturas(id),
     FOREIGN KEY (producto_id) REFERENCES productos(id)
 );

\copy dates(dates) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/dates.csv' CSV;
\copy clientes(nombre,rut,direccion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/clientes.csv' CSV HEADER;
\copy categorias(nombre,descripcion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/categorias.csv' CSV HEADER;
\copy productos(nombre,precio_unitario,descripcion,categoria_id) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/productos.csv' CSV HEADER;
\copy facturas(fecha,cliente_id,subtotal) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas.csv' CSV HEADER;
\copy facturas_productos(factura_id,producto_id,cantidad,total_producto) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas_productos.csv' CSV HEADER;

--¿Que cliente realizó la compra más cara? (Si más de un cliente comparten la compra más cara, se mostrarán ambos clientes)
SELECT DISTINCT (nombre) FROM clientes INNER JOIN facturas ON clientes.id=facturas.cliente_id WHERE subtotal IN (SELECT MAX (subtotal) FROM facturas);

--¿Que cliente pagó sobre 100 de monto? (si en alguna factura el cliente pagó más de 100, se considera en la selección. Si el cliente ha pagado varias facturas que en total suman más de 100, pero el valor de cada factura es menos que 100, no se considera)
SELECT DISTINCT(nombre) FROM clientes INNER JOIN facturas ON clientes.id=facturas.cliente_id WHERE subtotal>100;

--¿Cuantos clientes han comprado el producto 6?
SELECT COUNT (distinct cliente_id) FROM facturas INNER JOIN facturas_productos ON facturas.id=facturas_productos.factura_id WHERE producto_id=6;
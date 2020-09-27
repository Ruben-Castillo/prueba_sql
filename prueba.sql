 CREATE DATABASE prueba;
 \c prueba
CREATE TABLE dates (
    dates DATE UNIQUE NOT NULL,
    PRIMARY KEY(dates)
);
 CREATE TABLE clientes(
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
     PRIMARY KEY (id)
 );
--Para efectos practicos se asume el id como el numero de factura
--IVA y Total son derivables, no se pide registrarlos.
 CREATE TABLE facturas (
     id SERIAL,
     fecha DATE NOT NULL,
     PRIMARY KEY (id),
     FOREIGN KEY (fecha) REFERENCES dates(dates)
 );
 CREATE TABLE facturas_productos (
     factura_id INT NOT NULL,
     producto_id INT NOT NULL,
     cantidad INT NOT NULL,
     FOREIGN KEY (factura_id) REFERENCES facturas(id),
     FOREIGN KEY (producto_id) REFERENCES productos(id)
 );
 CREATE TABLE facturas_clientes(
     factura_id INT NOT NULL,
     cliente_id INT NOT NULL,
     FOREIGN KEY(factura_id) REFERENCES facturas(id),
     FOREIGN KEY(cliente_id) REFERENCES clientes(id)
 );
 CREATE TABLE productos_categorias (
     producto_id INT NOT NULL,
     categoria_id INT NOT NULL,
     FOREIGN KEY(producto_id) REFERENCES productos(id),
     FOREIGN KEY(categoria_id) REFERENCES categorias(id)
 );
 --Por la cantidad de INSERT me pareció más eficiente importar desde archivos CSV
\copy dates(dates) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/dates.csv' CSV;
\copy clientes(nombre,rut,direccion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/clientes.csv' CSV HEADER;
\copy categorias(nombre,descripcion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/categorias.csv' CSV HEADER;
\copy productos(nombre,precio_unitario,descripcion) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/productos.csv' CSV HEADER;
\copy facturas(fecha) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas.csv' CSV HEADER;
\copy facturas_clientes(factura_id,cliente_id) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas_clientes.csv' CSV HEADER;
\copy productos_categorias(producto_id,categoria_id) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/productos_categorias.csv' CSV HEADER;
\copy facturas_productos(factura_id,producto_id,cantidad) FROM '~/Documentos/DESAFIO_LATAM/Modulo_3/prueba/facturas_productos.csv' CSV HEADER;
--Calcular el total por producto:
ALTER TABLE facturas_productos ADD COLUMN total_producto INT;
UPDATE facturas_productos SET total_producto=cantidad*t.c
FROM((SELECT id AS i, precio_unitario AS c 
FROM productos)) AS t
WHERE facturas_productos.producto_id=t.i;
--Calcular el subtotal de las facturas:
ALTER TABLE facturas ADD COLUMN subtotal INT;
UPDATE facturas SET subtotal= t.c 
FROM((SELECT factura_id AS i, SUM(total_producto) AS c 
FROM facturas_productos GROUP BY factura_id)) AS t
WHERE facturas.id=t.i;
--¿Que cliente realizó la compra más cara? (Si más de un cliente comparten la compra más cara, se mostrarán ambos clientes)
SELECT DISTINCT (nombre) FROM clientes 
INNER JOIN facturas_clientes ON clientes.id=facturas_clientes.cliente_id 
INNER JOIN facturas ON facturas_clientes.factura_id=facturas.id 
WHERE subtotal IN (SELECT MAX (subtotal) FROM facturas);
--¿Que cliente pagó sobre 100 de monto? (si en alguna factura el cliente pagó más de 100, se considera en la selección. Si el cliente ha pagado varias facturas que en total suman más de 100, pero el valor de cada factura es menos que 100, no se considera)
SELECT DISTINCT (nombre) FROM clientes 
INNER JOIN facturas_clientes ON clientes.id=facturas_clientes.cliente_id 
INNER JOIN facturas ON facturas_clientes.factura_id=facturas.id 
WHERE subtotal>100;
--¿Cuantos clientes han comprado el producto 6?
SELECT COUNT (DISTINCT cliente_id) FROM facturas_clientes
INNER JOIN facturas_productos ON facturas_clientes.factura_id=facturas_productos.factura_id
WHERE producto_id=6;






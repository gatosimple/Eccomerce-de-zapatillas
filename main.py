from bottle import route, run, template, static_file, request, redirect, response
from configs.database import Database


@route('/static/<filename>')
def server_static(filename):
    return static_file(filename, root='./static')

@route('/')
def home():
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado

    productos = db.fetchall(
        """
        SELECT p.id, p.nombre, p.modelo, ROUND(p.precio,2) as precio, p.foto, p.stock, g.nombre AS genero
        FROM productos p
        JOIN generos g ON p.genero_id = g.id
        """
    )

    return template('index', productos=productos, cliente=cliente)


@route('/contacto')
def contacto():
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado
    return template('contacto', cliente=cliente)


@route('/mujer')
def mujer():
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado
    rs = db.fetchall(
        "SELECT id, nombre, modelo, ROUND(precio,2) AS precio, stock, codigo, ROUND(ancho,2) as ancho, genero_id, foto FROM productos WHERE genero_id = 2;"
    )
    return template('mujer', productos=rs, cliente=cliente)


@route('/hombre')
def hombre():
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado
    rs = db.fetchall(
        "SELECT id, nombre, modelo, ROUND(precio,2) AS precio, stock, codigo, ROUND(ancho,2) as ancho, genero_id, foto FROM productos WHERE genero_id = 1;"
    )
    return template('hombre', productos=rs, cliente=cliente)


@route('/estilos')
def estilos():
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado
    rs = db.fetchall(
        """
        SELECT p.id, p.nombre, p.modelo, ROUND(p.precio,2) AS precio, p.foto, p.stock, 
            e.id AS estilo_id, e.nombre AS estilo 
        FROM productos p 
        INNER JOIN estilos e ON p.estilo_id = e.id;
        """
    )

    productos_por_estilo = {}
    for producto in rs:
        estilo_id = producto['estilo_id']
        nombre_estilo = producto['estilo']

        if estilo_id not in productos_por_estilo:
            productos_por_estilo[estilo_id] = {
                'nombre_estilo': nombre_estilo,  # Guardamos el nombre del estilo
                'productos': []  # Inicializamos la lista de productos
            }
        # Añadir el producto al estilo correspondiente
        productos_por_estilo[estilo_id]['productos'].append(producto)        
    
    # Ordenar los estilos por estilo_id
    productos_por_estilo = dict(sorted(productos_por_estilo.items()))

    return template('estilos', productos_por_estilo=productos_por_estilo, cliente=cliente)

@route('/producto/<producto_id:int>', method=['GET', 'POST'])
def producto_detalle(producto_id):
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado

    # Obtener detalles del producto
    producto = db.fetchone(
        """
        SELECT id, nombre, modelo, ROUND(precio,2) AS precio, stock, codigo, ROUND(ancho,2) as ancho, estilo_id, temporada_id, genero_id, foto
        FROM productos
        WHERE id = ?;
        """,
        (producto_id,)
    )

    # Obtener colores distintos del producto
    colores_disponibles = db.fetchall(
        """
        SELECT DISTINCT c.id AS color_id, c.nombre
        FROM productos_colores_tallas pct
        JOIN colores c ON pct.color_id = c.id
        WHERE pct.producto_id = ?;
        """,
        (producto_id,)
    )

    color_seleccionado = request.forms.get('color')
    talla_seleccionada = request.forms.get('talla')
    tallas_disponibles = []
    producto_color_talla_id = None

    if color_seleccionado:
        tallas_disponibles = db.fetchall(
            """
            SELECT pct.id AS producto_color_talla_id, t.id AS talla_id, 
                t.peru, t.us, t.cm, pct.stock
            FROM productos_colores_tallas pct
            JOIN tallas t ON pct.talla_id = t.id
            WHERE pct.producto_id = ? AND pct.color_id = ?;
            """,
            (producto_id, color_seleccionado)
        )

    if talla_seleccionada:
        producto_color_talla = db.fetchone(
            """
            SELECT id
            FROM productos_colores_tallas
            WHERE producto_id = ? AND color_id = ? AND talla_id = ?;
            """,
            (producto_id, color_seleccionado, talla_seleccionada)
        )
        if producto_color_talla:
            producto_color_talla_id = producto_color_talla['id']
    
    # Obtener actividades asociadas al producto
    actividades = db.fetchall(
        """
        SELECT a.nombre
        FROM productos_actividades pa
        JOIN actividades a ON pa.actividad_id = a.id
        WHERE pa.producto_id = ?;
        """,
        (producto_id,)
    )

    # Obtener colaboraciones asociadas al producto
    colaboraciones = db.fetchall(
        """
        SELECT c.nombre
        FROM productos_colaboraciones pc
        JOIN colaboraciones c ON pc.colaboracion_id = c.id
        WHERE pc.producto_id = ?;
        """,
        (producto_id,)
    )

    # Obtener materiales asociados al producto
    materiales = db.fetchall(
        """
        SELECT m.nombre
        FROM productos_materiales pm
        JOIN materiales m ON pm.material_id = m.id
        WHERE pm.producto_id = ?;
        """,
        (producto_id,)
    )
  
    # Obtener tecnologías asociadas al producto
    tecnologias = db.fetchall(
        """
        SELECT te.nombre
        FROM productos_tecnologias pt
        JOIN tecnologias te ON pt.tecnologia_id = te.id
        WHERE pt.producto_id = ?;
        """,
        (producto_id,)
    )

    # Consulta para obtener el nombre del estilo asociado al producto
    estilos = db.fetchone(
        """
        SELECT e.nombre 
        FROM productos p
        JOIN estilos e ON p.estilo_id = e.id
        WHERE p.id = ?;
        """,
        (producto_id,)
    )

    # Consulta para obtener el nombre de la temporada asociada al producto
    temporadas = db.fetchone(
        """
        SELECT t.nombre
        FROM temporadas t
        WHERE t.id = (SELECT p.temporada_id FROM productos p WHERE p.id = ?);
        """,
        (producto_id,)
    )

    # Consulta para obtener el nombre del género asociado al producto
    generos = db.fetchone(
        """
        SELECT g.nombre
        FROM productos p
        JOIN generos g ON p.genero_id = g.id
        WHERE p.id = ?;
        """,
        (producto_id,)
    )

    # Obtener comentarios asociados al producto y el cliente
    comentarios = db.fetchall(
        """
        SELECT c.mensaje, cl.nombre, cl.apellido, 
        t.nombre AS tipo_comentario
        FROM comentarios c
        JOIN clientes cl ON c.cliente_id = cl.id
        JOIN tipos_comentarios t ON c.tipo_comentario_id = t.id
        WHERE c.producto_id = ?;
        """,
        (producto_id,)
    )
    
    # if color_seleccionado:
    #     if talla_seleccionada:
    #         if producto_color_talla:
    #             if producto_color_talla_id:
    #                 print(producto['id'])
    #                 print(color_seleccionado)
    #                 print(talla_seleccionada)
    #                 print(producto_color_talla_id)

    return template('producto_detalle', producto=producto, colores_disponibles=colores_disponibles, tallas_disponibles=tallas_disponibles, color_seleccionado=color_seleccionado, talla_seleccionada=talla_seleccionada, producto_color_talla_id=producto_color_talla_id, materiales=materiales, tecnologias=tecnologias, actividades=actividades, colaboraciones=colaboraciones, estilos=estilos, temporadas=temporadas, generos=generos, comentarios=comentarios, cliente=cliente)

    
@route('/agregar_al_carrito', method='POST')
def agregar_al_carrito():
    cliente = cliente_logueado()  # Obtiene el cliente logueado
    if not cliente:
        return redirect('/login')

    cantidad = int(request.forms.get('cantidad', 1))  # Cantidad enviada desde el formulario
    producto_id = request.forms.get('producto_id')  # ID del producto
    producto_color_talla_id = request.forms.get('producto_color_talla_id')  # ID de producto_color_talla
    db = Database()

    # Verificar si el cliente tiene un carrito
    carrito = db.fetchone("SELECT id FROM carritos WHERE cliente_id = ?", (cliente['id'],))

    if not carrito:
        # Crear un carrito si no existe
        db.execute("INSERT INTO carritos (monto_final, cliente_id) VALUES (0, ?)", (cliente['id'],))
        carrito_id = db.fetchone("SELECT id FROM carritos WHERE cliente_id = ?", (cliente['id'],))['id']
    else:
        carrito_id = carrito['id']
        
    # Obtener datos del producto_color_talla
    producto_seleccionado = db.fetchone("SELECT ROUND(precio,2) AS precio FROM productos WHERE id = ?", (producto_id,))
    producto_color_talla = db.fetchone("SELECT stock FROM productos_colores_tallas WHERE id = ?", (producto_color_talla_id,))

    # if not producto_color_talla:
        # return "Producto no encontrado"

    if cantidad > producto_color_talla['stock']:
        return template('error', mensaje="No hay suficiente stock disponible")

    subtotal = producto_seleccionado['precio'] * cantidad

    # Verificar si el producto ya está en el carrito
    producto_en_carrito = db.fetchone(
        "SELECT id, cantidad FROM carritos_productos_colores_tallas WHERE carrito_id = ? AND producto_color_talla_id = ?",
        (carrito_id, producto_color_talla_id)
    )

    if producto_en_carrito:
        # Actualizar cantidad y subtotal si ya está en el carrito
        nueva_cantidad = producto_en_carrito['cantidad'] + cantidad
        nuevo_subtotal = producto_seleccionado['precio'] * nueva_cantidad
        db.execute(
            "UPDATE carritos_productos_colores_tallas SET cantidad = ?, subtotal = ? WHERE id = ?",
            (nueva_cantidad, nuevo_subtotal, producto_en_carrito['id'])
        )
    else:
        # Agregar producto al carrito
        db.execute(
            "INSERT INTO carritos_productos_colores_tallas (cantidad, subtotal, carrito_id, producto_color_talla_id) VALUES (?, ?, ?, ?)",
            (cantidad, subtotal, carrito_id, producto_color_talla_id)
        )

    # Actualizar monto final del carrito
    monto_final = db.fetchone(
        "SELECT SUM(subtotal) AS total FROM carritos_productos_colores_tallas WHERE carrito_id = ?",
        (carrito_id,)
    )['total']
    db.execute("UPDATE carritos SET monto_final = ? WHERE id = ?", (monto_final, carrito_id))

    return redirect('/carrito')

@route('/carrito')
def ver_carrito():
    cliente = cliente_logueado()
    if not cliente:
        return redirect('/login')

    db = Database()
    carrito = db.fetchone("SELECT id, monto_final FROM carritos WHERE cliente_id = ?", (cliente['id'],))

    if not carrito:
        return template('carrito', carrito_productos_colores_tallas=[], total=0)

    carrito_productos_colores_tallas = db.fetchall(
        """
        SELECT cpct.cantidad, ROUND(cpct.subtotal,2) AS subtotal, p.nombre, co.nombre AS color, t.peru AS talla
        FROM carritos_productos_colores_tallas cpct
        JOIN productos_colores_tallas pct ON cpct.producto_color_talla_id = pct.id
        JOIN productos p ON pct.producto_id = p.id
        JOIN colores co ON pct.color_id = co.id
        JOIN tallas t ON pct.talla_id = t.id
        WHERE cpct.carrito_id = ?
        """,
        (carrito['id'],)
    )

    return template('carrito', carrito_productos_colores_tallas=carrito_productos_colores_tallas, total=carrito['monto_final'], cliente=cliente)

@route('/limpiar_carrito', method='POST')
def limpiar_carrito():
    cliente = cliente_logueado()  # Obtiene el cliente logueado
    if not cliente:
        return redirect('/login')

    db = Database()
    # Obtener el carrito del cliente
    carrito = db.fetchone("SELECT id FROM carritos WHERE cliente_id = ?", (cliente['id'],))

    if carrito:
        # Eliminar todos los productos del carrito
        db.execute("DELETE FROM carritos_productos_colores_tallas WHERE carrito_id = ?", (carrito['id'],))

        # Actualizar el monto final del carrito a 0
        db.execute("UPDATE carritos SET monto_final = 0 WHERE id = ?", (carrito['id'],))

    return redirect('/carrito')

@route('/hacer_pedido', method=['GET', 'POST'])
def hacer_pedido():
    cliente = cliente_logueado()
    if not cliente:
        return redirect('/login')

    db = Database()
    carrito = db.fetchone("SELECT id, monto_final FROM carritos WHERE cliente_id = ?", (cliente['id'],))

    if not carrito:
        return redirect('/carrito')

    if request.method == 'POST':
        direccion = request.forms.get('direccion')
        distrito = request.forms.get('distrito')
        tipo_envio = request.forms.get('tipo_envio')
        
        pedidos = db.fetchall("SELECT id FROM pedidos")
        
        cant_pedidos = len(pedidos) + 1
        
        cod_pedido = f"PED-{cant_pedidos:04d}"

        # Insertar el pedido en la base de datos
        db.execute(
            """
            INSERT INTO destinos (direccion, distrito_id) VALUES (?, ?)
            """,
            (direccion, distrito)
        )
        
        destinos = db.fetchall("SELECT id FROM destinos")
        
        destino_id = len(destinos)
        
        db.execute(
            """
            INSERT INTO pedidos (cliente_id, codigo, carrito_id, destino_id, tipo_envio_id, monto_final, fecha, estado_id)
            VALUES (?, ?, ?, ?, ?, ?, datetime('now'), 1)
            """,
            (cliente['id'], cod_pedido, carrito['id'], destino_id, tipo_envio, carrito['monto_final'])
        )

        pedidos = db.fetchall("SELECT id FROM pedidos")

        pedido_id = len(pedidos)

        # Copiar productos del carrito a la tabla de productos del pedido
        productos_carrito = db.fetchall("""
            SELECT producto_color_talla_id, cantidad, subtotal
            FROM carritos_productos_colores_tallas
            WHERE carrito_id = ?
        """, (carrito['id'],))

        for producto in productos_carrito:
            db.execute("""
                INSERT INTO productos_colores_tallas_pedidos (pedido_id, producto_color_talla_id, cantidad, subtotal)
                VALUES (?, ?, ?, ?)
            """, (pedido_id, producto['producto_color_talla_id'], producto['cantidad'], producto['subtotal']))    

        # Obtener los productos del carrito con sus colores y tallas
        productos_carrito = db.fetchall("""
            SELECT p.id AS producto_id, pc.id AS producto_color_talla_id, c.id AS color_id, t.id AS talla_id, cpct.cantidad
            FROM carritos_productos_colores_tallas cpct
            JOIN productos_colores_tallas pc ON cpct.producto_color_talla_id = pc.id
            JOIN productos p ON pc.producto_id = p.id
            JOIN colores c ON pc.color_id = c.id
            JOIN tallas t ON pc.talla_id = t.id
            WHERE cpct.carrito_id = ?
        """, (carrito['id'],))

        # Actualizar el stock en la tabla productos_colores_tallas
        for producto in productos_carrito:
            producto_color_talla_id = producto['producto_color_talla_id']
            cantidad_comprada = producto['cantidad']
            producto_id = producto['producto_id']

            # Restar el stock específico
            db.execute("""
                UPDATE productos_colores_tallas
                SET stock = stock - ?
                WHERE id = ?
            """, (cantidad_comprada, producto_color_talla_id))

            # Restar el stock general del producto
            db.execute("""
                UPDATE productos
                SET stock = stock - ?
                WHERE id = ?
            """, (cantidad_comprada, producto_id))

        # Limpiar el carrito después de hacer el pedido
        db.execute("DELETE FROM carritos_productos_colores_tallas WHERE carrito_id = ?", (carrito['id'],))
        db.execute("UPDATE carritos SET monto_final = 0 WHERE id = ?", (carrito['id'],))

        return redirect('/pedidos')

    distritos = db.fetchall("SELECT id, nombre FROM distritos WHERE provincia_id = 128")
    tipos_envios = db.fetchall("SELECT id, nombre FROM tipos_envios")
    return template('hacer_pedido', cliente=cliente, tipos_envios=tipos_envios, distritos=distritos)

@route('/pedidos')  
def ver_pedidos():
    cliente = cliente_logueado()
    if not cliente:
        return redirect('/login')

    db = Database()
    pedidos = db.fetchall(
        """
        SELECT fecha, p.id, p.codigo, e.nombre as nombre_estado, d.direccion as direccion, di.nombre as distrito, te.nombre as nombre_envio, ROUND(monto_final,2) AS monto_final
        FROM pedidos p
        JOIN destinos d ON p.destino_id = d.id
        JOIN distritos di ON d.distrito_id = di.id
        JOIN tipos_envios te ON p.tipo_envio_id = te.id
        JOIN estados e ON p.estado_id = e.id
        WHERE p.cliente_id = ?
        """,
        (cliente['id'],)
    )

    return template('pedidos', pedidos=pedidos, cliente=cliente)

@route('/pedido_detalle/<pedido_id:int>', method='GET')
def ver_detalle_pedido(pedido_id):
    cliente = cliente_logueado()
    if not cliente:
        return redirect('/login')

    db = Database()   
    # Obtener información general del pedido
    pedido = db.fetchone("""
        SELECT p.codigo, p.fecha, ROUND(p.monto_final,2) AS monto_final, e.nombre AS estado, te.nombre AS tipo_envio, d.direccion, di.nombre AS distrito
        FROM pedidos p
        JOIN estados e ON p.estado_id = e.id
        JOIN tipos_envios te ON p.tipo_envio_id = te.id
        JOIN destinos d ON p.destino_id = d.id
        JOIN distritos di ON d.distrito_id = di.id
        WHERE p.id = ? AND p.cliente_id = ?
        """, (pedido_id, cliente['id']))

    # Obtener información específica del pedido    
    productos_colores_tallas_pedidos = db.fetchall("""
        SELECT p.nombre AS producto, c.nombre AS color, t.peru AS talla, 
            pctp.cantidad, ROUND(pctp.subtotal,2) AS subtotal
        FROM productos_colores_tallas_pedidos pctp
        JOIN productos_colores_tallas pct ON pctp.producto_color_talla_id = pct.id
        JOIN productos p ON pct.producto_id = p.id
        JOIN colores c ON pct.color_id = c.id
        JOIN tallas t ON pct.talla_id = t.id
        WHERE pctp.pedido_id = ?
        """, (pedido_id,))  

    return template('pedido_detalle', cliente=cliente, pedido=pedido, productos_colores_tallas_pedidos=productos_colores_tallas_pedidos) 

@route('/login', method=['GET', 'POST'])
def login():
    if request.method == 'POST':
        dni = request.forms.get('dni')
        nombre = request.forms.get('nombre')

        db = Database()
        cliente = db.fetchone(
            "SELECT id, nombre FROM clientes WHERE dni = ? AND nombre = ?",
            (dni, nombre)
        )

        if cliente:
            response.set_cookie('cliente_id', str(cliente['id']), secret='clave_secreta')
            return redirect('/')
        else:
            return template('login', error="DNI o nombre incorrectos.")

    return template('login', error=None)

def cliente_logueado():
    cliente_id = request.get_cookie('cliente_id', secret='clave_secreta')
    if cliente_id:
        db = Database()
        cliente = db.fetchone(
            "SELECT id, nombre, genero_id FROM clientes WHERE id = ?",
            (cliente_id,)
        )
        return cliente  # Devuelve los datos del cliente logueado
    return None  # Si no hay cookie o no coincide, no está logueado

@route('/logout')
def logout():
    response.delete_cookie('cliente_id')
    return redirect('/')

@route('/agregar_talla', method=['GET', 'POST'])
def agregar_talla():
    db = Database()
    cliente = cliente_logueado()  # Verifica si el cliente está logueado

    if not cliente:
        return redirect('/login')

    if request.method == 'POST':
        # Obtener los datos del formulario
        peru = request.forms.get('peru')
        us = request.forms.get('us')
        cm = request.forms.get('cm')

        # Validar que los datos no estén vacíos
        if not peru or not us or not cm:
            return template('agregar_talla', cliente=cliente, error="Todos los campos son obligatorios")

        # Insertar en la base de datos
        try:
            db.execute('INSERT INTO tallas (peru, us, cm) VALUES (?, ?, ?)', (peru, us, cm))
            return redirect('/lista_tallas')  # Redirigir a una página con la lista de tallas
        except Exception as e:
            return template('agregar_talla', cliente=cliente, error=f"Error al guardar: {str(e)}")

    # Mostrar el formulario si el método es GET
    return template('agregar_talla', cliente=cliente)

if __name__ == '__main__':
    run(host='localhost', port=8080, reloader=True)

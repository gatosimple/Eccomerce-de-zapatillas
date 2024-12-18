<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Pedido</title>
    <link rel="stylesheet" href="/static/styles.css">
</head>
<body>
    <header>
        <nav>
            <a href="/">Inicio</a>
            <a href="/mujer">Mujer</a>
            <a href="/hombre">Hombre</a>
            <a href="/estilos">Estilos</a>
            <a href="/contacto">Nosotros</a>
            <a href="/carrito">Carrito</a>
            <a href="/pedidos">Pedidos</a>
            % if cliente and cliente['genero_id'] == 1:
            <span>Bienvenido, {{ cliente['nombre'] }} | <a href="/logout">Cerrar Sesión</a></span>
            % elif cliente and cliente['genero_id'] == 2:
            <span>Bienvenida, {{ cliente['nombre'] }} | <a href="/logout">Cerrar Sesión</a></span>
            % else:
            <a href="/login">Iniciar Sesión</a>
            % end
            <a href="/agregar_talla">Agregar Talla</a>
        </nav>
    </header>

    <div class="banner">
        <h1>Detalle del Pedido</h1>
        <p>{{ pedido['codigo'] }}</p>
    </div>

    <div class="order-detail-container">
        <div class="order-info">
            <div class="info-group">
                <span class="info-label">Fecha:</span>
                <span class="info-value">{{ pedido['fecha'] }}</span>
            </div>
            <div class="info-group">
                <span class="info-label">Dirección de Envío:</span>
                <span class="info-value">{{ pedido['direccion'] }}</span>
            </div>
            <div class="info-group">
                <span class="info-label">Tipo de Envío:</span>
                <span class="info-value">{{ pedido['tipo_envio'] }}</span>
            </div>
            <div class="info-group">
                <span class="info-label">Estado del Pedido:</span>
                <span class="info-value status-badge">{{ pedido['estado'] }}</span>
            </div>
        </div>

        <div class="order-products">
            <h2>Productos del Pedido</h2>
            <div class="products-table">
                <table>
                    <thead>
                        <tr>
                            <th>Producto</th>
                            <th>Color</th>
                            <th>Talla</th>
                            <th>Cantidad</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        % for producto in productos_colores_tallas_pedidos:
                        <tr>
                            <td>{{ producto['producto'] }}</td>
                            <td>{{ producto['color'] }}</td>
                            <td>{{ producto['talla'] }}</td>
                            <td>{{ producto['cantidad'] }}</td>
                            <td class="price">S/.{{ producto['subtotal'] }}</td>
                        </tr>
                        % end
                    </tbody>
                </table>
            </div>
            <div class="order-total">
                <span class="total-label">Total:</span>
                <span class="total-amount">S/.{{ pedido['monto_final'] }}</span>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Pedidos</title>
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
        <h1>Mis Pedidos</h1>
        <p>Historial de tus compras</p>
    </div>

    <div class="orders-container">
        % if pedidos:
        <div class="orders-table">
            <table>
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Fecha</th>
                        <th>Dirección</th>
                        <th>Distrito</th>
                        <th>Estado</th>
                        <th>Tipo de Envío</th>
                        <th>Monto Final</th>
                    </tr>
                </thead>
                <tbody>
                    % for pedido in pedidos:
                    <tr>
                        <td><a href="/pedido_detalle/{{ pedido['id'] }}" class="order-link">{{ pedido['codigo'] }}</a></td>
                        <td>{{ pedido['fecha'] }}</td>
                        <td>{{ pedido['direccion'] }}</td>
                        <td>{{ pedido['distrito'] }}</td>
                        <td><span class="order-status">{{ pedido['nombre_estado'] }}</span></td>
                        <td>{{ pedido['nombre_envio'] }}</td>
                        <td class="order-total">S/. {{ round(pedido['monto_final'], 2) }}</td>
                    </tr>
                    % end
                </tbody>
            </table>
        </div>
        % else:
        <p class="no-orders">No tienes pedidos realizados.</p>
        % end
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
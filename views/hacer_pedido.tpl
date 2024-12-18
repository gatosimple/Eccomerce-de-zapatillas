<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hacer Pedido</title>
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
        <h1>Hacer Pedido</h1>
        <p>Complete los detalles de envío</p>
    </div>

    <div class="order-container">
        <form action="/hacer_pedido" method="post" class="order-form">
            <div class="form-group">
                <label for="direccion">Dirección:</label>
                <input type="text" id="direccion" name="direccion" required>
            </div>

            <div class="form-group">
                <label for="distrito">Distrito:</label>
                <select id="distrito" name="distrito" required>
                    % for distrito in distritos:
                    <option value="{{ distrito['id'] }}">{{ distrito['nombre'] }}</option>
                    % end
                </select>
            </div>

            <div class="form-group">
                <label for="tipo_envio">Tipo de Envío:</label>
                <select id="tipo_envio" name="tipo_envio" required>
                    % for tipo in tipos_envios:
                    <option value="{{ tipo['id'] }}">{{ tipo['nombre'] }}</option>
                    % end
                </select>
            </div>

            <button type="submit" class="submit-btn">Confirmar Pedido</button>
        </form>
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
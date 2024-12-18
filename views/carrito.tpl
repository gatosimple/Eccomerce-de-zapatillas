<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrito de Compras</title>
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
        <h1>Tu Carrito de Compras</h1>
    </div>

    <div class="cart-container">
        % if carrito_productos_colores_tallas:
        <div class="cart-table">
            <table>
                <thead>
                    <tr>
                        <th>Cantidad</th>
                        <th>Nombre del Producto</th>
                        <th>Color</th>
                        <th>Talla</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    % for producto in carrito_productos_colores_tallas:
                    <tr>
                        <td>{{ producto['cantidad'] }}</td>
                        <td>{{ producto['nombre'] }}</td>
                        <td>{{ producto['color'] }}</td>
                        <td>{{ producto['talla'] }}</td>
                        <td>S/ {{ producto['subtotal'] }}</td>
                    </tr>
                    % end
                </tbody>
            </table>
        </div>

        <div class="cart-total">
            <h3>Total: S/ {{ round(total, 2) }}</h3>
        </div>

        <div class="cart-buttons">
            <form action="/limpiar_carrito" method="post">
                <button type="submit" class="btn-clear">Limpiar Carrito</button>
            </form>

            <form action="/hacer_pedido" method="get">
                <button type="submit" class="btn-order">Hacer Pedido</button>
            </form>
        </div>
        % else:
        <p class="empty-cart">No hay productos en el carrito.</p>
        % end
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
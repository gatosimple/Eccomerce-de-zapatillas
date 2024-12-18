<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agregar Talla</title>
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
            % elif cliente and cliente['genero'] == 2:
            <span>Bienvenida, {{ cliente['nombre'] }} | <a href="/logout">Cerrar Sesión</a></span>
            % else:
            <a href="/login">Iniciar Sesión</a>
            % end
            <a href="/agregar_talla">Agregar Talla</a>
        </nav>
    </header>

    <div class="banner">
        <h1>Agregar una nueva talla</h1>
    </div>

    <div class="form-container">
        <form action="/agregar_talla" method="POST" class="size-form">
            <div class="form-group">
                <label for="peru">Talla Perú:</label>
                <input type="text" id="peru" name="peru" required>
            </div>

            <div class="form-group">
                <label for="us">Talla US:</label>
                <input type="text" id="us" name="us" required>
            </div>

            <div class="form-group">
                <label for="cm">Talla en cm:</label>
                <input type="text" id="cm" name="cm" required>
            </div>

            <button type="submit" class="submit-btn">Agregar Talla</button>
        </form>
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
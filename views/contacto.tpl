<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contacto</title>
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
        <h1>Contacto</h1>
        <p>Estamos aquí para ayudarte</p>
    </div>

    <div class="contact-container">
        <h2>Información de Contacto</h2>
        <div class="contact-info">
            <p><strong>Teléfono:</strong> +51 910 096 345</p>
            <p><strong>Correo Electrónico:</strong> RunnersChoice@gmail.com</p>
            <p><strong>Dirección:</strong> Calle Los Álamos, Urbanización Santa María, 4ta Etapa, Lote 12, Mz F31, Carabayllo, Lima</p>
        </div>
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Runner's Choice</title>
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
            <a href="/agregar_talla">Agregar Talla</a>
        </nav>
    </header>

    <div class="banner">
        <h1>Iniciar Sesión</h1>
        <p>Bienvenido a Runner's Choice</p>
    </div>

    <div class="login-container">
        <form action="/login" method="post" class="login-form">
            <div class="form-group">
                <label for="dni">DNI:</label>
                <input type="text" id="dni" name="dni" required>
            </div>

            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" required>
            </div>

            <button type="submit" class="login-btn">Iniciar Sesión</button>
        </form>
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>